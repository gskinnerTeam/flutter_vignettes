import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'demo_data.dart';
import 'list_model.dart';
import 'main.dart';
import 'particle_field.dart';
import 'particle_field_painter.dart';
import 'removed_swipe_item.dart';
import 'sprite_sheet.dart';
import 'swipe_item.dart';

class ParticleSwipeDemo extends StatefulWidget {
  final List data;

  ParticleSwipeDemo() : data = DemoData().getData();

  @override
  State<StatefulWidget> createState() {
    return ParticleSwipeDemoState();
  }
}

class ParticleSwipeDemoState extends State<ParticleSwipeDemo> with SingleTickerProviderStateMixin {
  static const double headerHeight = 80;
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel _model;
  SpriteSheet _spriteSheet;
  ParticleField _particleField;
  Ticker _ticker;

  @override
  void initState() {
    // Create the "sparkle" sprite sheet for the particles:
    _spriteSheet = SpriteSheet(
      imageProvider: AssetImage("images/circle_spritesheet.png", package: App.pkg),
      length: 15, // number of frames in the sprite sheet.
      frameWidth: 10,
      frameHeight: 10,
    );

    // This synchronizes the data with the animated list:
    _model = ListModel(
      initialItems: widget.data,
      listKey: _listKey, // ListModel uses this to look up the list its acting on.
      removedItemBuilder: (dynamic removedItem, BuildContext context, Animation<double> animation) =>
          RemovedSwipeItem(animation: animation),
    );

    _particleField = ParticleField();
    _ticker = createTicker(_particleField.tick)..start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // Draw the header and List UI with a ParticleFieldPainter layered over top:
    return Scaffold(
      body: Stack(children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: screenSize.height - headerHeight,
            child: _buildList(),
          ),
        ),
        _buildHeader(),
        Positioned.fill(
            bottom: MediaQuery.of(context).size.height * .16,
            child: IgnorePointer(
              child: CustomPaint(painter: ParticleFieldPainter(field: _particleField, spriteSheet: _spriteSheet)),
            )),
      ]),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: headerHeight,
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xffaa07de), Color(0xffde4ed6)])),
      child: Stack(fit: StackFit.expand, children: <Widget>[
        SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(children: <Widget>[
            Icon(Icons.menu, size: 28),
            SizedBox(width: 18),
            Text('Inbox', style: TextStyle(fontFamily: 'OpenSans', fontSize: 21, letterSpacing: .3, package: App.pkg))
          ]),
        )),
      ]),
    );
  }

  Widget _buildList() {
    return AnimatedList(
      key: _listKey, // used by the ListModel to find this AnimatedList
      initialItemCount: _model.length,
      physics: ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index, _) {
        var item = _model[index];
        return SwipeItem(data: item, isEven: index.isEven, onSwipe: (key, {action}) => _performSwipeAction(item, key, action));
      },
    );
  }

  void _performSwipeAction(Email data, GlobalKey key, SwipeAction action) {
    // Get item's render box, and use it to calculate the position for the particle effect:
    final RenderBox box = key.currentContext.findRenderObject();
    Offset position = box.localToGlobal(Offset.zero);
    double x = position.dx;
    double y = position.dy;
    double w = box.size.width;

    if (action == SwipeAction.remove) {
      // Delay the start of the effect a little bit, so the item is mostly closed before it begins.
      Future.delayed(Duration(milliseconds: 100)).then((_) => _particleField.lineExplosion(x, y + 1.0, w));

      // Remove the item (using the ItemModel to sync everything), and redraw the UI (to update count):
      setState(() {
        _model.removeAt(_model.indexOf(data), duration: Duration(milliseconds: 200));
        widget.data.remove(data);
      });
    }
    if (action == SwipeAction.favorite) {
      data.toggleFavorite();
      if (data.isFavorite) {
        _particleField.pointExplosion(x + 63, y + 49, 100);
      }
    }
  }
}
