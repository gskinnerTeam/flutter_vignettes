import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'styles.dart';

class HotelList extends StatefulWidget {
  final List<Hotel> hotels;

  HotelList(this.hotels);

  @override
  _HotelListViewState createState() => _HotelListViewState();
}

class _HotelListViewState extends State<HotelList> with SingleTickerProviderStateMixin {
  late AnimationController _anim = AnimationController(vsync: this, duration: Duration(milliseconds: 700));

  @override
  void initState() {
    _anim.forward(from: 0);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HotelList oldWidget) {
    if (oldWidget.hotels != widget.hotels) {
      _anim.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Styles.hzScreenPadding * 1.5, vertical: 10),
      child: Container(
        width: 400,
        height: size.height * .25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Hotels'.toUpperCase(), style: Styles.hotelsTitleSection),
            Expanded(
              child: FadeTransition(
                opacity: _anim,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[for (Hotel hotel in widget.hotels) _buildHotelData(hotel)],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHotelData(Hotel hotel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// Hotel name
            Text(hotel.name, style: Styles.hotelTitle),
            SizedBox(height: 3),
            Row(
              children: <Widget>[
                /// Stars
                Row(
                  children: List.generate(hotel.rating.toInt(), (index) {
                    return Icon(Icons.star, color: Color(0xFFfeda7d), size: 13);
                  }),
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
        Text('\$${hotel.price}', style: Styles.hotelPrice)
      ],
    );
  }
}
