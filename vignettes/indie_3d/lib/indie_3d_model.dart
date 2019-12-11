import 'package:flutter/material.dart';

import 'package:shared/ui/widget_model.dart';

import './indie_3d_model_controller.dart';

class Indie3dModel extends StatelessWidget {

  final Indie3dModelController controller;
  final int pageIndex;

  Indie3dModel({ @required this.controller, this.pageIndex = 0 });

  @override
  Widget build(context) {
    return Stack(
      fit: StackFit.expand,
      children: controller.meshInstances != null ? <int>[0, 1, 2, 3, 4, 5].map(
        (int index) {
          return Container(
            child: CustomPaint(
              painter: MeshCustomPainter(controller.meshInstances[pageIndex * 6 + index]),
            ),
          );
        }
      ).toList() : [],
    );
  }
}

