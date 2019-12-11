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
      appBar: _buildAppBar(),
      backgroundColor: Colors.white,
      //Create a column of items, with the cityCard expanding to fill the empty space
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(),
            Expanded(child: _buildCityCard(context)),
            HotelListRenderer(city.hotels),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      leading: Icon(Icons.menu, color: Colors.black),
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Styles.hzScreenPadding),
          child: Icon(Icons.search, color: Colors.black),
        )
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(right: Styles.hzScreenPadding * 3, left: Styles.hzScreenPadding * 3),
      child: Text('Get ready for your trip', textAlign: TextAlign.center, style: Styles.appHeader),
    );
  }

  Widget _buildCityCard(context) {
    return Center(
      child: GestureDetector(
        onTap: () => _handlePressedBtn(context),
        child: Container(
          constraints: BoxConstraints(minHeight: 290, minWidth: 250, maxHeight: MediaQuery.of(context).size.height * .43, maxWidth: 300),
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
