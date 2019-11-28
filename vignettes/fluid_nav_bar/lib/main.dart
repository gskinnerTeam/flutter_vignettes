import 'package:flutter/material.dart';

import './demo.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FluidNavBarDemo(),
    );
  }
}
