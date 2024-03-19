import 'package:flutter/material.dart';

import 'dark_ink_bar.dart';
import 'dark_ink_content.dart';
import 'dark_ink_controls.dart';
import 'sync_scroll_controller.dart';
import 'transition_container.dart';

class DarkInkDemo extends StatefulWidget {
  @override
  State createState() => _DarkInkDemoState();
}

class _DarkInkDemoState extends State<DarkInkDemo> {
  ValueNotifier<bool> _darkModeValue = ValueNotifier<bool>(false);
  ScrollController _scrollController = SyncScrollController();

  @override
  void initState() {
    _darkModeValue.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _darkModeValue.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    //Wrap the entire demo is a gestureDetector, just to more easily show off the darkMode transition.
    return GestureDetector(
      onTap: () {
        _darkModeValue.value = !_darkModeValue.value;
      },
      // Build a simple scaffold that shows the top bar and controls over the content
      child: Stack(
        children: [
          TransitionContainer(
            child: DarkInkContent(darkMode: _darkModeValue.value, scrollController: _scrollController),
          ),
          DarkInkBar(darkModeValue: _darkModeValue),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(padding: EdgeInsets.only(bottom: 16), child: DarkInkControls(darkModeValue: _darkModeValue)),
          ),
        ],
      ),
    );
  }
}
