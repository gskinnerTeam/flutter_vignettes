import 'package:flutter/material.dart';

import './theme_info.dart';
import './demo_data.dart';

import './main.dart';

class GameScore extends StatefulWidget {
  final BasketballGameData data;

  GameScore({@required this.data});

  @override
  State createState() {
    return _GameScoreState(data);
  }
}

class _GameScoreState extends State<GameScore> with SingleTickerProviderStateMixin {
  BasketballGameData _data;
  BasketballGameData _newData;

  AnimationController _controller;
  Animation<double> _scoreAnimation;

  _GameScoreState(this._data);

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

    _scoreAnimation = Tween<double>(
      begin: 0.0,
      end: -1.0,
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _data = _newData;
          _newData = null;
        });
        _controller.reset();
      }
    });

    _controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GameScore oldWidget) {
    if (oldWidget.data != widget.data) {
      _newData = widget.data;
      _controller.forward(from: 0.0);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: 50,
          height: 36,
          child: Stack(
            children: _buildTeamScores(true),
          ),
        ),
        Padding(padding: EdgeInsets.all(8)),
        Text('-', style: TextStyle(fontSize: 28, color: ThemeInfo.accent1, fontFamily: 'FjallaOne', package: App.pkg)),
        Padding(padding: EdgeInsets.all(8)),
        Container(
          width: 50,
          height: 36,
          child: Stack(
            children: _buildTeamScores(false),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTeamScores(bool homeTeam) {
    final currentColor = (homeTeam ? _data.homeTeamScore > _data.awayTeamScore : _data.awayTeamScore > _data.homeTeamScore) &&
            _data.quarter == BasketballGameQuarter.FINISHED
        ? ThemeInfo.accent0
        : ThemeInfo.accent1;

    List<Widget> results = <Widget>[];
    results.add(Positioned(
        top: _scoreAnimation.value * 36.0,
        width: 50,
        child: Text(homeTeam ? _data.homeTeamScore.toString() : _data.awayTeamScore.toString(),
            textAlign: homeTeam ? TextAlign.right : TextAlign.left,
            style: TextStyle(fontSize: 28, color: currentColor, fontFamily: 'FjallaOne', package: App.pkg))));

    if (_newData != null) {
      final newColor = (homeTeam ? _newData.homeTeamScore > _newData.awayTeamScore : _newData.awayTeamScore > _newData.homeTeamScore) &&
              _newData.quarter == BasketballGameQuarter.FINISHED
          ? ThemeInfo.accent0
          : ThemeInfo.accent1;

      results.add(Positioned(
          top: _scoreAnimation.value * 36.0 + 36.0,
          width: 50,
          child: Text(homeTeam ? _newData.homeTeamScore.toString() : _newData.awayTeamScore.toString(),
              textAlign: homeTeam ? TextAlign.right : TextAlign.left,
              style: TextStyle(fontSize: 28, color: newColor, fontFamily: 'FjallaOne', package: App.pkg))));
    }

    return results;
  }
}
