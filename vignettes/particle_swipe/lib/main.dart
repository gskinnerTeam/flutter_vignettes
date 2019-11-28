import 'package:flutter/material.dart';
import 'package:shared/env.dart';

import 'demo.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  static String _pkg = "particle_swipe";
  static String get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Particle Swipe',
        theme: ThemeData(
          appBarTheme: AppBarTheme(brightness: Brightness.dark),
          canvasColor: Color(0xFF161719),
          accentColor: Color(0xffc932d9),
          textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white, fontFamily: 'OpenSans'),
          iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
        ),
        home: ParticleSwipeDemo());
  }
}
