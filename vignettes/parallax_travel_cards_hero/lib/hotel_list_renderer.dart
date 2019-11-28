import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'demo_data.dart';
import 'styles.dart';

class HotelListRenderer extends StatelessWidget {
  final List<HotelData> hotels;

  HotelListRenderer(this.hotels);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(right: Styles.hzScreenPadding * 1.5, left: Styles.hzScreenPadding * 1.5, bottom: 20),
      child: Container(
        width: double.infinity,
        height: size.height * .25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hotels'.toUpperCase(),
              style: Styles.hotelsTitleSection,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: hotels.map((hotel) => _buildHotelData(hotel)).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHotelData(HotelData hotel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(hotel.name, style: Styles.hotelTitle),
            ),
            Row(
              children: <Widget>[
                _buildFiveStars(hotel),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(hotel.rate.toString(), style: Styles.hotelScore),
                ),
                Text('(${hotel.reviews})', style: Styles.hotelData),
              ],
            )
          ],
        ),
        Text(
          '\$${hotel.price.toInt()}',
          style: Styles.hotelPrice,
        )
      ],
    );
  }

  Widget _buildFiveStars(HotelData hotel) {
    List<Widget> stars = [];
    for (int i = 0; i < hotel.rate.toInt(); i++) {
      stars.add(Icon(Icons.star, color: Color(0xFFfeda7d), size: 13));
    }
    return Row(
      children: stars,
    );
  }
}
