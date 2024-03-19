import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'styles.dart';

class HotelListRenderer extends StatelessWidget {
  final List<HotelData> hotels;

  HotelListRenderer(this.hotels);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: Styles.hzScreenPadding * 1.5, left: Styles.hzScreenPadding * 1.5, bottom: 20),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hotels'.toUpperCase(),
              style: Styles.hotelsTitleSection,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: hotels.map((hotel) => _buildHotelData(hotel)).toList(),
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
            /// Title
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(hotel.name, style: Styles.hotelTitle),
            ),
            Row(
              children: <Widget>[
                /// Stars
                ...List.generate(
                  hotel.rating.round(),
                  (index) => Icon(Icons.star, color: Color(0xFFfeda7d), size: 13),
                ),

                /// Rating
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(hotel.rating.toString(), style: Styles.hotelScore),
                ),

                /// Review count
                Text('(${hotel.reviews})', style: Styles.hotelData),
              ],
            )
          ],
        ),

        /// Price
        Text(
          '\$${hotel.price.toInt()}',
          style: Styles.hotelPrice,
        )
      ],
    );
  }
}
