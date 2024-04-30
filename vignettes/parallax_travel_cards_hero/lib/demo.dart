import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'city_scenery.dart';
import 'city_details_page.dart';
import 'demo_data.dart';
import 'hotel_list_renderer.dart';
import 'styles.dart';
import 'components/white_page_route.dart';

class HeroCardDemo extends StatelessWidget {
  final CityData city = DemoData().getCity();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //Create a column of items, with the cityCard expanding to fill the empty space
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: _buildCityCard(context),
                ),
                HotelListRenderer(city.hotels),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(right: Styles.hzScreenPadding * 3, left: Styles.hzScreenPadding * 3, top: 16),
      child: Text('Get ready for your trip!', textAlign: TextAlign.center, style: Styles.appHeader),
    );
  }

  Widget _buildCityCard(context) {
    return Center(
      child: GestureDetector(
        onTap: () => _handlePressedBtn(context),
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * .44, maxWidth: 300),
          child: Hero(tag: '${city.name}-hero', child: CityScenery(city: city)),
        ),
      ),
    );
  }

  void _handlePressedBtn(context) {
    var detailPage = CityDetailsPage(city);
    Navigator.push(context, WhitePageRoute(enterPage: detailPage));
  }
}
