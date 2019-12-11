import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'demo_data.dart';
import 'list_model.dart';
import 'main.dart';
import 'particle_field.dart';
import 'particle_field_painter.dart';
import 'removed_swipe_item.dart';
import 'components/sprite_sheet.dart';
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
  //static const double headerHeight = 80;
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
    return Stack(children: <Widget>[
      _buildList(),
      Positioned.fill(
          child: IgnorePointer(
        child: CustomPaint(painter: ParticleFieldPainter(field: _particleField, spriteSheet: _spriteSheet)),
      )),
    ]);
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
    Offset position = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());
    double x = position.dx;
    double y = position.dy;
    double w = box.size.width;

    if (action == SwipeAction.remove) {
      // Delay the start of the effect a little bit, so the item is mostly closed before it begins.
      Future.delayed(Duration(milliseconds: 100)).then((_) => _particleField.lineExplosion(x, y, w));

      // Remove the item (using the ItemModel to sync everything), and redraw the UI (to update count):
      setState(() {
        _model.removeAt(_model.indexOf(data), duration: Duration(milliseconds: 200));
        widget.data.remove(data);
      });
    }
    if (action == SwipeAction.favorite) {
      data.toggleFavorite();
      if (data.isFavorite) {
        _particleField.pointExplosion(x + 60, y + 46, 100);
      }
    }
  }
}
