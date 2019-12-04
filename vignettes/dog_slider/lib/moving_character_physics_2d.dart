import 'dart:ui';

class MovingCharacterPhysics2d {
  double get position => _x;

  bool get flipView => _flipView;

  bool get atDestination => _atDestination;

  Function onDestinationReached;
  Function onMoveStarted;

  double targetX;
  double acc;
  double maxSpeed;
  double friction;
  double chaseDelay;
  double stopDistance;

  double _x = 50;
  double _vel = 0;
  bool _canChase = false;
  bool _flipView = false;
  bool _atDestination = true;
  double _lastTickTime = 0;
  int _lastArrivalTime = 0;

  MovingCharacterPhysics2d(
      {startX,
      this.targetX = 100,
      this.onDestinationReached,
      this.onMoveStarted,
      this.acc = .3,
      this.maxSpeed = 3.5,
      this.friction = .11,
      this.chaseDelay = 0,
      this.stopDistance = 30}) {
    _x = startX ?? 0;
  }

  void update(Duration elapsed) {
    //Update internal state
    _canChase = _getElapsed(_lastArrivalTime) > chaseDelay;
    //Tick physics
    double t = elapsed.inMicroseconds * 1.0e-6;
    if (_lastTickTime == null) {
      _lastTickTime = t;
    }
    _updatePhysics(t - _lastTickTime);
    _lastTickTime = t;
  }

  void _updatePhysics(double dt) {
    //Apply velocity
    _x += _vel * dt * 60;
    //Apply friction
    _vel *= (1 - friction);
    //If we're not close to our target, accelerate towards it
    if (_canChase && (_x - targetX).abs() > stopDistance) {
      if (_atDestination && onMoveStarted != null) {
        onMoveStarted();
      }
      _atDestination = false;
      //Accelerate
      //print(_vel);
      var dir = (targetX - _x).sign;
      _vel += acc * dir; // * dt * 60;
      //Make sure we don't exceed topSpeed
      if (_vel.abs() > maxSpeed) {
        _vel = maxSpeed * _vel.sign;
      }
      _flipView = _vel < 0;
    }
    //Zero-out velocity when it gets too small
    if (_vel.abs() < .1) {
      _vel = 0;
    }
    if (!_atDestination && _vel == 0 && _canChase) {
      _atDestination = true;
      _lastArrivalTime = DateTime.now().millisecondsSinceEpoch;
      if (onDestinationReached != null) {
        onDestinationReached();
      }
    }
  }

  int _getElapsed(int value) {
    return DateTime.now().millisecondsSinceEpoch - value;
  }
}
