import 'main.dart';

import 'demo_data.dart';
import 'constellation_title_card.dart';
import 'styles.dart';
import 'package:flutter/material.dart';

class ConstellationDetailView extends StatefulWidget {
  static const route = "ConstellationDetailView";

  final ConstellationData data;
  final bool redMode;
  final int contentDelay;
  final Function onBackTap;

  const ConstellationDetailView({Key key, this.data, this.redMode, this.contentDelay = 1000, @required this.onBackTap}) : super(key: key);

  @override
  _ConstellationDetailViewState createState() => _ConstellationDetailViewState();
}

class _ConstellationDetailViewState extends State<ConstellationDetailView> with SingleTickerProviderStateMixin {
  AnimationController _animController;
  Animation<double> _contentScaleTween;
  Animation<double> _textAlphaTween;

  @override
  void initState() {
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.contentDelay))
      ..addListener(() {
        setState(() {});
      });
    _contentScaleTween = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Interval(.4, .8, curve: Curves.easeOutQuad)),
    );
    _textAlphaTween = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Interval(.6, 1, curve: Curves.easeOutQuad)),
    );
    _animController.forward(from: 0);
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 24),
        child: Column(
          children: <Widget>[
            ConstellationTitleCard(
              data: widget.data,
              redMode: widget.redMode,
            ),
            Expanded(
              child: Transform.scale(
                scale: _contentScaleTween.value,
                child: Stack(
                  children: <Widget>[
                    Image.asset("images/${widget.data.image}-Constellation@2x.png", filterQuality: FilterQuality.high, package: App.pkg, ),
                    Opacity(
                      opacity: _textAlphaTween.value,
                      child: Image.asset("images/${widget.data.image}-Text@2x.png", fit: BoxFit.contain, package: App.pkg),
                    ),
                  ],
                ),
              ),
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
              splashColor: Colors.white24,
              color: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40), side: BorderSide(color: Color(0xffc9c9c9))),
              //Dispatch our tap event to the parent of this widget, and let them handle it.
              onPressed: () => widget.onBackTap(),
              child: Text("Return to List", style: TextStyle(fontFamily: Fonts.Content, color: Colors.white, package: App.pkg)),
            ),
            SizedBox(
              height: 36,
            )
          ],
        ));
  }
}
