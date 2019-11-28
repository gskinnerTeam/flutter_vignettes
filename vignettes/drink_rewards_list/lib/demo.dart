import 'dart:ui';
import 'package:flutter/material.dart';

import 'main.dart';
import 'syles.dart';
import 'demo_data.dart';
import 'rounded_shadow.dart';
import 'drink_card.dart';

class DrinkRewardsListDemo extends StatefulWidget {
  @override
  _DrinkRewardsListDemoState createState() => _DrinkRewardsListDemoState();
}

class _DrinkRewardsListDemoState extends State<DrinkRewardsListDemo> {
  double _listPadding = 20;
  DrinkData _selectedDrink;
  ScrollController _scrollController = ScrollController();
  List<DrinkData>_drinks;
  int _earnedPoints;

  @override
  void initState() {
    var demoData = DemoData();
    _drinks = demoData.drinks;
    _earnedPoints = demoData.earnedPoints;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      body: Theme(
        data: ThemeData(fontFamily: "Poppins", primarySwatch: Colors.orange),
        child: Stack(
          children: <Widget>[
            ListView.builder(
              padding: EdgeInsets.only(bottom: 40, top: 250),
              itemCount: _drinks.length,
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              itemBuilder: (context, index) => _buildListItem(index),
            ),

            _buildTopBg(),

            _buildTopContent(),

          ],
        ),
      ),
    );
  }

  Widget _buildListItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: _listPadding / 2, horizontal: _listPadding),
      child: DrinkListCard(
        earnedPoints: _earnedPoints,
        drinkData: _drinks[index],
        isOpen: _drinks[index] == _selectedDrink,
        onTap: _handleDrinkTapped,
      ),
    );
  }

  Widget _buildTopBg() {
    return Container(
      alignment: Alignment.topCenter,
      height: 250,
      child: RoundedShadow(
          topLeftRadius: 0,
          topRightRadius: 0,
          shadowColor: Color(0x0).withAlpha(65),
          child: Container(
            width: double.infinity,
            child: Image.asset("images/Header.png", fit: BoxFit.fill, package: App.pkg,),
          )),
    );
  }

  Column _buildTopContent() {
    return Column(
      children: <Widget>[
        SizedBox(height: 35),
        Text("My Rewards", style: Styles.text(22, Colors.white, true)),
        SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.star, color: AppColors.redAccent, size: 32),
            SizedBox(width: 8),
            Text("$_earnedPoints", style: Styles.text(50, Colors.white, true)),
          ],
        ),
        Text("Your Points Balance", style: Styles.text(14, Colors.white, false))
      ],
    );
  }

  void _handleDrinkTapped(DrinkData data) {
    setState(() {
      //If the same drink was tapped twice, un-select it
      if (_selectedDrink == data) {
        _selectedDrink = null;
      }
      //Open tapped drink card and scroll to it
      else {
        _selectedDrink = data;
        var selectedIndex = _drinks.indexOf(_selectedDrink);
        var closedHeight = DrinkListCard.nominalHeightClosed;
        //Calculate scrollTo offset, subtract a bit so we don't end up perfectly at the top
        var offset = selectedIndex * (closedHeight + _listPadding) - closedHeight * .35;
        _scrollController.animateTo(offset, duration: Duration(milliseconds: 700), curve: Curves.easeOutQuad);
      }
    });
  }
}
