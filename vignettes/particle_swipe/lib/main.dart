import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:particle_swipe/components/particle_app_bar.dart';
import 'package:shared/env.dart';

import 'components/colored_safe_area.dart';
import 'demo.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static String _pkg = "particle_swipe";

  static String get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Particle Swipe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(brightness: Brightness.dark),
        canvasColor: Color(0xFF161719),
        accentColor: Color(0xffc932d9),
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white, fontFamily: 'OpenSans'),
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Column(children: [
            ParticleAppBar(),
            Flexible(child: ParticleSwipeDemo()),
          ]),
        ),
      ),
    );
  }
}
