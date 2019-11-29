import 'package:shared/ui/placeholder/placeholder_card_short.dart';
import 'package:flutter/material.dart';

class LikesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 9,
        itemBuilder: (content, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: PlaceholderCardShort(),
          );
        },
      ),
    );
  }
}
