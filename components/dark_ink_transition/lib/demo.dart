import 'package:flutter/material.dart';

import 'dark_ink_bar.dart';
import 'dark_ink_content.dart';
import 'dark_ink_controls.dart';
import 'sync_scroll_controller.dart';
import 'transition_container.dart';


class DarkInkDemo extends StatefulWidget {

  @override
  State createState() {
    return _DarkInkDemoState();
  }
}

class _DarkInkDemoState extends State<DarkInkDemo> {

  ValueNotifier<bool> _darkModeValue;
  ScrollController _scrollController;

  @override
  void initState() {
    _darkModeValue = ValueNotifier<bool>(false);
    _darkModeValue.addListener(() {
      setState(() {
      });
    });
    _scrollController = SyncScrollController();
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
    // Build a simple scaffold that shows the top bar and controls over the content
    return GestureDetector(
      onTap: (){
        _darkModeValue.value = !_darkModeValue.value;
      },
      child: Stack(
        children: [
          TransitionContainer(
            darkModeValue: _darkModeValue,
            child: DarkInkContent(
                darkMode: _darkModeValue.value,
                scrollController: _scrollController
            ),
          ),
          DarkInkBar(darkModeValue: _darkModeValue),
          DarkInkControls(darkModeValue: _darkModeValue),
        ],
      ),
    );
  }
}
