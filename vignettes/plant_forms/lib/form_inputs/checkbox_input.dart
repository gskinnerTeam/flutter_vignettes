import 'package:flutter/material.dart';

import '../styles.dart';

class CheckBoxInput extends StatefulWidget {
  final String label;
  final Function onChange;

  const CheckBoxInput({Key key, this.label, this.onChange}) : super(key: key);

  @override
  _CheckBoxInputState createState() => _CheckBoxInputState();
}

class _CheckBoxInputState extends State<CheckBoxInput> {
  bool _value = true;

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
            onChanged: _handleChange,
            value: _value,
          ),
          Text(widget.label, style: Styles.inputLabel),
        ],
      ),
    );
  }

  void _handleChange(bool value){
    setState(() {
      _value = value;
    });
  }
}
