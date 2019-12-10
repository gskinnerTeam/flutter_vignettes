import 'package:flutter/material.dart';
import 'package:spending_tracker/main.dart';

class ProfileIcon extends StatelessWidget {
  @override
  Widget build(context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Image.asset('images/headshot.png', package: App.pkg),
    );
  }
}
