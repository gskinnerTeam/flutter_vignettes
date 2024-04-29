import 'package:flutter/material.dart';

import 'package:shared/ui/placeholder/placeholder_card_tall.dart';

class HomeContent extends StatelessWidget {
  @override
  Widget build(context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (content, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: PlaceholderCardTall(height: 200, color: Color(0xFF99D3F7), backgroundColor: Color(0xFFC7EAFF)),
          );
        },
      ),
    );
  }
}
