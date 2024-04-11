import 'package:flutter/material.dart';
import 'package:shared/env.dart';
import 'package:shared/ui/app_scroll_behavior.dart';
import 'demo.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static String _pkg = "constellations_list";
  static String? get pkg => Env.getPackage(_pkg);
  static String get bundle => Env.getBundle(_pkg);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: ConstellationsListDemo(),
    );
  }
}
