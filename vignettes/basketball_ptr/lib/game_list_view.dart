import 'package:flutter/material.dart';

import './theme_info.dart';
import './demo_data.dart';
import './game_list_item.dart';

class GameListView extends StatelessWidget {
  final ScrollController controller;
  final ScrollPhysics physics;
  final BasketballGameModel model;
  final EdgeInsetsGeometry padding;

  GameListView({@required this.controller, this.physics, @required this.model, this.padding = EdgeInsets.zero});

  @override
  Widget build(context) {
    // Build a simple container that shows the content, use the custom scroll controller and physics to enable
    // the pull to refresh behavior
    return Expanded(
      child: Container(
        color: ThemeInfo.background0,
        child: ListView(
          physics: physics,
          controller: controller,
          padding: padding,
          scrollDirection: Axis.vertical,
          // Fetch the data for the children from the fake model
          children: [
            GameListItem(data: model.getGameData(0)),
            Padding(padding: EdgeInsets.only(top: 1)),
            GameListItem(data: model.getGameData(1)),
            Padding(padding: EdgeInsets.only(top: 1)),
            GameListItem(data: model.getGameData(2)),
            Padding(padding: EdgeInsets.only(top: 1)),
            GameListItem(data: model.getGameData(3)),
            Padding(padding: EdgeInsets.only(top: 1)),
            GameListItem(data: model.getGameData(4)),
            Padding(padding: EdgeInsets.only(top: 1)),
            GameListItem(data: model.getGameData(5)),
            Padding(padding: EdgeInsets.only(top: 1)),
            GameListItem(data: model.getGameData(6)),
            Padding(padding: EdgeInsets.only(top: 1)),
            GameListItem(data: model.getGameData(7)),
            Padding(padding: EdgeInsets.only(top: 1)),
            GameListItem(data: model.getGameData(8)),
            Padding(padding: EdgeInsets.only(top: 1)),
            GameListItem(data: model.getGameData(9)),
          ],
        ),
      ),
    );
  }
}
