import 'package:flutter/material.dart';
import 'package:shared/env.dart';

import './demo.dart';

void main() => runApp(App());


class App extends StatelessWidget {

  static String _pkg = "dark_ink_transition";
  static String get pkg => Env.getPackage(_pkg);

  @override
  Widget build(context) {
    return MaterialApp(
      home: DarkInkDemo(),
    );
  }
}
