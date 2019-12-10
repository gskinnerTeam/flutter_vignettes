import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/env.dart';

import 'demo.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  static String _pkg = "plant_forms";
  static String get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Forms',
      home: PlantFormsDemo(),
    );
  }
}
