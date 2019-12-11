import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'main.dart';
import 'swipe_item.dart';

// Content for the list items.
class EmailCard extends StatelessWidget {
  final Email email;
  final Color backgroundColor;

  EmailCard({this.email, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Container(
        width: w + 0.1,
        height: SwipeItem.nominalHeight,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: Colors.black.withOpacity(0.5),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                if (email.isRead)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.lens, size: 12.0, color: Color(0xffaa07de)),
                  ),
                Expanded(
                  child:
                      Text(email.from, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: .3, package: App.pkg)),
                ),
                Text('11:45 PM', style: TextStyle(fontSize: 11, letterSpacing: .3, package: App.pkg)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(email.subject, style: TextStyle(fontSize: 11, letterSpacing: .3, package: App.pkg)),
                if (email.isFavorite) Icon(Icons.star, size: 18.0, color: Color(0xff55c8d4)),
              ],
            ),
            SizedBox(height: 2.0),
            Text(
              email.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, letterSpacing: .3, color: Color(0xff9293bf), package: App.pkg),
            ),
            SizedBox(
              width: 16.0,
            ),
          ],
        ));
  }
}
