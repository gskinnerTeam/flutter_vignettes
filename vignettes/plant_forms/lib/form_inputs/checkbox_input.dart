import 'package:flutter/material.dart';

import '../styles.dart';

class CheckBoxInput extends StatelessWidget {
  final String label;

  const CheckBoxInput({Key key, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Styles.lightGrayColor),
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            activeColor: Styles.secondaryColor,
            onChanged: (bool value) {},
            value: true,
          ),
          Text(label, style: Styles.inputLabel),
        ],
      ),
    );
  }
}
