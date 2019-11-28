import 'package:flutter/material.dart';

class ContentBox extends StatelessWidget {
  final double width;
  final double height;

  const ContentBox({Key key, this.width = 240, this.height = 80}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
