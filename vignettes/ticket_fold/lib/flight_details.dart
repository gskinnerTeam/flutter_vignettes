import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'demo_data.dart';
import 'main.dart';

class FlightDetails extends StatelessWidget {
  final BoardingPassData boardingPass;
  final TextStyle titleTextStyle = TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 11,
      height: 1,
      letterSpacing: .2,
      fontWeight: FontWeight.w600,
      color: Color(0xffafafaf),
      package: App.pkg);
  final TextStyle contentTextStyle =
      TextStyle(fontFamily: 'Oswald', fontSize: 16, height: 1.8, letterSpacing: .3, color: Color(0xff083e64), package: App.pkg);

  FlightDetails(this.boardingPass);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text('Gate'.toUpperCase(), style: titleTextStyle),
                  Text(boardingPass.gate, style: contentTextStyle),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text('Zone'.toUpperCase(), style: titleTextStyle),
                  Text(boardingPass.zone.toString(), style: contentTextStyle),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text('Seat'.toUpperCase(), style: titleTextStyle),
                  Text(boardingPass.seat, style: contentTextStyle),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text('Class'.toUpperCase(), style: titleTextStyle),
                  Text(boardingPass.flightClass, style: contentTextStyle),
                ]),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text('Flight'.toUpperCase(), style: titleTextStyle),
                  Text(boardingPass.flightNumber, style: contentTextStyle),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text('Departs'.toUpperCase(), style: titleTextStyle),
                  Text(DateFormat('MMM d, H:mm').format(boardingPass.departs).toUpperCase(), style: contentTextStyle),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text('Arrives'.toUpperCase(), style: titleTextStyle),
                  Text(DateFormat('MMM d, H:mm').format(boardingPass.arrives).toUpperCase(), style: contentTextStyle)
                ]),
              ],
            ),
          ],
        ),
      );
}
