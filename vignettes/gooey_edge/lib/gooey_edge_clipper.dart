import 'package:flutter/material.dart';
import 'gooey_edge.dart';

class GooeyEdgeClipper extends CustomClipper<Path> {
  GooeyEdge edge;
  double margin;

  GooeyEdgeClipper(this.edge, {this.margin=0.0}) : super();

  @override
  Path getClip(Size size) {
    return edge.buildPath(size, margin:margin);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // TODO: optimize?
  }
}