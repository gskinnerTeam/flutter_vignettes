import 'package:flutter/material.dart';

import 'main.dart';

class ScoresAppBar extends StatelessWidget {
  @override
  Widget build(context) {
    //  Build a app bar that has a gradient, title and some buttons
    return Container(
      height: 90,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFF1094A7),
            const Color(0xFFF37B4D),
          ],
          tileMode: TileMode.clamp,
        ),
      ),
      // Avoid cutting off the buttons with safe area
      child: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20,
              ),
              Padding(padding: EdgeInsets.all(20)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('LIVE SCORES', style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'FjallaOne', package: App.pkg)),
                  Text('OCT 24, 2019', style: TextStyle(fontSize: 10, color: Colors.white, fontFamily: 'OpenSans', package: App.pkg)),
                ],
              ),
              Padding(padding: EdgeInsets.all(20)),
              Icon(
                Icons.calendar_today,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
