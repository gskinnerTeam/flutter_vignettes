import 'package:flutter/material.dart';
import 'package:shared/env.dart';
import 'package:shared/ui/app_scroll_behavior.dart';

import 'demo.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static String _pkg = "dog_slider";
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      home: DogSliderDemo(),
    );
  }
}
