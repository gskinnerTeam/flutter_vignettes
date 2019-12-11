import 'package:flutter/material.dart';

import './theme_info.dart';
import './demo_data.dart';
import './game_time.dart';
import './game_score.dart';
import 'main.dart';

class GameListItem extends StatelessWidget {
  final BasketballGameData data;

  GameListItem({@required this.data});

  @override
  Widget build(context) {
    return Container(
      height: 140,
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 9),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Home team logo
          SizedBox(
            width: 64,
            height: 64,
            child: Image(
              image: AssetImage(data.homeTeamLogoPath, package: App.pkg),
            ),
          ),
          Text(data.homeTeamCity, style: ThemeInfo.textStyleTeam),
          Text(data.homeTeamName, style: ThemeInfo.textStyleTeam),
        ]),
        Padding(padding: EdgeInsets.all(4)),
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          // Propagate data down to the widgets that need it
          GameTime(data: data),
          GameScore(data: data),
          // The Highlights text has a rounded border
          Container(
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: ThemeInfo.background0),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 18),
            child: Text(
              'HIGHLIGHTS',
              style: ThemeInfo.textStyleHighlights,
            ),
          ),
        ]),
        Padding(padding: EdgeInsets.all(4)),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Away team logo
          SizedBox(
            width: 64,
            height: 64,
            child: Image(
              image: AssetImage(data.awayTeamLogoPath, package: App.pkg),
            ),
          ),
          Text(data.awayTeamCity, style: ThemeInfo.textStyleTeam),
          Text(data.awayTeamName, style: ThemeInfo.textStyleTeam),
        ]),
      ]),
    );
  }
}
