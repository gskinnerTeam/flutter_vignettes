import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:vector_math/vector_math.dart' as vec32;

import 'package:shared/ui/widget_model.dart';

import 'main.dart';


class Indie3dModelController extends ChangeNotifier {
  VertexMesh _meshTorus;
  VertexMesh _meshStar;
  VertexMesh _meshCube;

  List<vec32.Vector3> _positions;
  List<vec32.Quaternion> _rotations;
  List<vec32.Vector3> _scales;

  List<vec32.Vector3> _linearVelocities;
  List<vec32.Vector3> _angularVelocities;
  List<vec32.Vector3> _constantAngularVelocities;

  List<VertexMeshInstance> _meshInstances;

  vec32.Matrix4 matProj;
  vec32.Matrix4 matView;

  double _cameraOffset = 0.0;
  double _targetCameraOffset = 0.0;

  double _lastTime;
  Ticker _ticker;

  math.Random _rng;

  void init(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    _setCamera(0.0);
    setView(appSize);

    _rng = math.Random.secure();

    _loadMeshs(context);
  }

  bool get initialized => _ticker != null;

  List<VertexMeshInstance> get meshInstances => _meshInstances;

  Future<void> _loadMeshs(BuildContext context) async {
    _meshTorus = await loadVertexMeshFromOBJAsset(context, "${App.bundle}/assets", 'torus.obj');
    _meshStar = await loadVertexMeshFromOBJAsset(context, "${App.bundle}/assets", 'star.obj');
    _meshCube = await loadVertexMeshFromOBJAsset(context, "${App.bundle}/assets", 'cube.obj');

    _initInstances();

    _ticker = Ticker(_handleTick);
    _ticker.start();
  }

  void _initInstances() async {
    _meshInstances = List<VertexMeshInstance>();
    _positions = List<vec32.Vector3>();
    _rotations = List<vec32.Quaternion>();
    _scales = List<vec32.Vector3>();

    _linearVelocities = List<vec32.Vector3>();
    _angularVelocities = List<vec32.Vector3>();
    _constantAngularVelocities = List<vec32.Vector3>();
    for (int i = 0; i < 36; ++i) {
      VertexMesh mesh;
      if (i < 12) {
        mesh = _meshTorus;
      } else if (i < 24) {
        mesh = _meshStar;
      } else {
        mesh = _meshCube;
      }
      _meshInstances.add(VertexMeshInstance(mesh));

      _positions.add(vec32.Vector3.zero());
      _rotations.add(vec32.Quaternion.identity());
      _scales.add(vec32.Vector3.all(1.0));

      _linearVelocities.add(vec32.Vector3.zero());
      _angularVelocities.add(vec32.Vector3.zero());
      _constantAngularVelocities.add(vec32.Vector3.zero());
    }


    // Set initial values
    for (var p in _positions) {
      p.x = _rng.nextDouble() * 8 - 4;
      p.y = _rng.nextDouble() * 28 - 19;
      p.z = _rng.nextDouble() * 4 - 4;
    }
    // Distribute better
    for (int i = 0; i < 200; ++i) {
      for (int j = 0; j < _positions.length; ++j) {
        for (int k = j + 1; k < _positions.length; ++k) {
          final p0 = _positions[j];
          final p1 = _positions[k];
          final p0p1 = p1 - p0;
          final dist = p0p1.xy.length;
          if (dist < 5.0) {
            // Push both objects in a random direction
            final norm = vec32.Vector3(
                _rng.nextDouble() * 2 - 1,
                _rng.nextDouble() * 2 - 1,
                0.0).normalized();

            p0.add(-norm * 0.2);
            p1.add(norm * 0.2);

            // Clamp values
            p0.x = p0.x.clamp(-5.0, 5.0);
            p1.x = p1.x.clamp(-5.0, 5.0);
          }
        }
      }
    }

    _rotations.forEach((vec32.Quaternion quaternion) =>
      quaternion.setAxisAngle(
        vec32.Vector3(
          _rng.nextDouble() * 2.0 - 1.0,
          _rng.nextDouble() * 2.0 - 1.0,
          _rng.nextDouble() * 2.0 - 1.0,
        ),
      _rng.nextDouble() * math.pi * 2.0,
      ));

    _constantAngularVelocities.forEach((vec32.Vector3 vel) {
      vel.x = _rng.nextDouble() * 1.0 - 0.5;
      vel.y = _rng.nextDouble() * 1.0 - 0.5;
      vel.z = _rng.nextDouble() * 1.0 - 0.5;
    });

    _setTransform();
  }

  set cameraOffset(double offset) => _targetCameraOffset = offset;

