import 'package:flutter/material.dart';

import '../main.dart';

class ParticleAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xffaa07de), Color(0xffde4ed6)])),
      child: SafeArea(
        child: Stack(children: <Widget>[
          SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 26),
                child: Row(children: <Widget>[
                  Icon(Icons.menu, size: 28),
                  SizedBox(width: 18),
                  Text('Inbox', style: TextStyle(fontFamily: 'OpenSans', fontSize: 21, letterSpacing: .3, package: App.pkg))
                ]),
              )),
        ]),
      ),
    );
  }
}
