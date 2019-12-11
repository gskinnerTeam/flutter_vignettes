import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared/env.dart';

import 'demo.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  static String _pkg = "parallax_travel_cards_hero";
  static String get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: 'Hero Travel Card',
      theme: ThemeData(brightness: Brightness.light),
      home: HeroCardDemo(),
    );
  }
}
