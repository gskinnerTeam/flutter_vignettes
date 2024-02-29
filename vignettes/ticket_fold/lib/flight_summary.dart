import 'package:flutter/material.dart';

import 'demo_data.dart';
import 'main.dart';

enum SummaryTheme { dark, light }

class FlightSummary extends StatelessWidget {
  final BoardingPassData boardingPass;
  final SummaryTheme theme;
  final bool isOpen;

  const FlightSummary({Key? key, required this.boardingPass, this.theme = SummaryTheme.light, this.isOpen = false})
      : super(key: key);

  Color get mainTextColor => (theme == SummaryTheme.dark) ? Colors.white : Color(0xFF083e64);
  Color get secondaryTextColor => (theme == SummaryTheme.dark) ? Color(0xff61849c) : Color(0xFF838383);
  Color get separatorColor => (theme == SummaryTheme.dark) ? Color(0xffeaeaea) : Color(0xff396583);

  TextStyle get bodyTextStyle => TextStyle(color: mainTextColor, fontSize: 13, fontFamily: 'Oswald', package: App.pkg);

  bool get isLight => theme == SummaryTheme.light;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _getBackgroundDecoration(),
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildLogoHeader(),
            _buildSeparationLine(),
            _buildTicketHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Stack(
                children: <Widget>[
                  Align(alignment: Alignment.centerLeft, child: _buildTicketOrigin()),
                  Align(alignment: Alignment.center, child: _buildTicketDuration()),
                  Align(alignment: Alignment.centerRight, child: _buildTicketDestination())
                ],
              ),
            ),
            _buildBottomIcon()
          ],
        ),
      ),
    );
  }

  _getBackgroundDecoration() {
    return isLight
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.white,
          )
        : BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            image: DecorationImage(image: AssetImage('images/bg_blue.png', package: App.pkg), fit: BoxFit.cover),
          );
  }

  _buildLogoHeader() {
    if (isLight) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Image.asset('images/flutter-logo.png', width: 8, package: App.pkg),
          ),
          Text('Fluttair'.toUpperCase(),
              style: TextStyle(
                  color: mainTextColor,
                  fontFamily: 'OpenSans',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  package: App.pkg))
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Image.asset('images/logo_white.png', height: 12, package: App.pkg),
      );
    }
  }

  Widget _buildSeparationLine() {
    return Container(
      width: double.infinity,
      height: 1,
      color: separatorColor,
    );
  }

  Widget _buildTicketHeader(context) {
    var headerStyle = TextStyle(
        fontFamily: 'OpenSans', fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFFe46565), package: App.pkg);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(boardingPass.passengerName.toUpperCase(), style: headerStyle),
        Text('BOARDING ${boardingPass.boardingTime.format(context)}', style: headerStyle),
      ],
    );
  }

  Widget _buildTicketOrigin() {
    return Column(
      children: <Widget>[
        Text(
          boardingPass.origin.code.toUpperCase(),
          style: bodyTextStyle.copyWith(fontSize: 42),
        ),
        Text(boardingPass.origin.city, style: bodyTextStyle.copyWith(color: secondaryTextColor)),
      ],
    );
  }

  Widget _buildTicketDuration() {
    String routeType = isLight ? 'blue' : 'white';
    final planeImage = Image.asset('images/airplane_$routeType.png', height: 20, fit: BoxFit.contain, package: App.pkg);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 120,
            height: 58,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Image.asset('images/planeroute_$routeType.png', fit: BoxFit.cover, package: App.pkg),
                isLight ? planeImage : _AnimatedSlideToRight(child: planeImage, isOpen: isOpen)
              ],
            ),
          ),
          Text(boardingPass.duration.toString(), textAlign: TextAlign.center, style: bodyTextStyle),
        ],
      ),
    );
  }

  Widget _buildTicketDestination() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          boardingPass.destination.code.toUpperCase(),
          style: bodyTextStyle.copyWith(fontSize: 42),
        ),
        Text(
          boardingPass.destination.city,
          style: bodyTextStyle.copyWith(color: secondaryTextColor),
        ),
      ],
    );
  }

  Widget _buildBottomIcon() {
    IconData icon = isLight ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up;
    return Icon(
      icon,
      color: mainTextColor,
      size: 18,
    );
  }
}

class _AnimatedSlideToRight extends StatefulWidget {
  final Widget child;
  final bool isOpen;

  const _AnimatedSlideToRight({Key? key, required this.child, required this.isOpen}) : super(key: key);

  @override
  _AnimatedSlideToRightState createState() => _AnimatedSlideToRightState();
}

class _AnimatedSlideToRightState extends State<_AnimatedSlideToRight> with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1700));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isOpen) _controller.forward(from: 0);
    return SlideTransition(
      position: Tween(begin: Offset(-2, 0), end: Offset(1, 0)).animate(
        CurvedAnimation(curve: Curves.easeOutQuad, parent: _controller),
      ),
      child: widget.child,
    );
  }
}
