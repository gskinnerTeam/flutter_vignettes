import 'package:flutter/material.dart';
import 'package:shared/env.dart';
import 'package:shared/ui/app_scroll_behavior.dart';

import './demo.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static String _pkg = 'indie_3d';
  static String? get pkg => Env.getPackage(_pkg);
  static String get bundle => Env.getBundle(_pkg);

  @override
  Widget build(context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: Indie3dHome(),
    );
  }
}
