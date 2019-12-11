import 'package:flutter/material.dart';

import 'city_scenery.dart';
import 'demo_data.dart';
import 'main.dart';
import 'styles.dart';

class CityDetailsPage extends StatelessWidget {
  final CityData city;

  CityDetailsPage(this.city);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildHeroWidget(context),
              _buildCityDetails(),
            ],
          ),
          _buildBackButton(context),
        ],
      ),
    );
  }

  Widget _buildHeroWidget(context) {
    return Hero(
      tag: '${city.name}-hero',
      flightShuttleBuilder: _buildFlightWidget,
      child: Container(
        height: MediaQuery.of(context).size.height * .55,
        width: double.infinity,
        child: CityScenery(
          animationValue: 1,
          city: city,
        ),
      ),
    );
  }

  Widget _buildFlightWidget(BuildContext flightContext, Animation<double> heroAnimation,
      HeroFlightDirection flightDirection, BuildContext fromHeroContext, BuildContext toHeroContext) {
    return AnimatedBuilder(
      animation: heroAnimation,
      builder: (context, child) {
        return DefaultTextStyle(
          style: DefaultTextStyle.of(toHeroContext).style,
          child: CityScenery(
            city: city,
            animationValue: heroAnimation.value,
          ),
        );
      },
    );
  }

  Widget _buildCityDetails() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: <Widget>[
              Text(city.title, style: Styles.appHeader),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: Styles.hzScreenPadding * 1.5,
                  right: Styles.hzScreenPadding * 1.5,
                ),
                child: Text(city.information, style: Styles.cardSubtitle, textAlign: TextAlign.center),
              ),
            ],
          ),
          // Cards section
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text('Experiences for every interest'.toUpperCase(), style: Styles.detailsTitleSection),
              ),
              _ExperiencesSection()
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SafeArea(
      child: IconButton(
          padding: EdgeInsets.only(left: Styles.hzScreenPadding),
          icon: Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}

class _ExperiencesSection extends StatelessWidget {
  final List<String> experiences = ['Arts', 'Food And Drink', 'Classes'];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
        height: screenSize.height * .15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[for (var experience in experiences) _buildExperienceCard(screenSize, experience)],
        ));
  }

  Widget _buildExperienceCard(Size screenSize, experience) {
    return Card(
      elevation: 1,
      child: Container(
        color: Colors.white,
        height: screenSize.height * .22,
        width: screenSize.width * .3,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image.asset(
                'images/Small-Cards/${experience.replaceAll(' ', '')}.png',
                fit: BoxFit.cover,
                width: double.infinity,
                package: App.pkg,
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  experience,
                  style: Styles.detailsCardTitle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
