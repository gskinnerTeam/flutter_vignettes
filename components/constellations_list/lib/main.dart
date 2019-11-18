import 'package:shared/env.dart';

import 'demo.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  static String _pkg = "constellations_list";
  static String get pkg => Env.getPackage(_pkg);
  static String get bundle => Env.getBundle(_pkg);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConstellationsListDemo(),
    );
  }
}
