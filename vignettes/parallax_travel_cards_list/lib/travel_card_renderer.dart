import 'package:flutter/material.dart';
import 'demo_data.dart';
import 'main.dart';
import 'styles.dart';

class TravelCardRenderer extends StatelessWidget {
  final double offset;
  final double cardWidth;
  final double cardHeight;
  final City city;

  const TravelCardRenderer(this.offset, {Key? key, this.cardWidth = 250, required this.city, required this.cardHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(top: 8),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          /// Card background color & decoration
          Container(
            margin: EdgeInsets.only(top: 30, left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: city.color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4 * offset.abs()),
                BoxShadow(color: Colors.black12, blurRadius: 10 + 6 * offset.abs()),
              ],
            ),
          ),

          /// City image, overflows the card a bit on the top
          Positioned(top: -15, child: _buildCityImageStack()),

          /// City information
          _buildCityInfo()
        ],
      ),
    );
  }

  Widget _buildCityImageStack() {
    Widget offsetLayer(String path, double width, double maxOffset, double globalOffset) {
      double cardPadding = 24;
      double layerWidth = cardWidth - cardPadding;
      return Positioned(
          left: ((layerWidth * .5) - (width / 2) - offset * maxOffset) + globalOffset,
          bottom: cardHeight * .45,
          child: Image.asset(path, width: width, package: App.pkg));
    }

    double maxParallax = 30;
    double globalOffset = offset * maxParallax * 2;
    double cardPadding = 28;
    double containerWidth = cardWidth - cardPadding;
    return Container(
      height: cardHeight,
      width: containerWidth,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          offsetLayer(
            "images/${city.name}/${city.name}-Back.png",
            containerWidth * .8,
            maxParallax * .1,
            globalOffset,
          ),
          offsetLayer(
            "images/${city.name}/${city.name}-Middle.png",
            containerWidth * .9,
            maxParallax * .6,
            globalOffset,
          ),
          offsetLayer(
            "images/${city.name}/${city.name}-Front.png",
            containerWidth * .9,
            maxParallax,
            globalOffset,
          ),
        ],
      ),
    );
  }

  Widget _buildCityInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // The sized box mock the space of the city image
        SizedBox(width: double.infinity, height: cardHeight * .57),

        /// Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(city.title, style: Styles.cardTitle, textAlign: TextAlign.center),
        ),

        /// Desc
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(city.description, style: Styles.cardSubtitle, textAlign: TextAlign.center),
        ),
        Expanded(child: SizedBox()),

        /// Bottom btn
        TextButton(
          child: Text('Learn More'.toUpperCase(), style: Styles.cardAction),
          onPressed: null,
        ),
        SizedBox(height: 8)
      ],
    );
  }
}
