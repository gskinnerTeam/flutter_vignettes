import 'package:flutter/material.dart';

import 'package:shared/env.dart';

import './demo.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  static String _pkg = "basketball_ptr";
  static String get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    return BasketballPTRDemo();
  }
}
