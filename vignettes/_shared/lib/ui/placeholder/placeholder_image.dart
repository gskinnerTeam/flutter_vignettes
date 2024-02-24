
import 'package:flutter/material.dart';

class PlaceholderImage extends StatelessWidget {
  final double? width;
  final double? height;
  final double cornerRadius;
  final Color? color;
  final Color? backgroundColor;

  const PlaceholderImage({Key? key, this.cornerRadius = 4, this.color, this.backgroundColor, this.width = 100, this.height = 100})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var fgColor = color ?? Color(0xfff2f2f2);
    var bgColor = backgroundColor ?? Colors.white;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        color: bgColor,
      ),
      margin: EdgeInsets.all(12),
      child: CustomPaint(
        painter: _ImagePainter(fgColor, bgColor),
      ),
    );
  }
}

class _ImagePainter extends CustomPainter {
  final Color color;
  final Color backgroundColor;

  _ImagePainter(this.color, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paintForeground = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    //Draw mountains, size to width
    var width = size.width * .6;
    canvas.translate(size.width / 2 - width/2, size.height / 2 + (width * .7)/2);
    var path = Path()
      ..lineTo(width * .4, -width * .66)
      ..lineTo(width * .63, -width * .29)
      ..lineTo(width * .74, -width * .44)
      ..lineTo(width, 0)
      ..lineTo(0, 0);
    //Paint twice, for both stroke and fill
    canvas.drawPath(path, paintForeground);
    paintForeground.style = PaintingStyle.fill;
    canvas.drawPath(path, paintForeground);
    //Draw sun
    canvas.drawCircle(Offset(width * .9, -width * .7), width * .1, paintForeground);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
