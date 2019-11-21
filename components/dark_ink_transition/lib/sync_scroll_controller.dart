
import 'package:flutter/widgets.dart';

class SyncScrollController extends TrackingScrollController {

  SyncScrollController({ double initialScrollOffset: 0.0, bool keepScrollOffset: true, String debugLabel })
    : super(
        initialScrollOffset: initialScrollOffset,
        keepScrollOffset: keepScrollOffset,
        debugLabel: debugLabel) {
    this.addListener(_handleScroll);
  }

  void _handleScroll() {
    // Find scrolling position
    ScrollPosition scrollPosition;
    for (var sp in positions) {
      if (sp.isScrollingNotifier.value) {
        scrollPosition = sp;
        break;
      }
    }
    for (var sp in positions) {
      if (!identical(sp, scrollPosition))
        sp.jumpTo(scrollPosition.pixels);
    }
  }

}

