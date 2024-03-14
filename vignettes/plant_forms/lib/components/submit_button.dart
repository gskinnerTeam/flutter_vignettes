import 'package:flutter/material.dart';

import '../styles.dart';

class SubmitButton extends StatelessWidget {
  final double percentage;
  final Widget child;
  final void Function()? onPressed;
  final bool isErrorVisible;
  final EdgeInsets padding;

  const SubmitButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.percentage = 1,
    this.isErrorVisible = false,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Styles.vtFormPadding).add(padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RawMaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            elevation: 0,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizeTransition(
                    sizeFactor: Tween<double>(begin: 0, end: 1)
                        .animate(AlwaysStoppedAnimation(percentage.isNaN ? 0 : percentage)),
                    axisAlignment: -1,
                    axis: Axis.horizontal,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(color: Styles.secondaryColor, borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
                child,
              ],
            ),
            fillColor: Styles.primaryColor,
            onPressed: onPressed,
          ),
          if (isErrorVisible)
            Padding(
                padding: EdgeInsets.only(top: 6.0),
                child: Text('You haven’t finished filling out your information', style: Styles.formError))
        ],
      ),
    );
  }
}
