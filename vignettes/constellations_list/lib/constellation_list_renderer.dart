import 'package:flutter/material.dart';

import 'constellation_title_card.dart';
import 'demo_data.dart';

class ConstellationListRenderer extends StatefulWidget {
  final ConstellationData data;
  final bool redMode;
  final Function(ConstellationData, bool)? onTap;
  final double hzPadding;

  const ConstellationListRenderer({Key? key, required this.data, this.redMode = false, this.onTap, this.hzPadding = 0})
      : super(key: key);

  @override
  _ConstellationListRendererState createState() => _ConstellationListRendererState();
}

class _ConstellationListRendererState extends State<ConstellationListRenderer> {
  @override
  Widget build(BuildContext context) {
    double leftPadding = widget.redMode ? 0 : widget.hzPadding;
    double rightPadding = widget.redMode ? widget.hzPadding : 0;
    double vtPadding = 24;
    return GestureDetector(
      onTap: () => _handleTap(),
      child: Transform.translate(
        offset: Offset(widget.redMode ? 25 : -25, 0),
        child: Container(
          padding: EdgeInsets.only(top: vtPadding, bottom: vtPadding, left: leftPadding, right: rightPadding),
          alignment: widget.redMode ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstellationTitleCard(
            data: widget.data,
            redMode: widget.redMode,
          ),
        ),
      ),
    );
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap?.call(widget.data, widget.redMode);
    }
  }
}
