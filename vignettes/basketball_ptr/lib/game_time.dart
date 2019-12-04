import 'package:flutter/material.dart';

import './theme_info.dart';
import './demo_data.dart';

import './main.dart';

class GameTime extends StatelessWidget {
  final BasketballGameData data;

  GameTime({@required this.data});

  @override
  Widget build(context) {
    String quarterString;
    switch (data.quarter) {
      case BasketballGameQuarter.Q1:
        quarterString = 'Q1';
        break;
      case BasketballGameQuarter.Q2:
        quarterString = 'Q2';
        break;
      case BasketballGameQuarter.Q3:
        quarterString = 'Q3';
        break;
      case BasketballGameQuarter.Q4:
        quarterString = 'Q4';
        break;
      default:
        break;
    }

    // Use the dart spread operator to change the ui based off of the data model
    return Row(children: [
      if (data.quarter == BasketballGameQuarter.HALF_TIME) ...{
        Container(
          color: ThemeInfo.accent2,
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 14),
          child: Text('Half Time',
              style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w600, fontFamily: 'OpenSans', package: App.pkg)),
        ),
      } else if (data.quarter == BasketballGameQuarter.FINISHED) ...{
        Container(
          color: ThemeInfo.accent3,
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 14),
          child: Text('Final Score',
              style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w600, fontFamily: 'OpenSans', package: App.pkg)),
        ),
      } else ...{
        Container(
          color: ThemeInfo.accent2,
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 14),
          child: Text(quarterString,
              style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w600, fontFamily: 'OpenSans', package: App.pkg)),
        ),
        Container(
          color: ThemeInfo.accent3,
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 14),
          child: Text('${data.time.inMinutes}:${(data.time.inSeconds - (data.time.inMinutes * 60)).toString().padLeft(2, '0')}',
              style: TextStyle(color: Colors.black, fontSize: 8, fontWeight: FontWeight.w600, fontFamily: 'OpenSans', package: App.pkg)),
        ),
      }
    ]);
  }
}
