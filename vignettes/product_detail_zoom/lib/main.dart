import 'package:flutter/material.dart';
import 'package:shared/env.dart';

import 'demo.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  static String _pkg = "product_detail_zoom";

  static String get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    const title = '3D Product Detail Zoom';
    return MaterialApp(
      title: title,
      themeMode: ThemeMode.dark,
      home: ProductDetailZoomDemo(),
    );
  }
}