  void triggerTap(BuildContext context, Offset position, int page) {
    // Convert the position into ndc coords then into world space coords to compare
    // with the meshs position

    // Calculate world space (0, 0, 0) in ndc space
    double cameraZ = 0.0;
    {
      final camNDC = (matProj * matView).transform(vec32.Vector4(0.0, 0.0, -2.0, 1.0));
      if (camNDC.w != 0.0) {
        camNDC.x /= camNDC.w;
        camNDC.y /= camNDC.w;
        camNDC.z /= camNDC.w;
      }
      cameraZ = camNDC.z;
    }

    final appSize = MediaQuery.of(context).size;
    final ndc = vec32.Vector4(
        position.dx / appSize.width * 2.0 - 1.0,
        (position.dy / appSize.height * 2.0 - 1.0) * -1.0,
        cameraZ,
        1.0
    );

    vec32.Matrix4 matrix = vec32.Matrix4.inverted(matProj * matView);
    vec32.Vector4 world = matrix.transform(ndc);
    if (world.w != 0.0) {
      world.x /= world.w;
      world.y /= world.w;
      world.z /= world.w;
    }
    print(world);

    // Apply forces to objects
    for (int i = page * 12; i < page * 12 + 12; ++i) {
      final force = _positions[i] - vec32.Vector3(world.x, world.y, _positions[i].z);
      final tangentForce = force.cross(vec32.Vector3(0.0, 0.0, -1.0));
      _linearVelocities[i] += force.normalized() * (8.0 / force.length).clamp(0.0, 24.0);
      _angularVelocities[i] += tangentForce.normalized() * 4.0;
    }

  }

  void _setCamera(double xOffset) {
    matView = vec32.makeViewMatrix(
        vec32.Vector3(-xOffset, 0.0, 5.2),
        vec32.Vector3(-xOffset, 0.0, 0.0),
        vec32.Vector3(0.0, 1.0, 0.0)
    );

  }

  void setView(Size size) {
    matProj = vec32.makePerspectiveMatrix(
        math.pi / 2.0,
        size.width / size.height,
        0.01,
        100.0);
  }


  void _setTransform() {
    for (int i = 0; i < _meshInstances.length; ++i) {
      final meshInstance = _meshInstances[i];
      final matModel = vec32.Matrix4.compose(_positions[i], _rotations[i], _scales[i]);

      meshInstance.setTransform(matView * matModel, matProj);
    }

    notifyListeners();
  }

  void _handleTick(Duration duration) {

    final double time = duration.inMicroseconds.toDouble() * 1e-6;
    if (_lastTime == null) {
      _lastTime = time;
    }
    final double dt = time - _lastTime;
    _lastTime = time;

    const kDrag = 0.2;

    for (int i = 0; i < _meshInstances.length; ++i) {
      // Apply drag (for a correct interaction we would
      // also multiply by the area of the object tangent to the velocity direction
      // but thats hard to calculate for arbitrary 3D shapes and we don't care that much here)
      final lvLength  = _linearVelocities[i].length;
      if (lvLength.compareTo(0.0) != 0) {
        _linearVelocities[i]
            -= _linearVelocities[i].normalized() * 0.5 * kDrag * lvLength;
      }
      final avLength = _angularVelocities[i].length;
      if (avLength.compareTo(0.0) != 0) {
        _angularVelocities[i]
            -= _angularVelocities[i].normalized() * 0.5 * kDrag * avLength;
      }
      // Integrate velocity factors
      _positions[i].y += 1.0 * dt;
      _positions[i] += _linearVelocities[i] * dt;
      // Integrate the angular velocity using the quaternion integration equation
      _rotations[i] = quaternionExponent(vec32.Quaternion(
          (_angularVelocities[i].x + _constantAngularVelocities[i].x) * 0.5 * dt,
          (_angularVelocities[i].y + _constantAngularVelocities[i].y) * 0.5 * dt,
          (_angularVelocities[i].z + _constantAngularVelocities[i].z) * 0.5 * dt,
          0.0,
        )) * _rotations[i];
      if (_positions[i].y >= 16.0) {
        _positions[i].y = -16.0;
      }
    }

    // Update camera
    _cameraOffset += (_targetCameraOffset - _cameraOffset) * 4 * dt;
    _setCamera(_cameraOffset);

    _setTransform();
  }

}

vec32.Quaternion quaternionExponent(vec32.Quaternion quaternion) {
  final ew = math.exp(quaternion.w);
  final v = vec32.Vector3(quaternion.x, quaternion.y, quaternion.z);
  final vlength = v.length;
  final cosv = math.cos(vlength);
  final sinv = math.sin(vlength);

  final w = ew * cosv;

  if (vlength.compareTo(0) == 0) {
    return vec32.Quaternion(0.0, 0.0, 0.0, w);
  }

  final x = ew * v.x / vlength * sinv;
  final y = ew * v.y / vlength * sinv;
  final z = ew * v.z / vlength * sinv;

  return vec32.Quaternion(x, y, z, w);
}

