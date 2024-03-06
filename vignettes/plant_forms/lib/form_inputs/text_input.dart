import 'package:flutter/material.dart';

import '../demo_data.dart';
import '../styles.dart';

class TextInput extends StatefulWidget {
  final String label;
  final String helper;
  final String initialValue;
  final bool isRequired;
  final InputType type;
  final void Function(String key, String value, bool isValid) onValidate;
  final void Function(String key, String value)? onChange;
  final bool isActive;
  final ValueNotifier? valueNotifier;

  const TextInput({
    Key? key,
    this.helper = '',
    this.isRequired = true,
    this.initialValue = '',
    this.type = InputType.text,
    required this.onValidate,
    this.label = '',
    this.isActive = true,
    this.onChange,
    this.valueNotifier,
  }) : super(key: key);

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _isAutoValidating = false;
  bool? _isValid;

  String _value = '';
  String _errorText = '';

  String get _keyValue => (widget.key as ValueKey).value as String;

  @override
  void initState() {
    super.initState();
    // Reset the valid state on notifier change
    if (widget.valueNotifier != null) {
      widget.valueNotifier?.addListener(() => _isValid = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  set isValid(bool isValid) {
    if (isValid != _isValid) {
      _isValid = isValid;
      widget.onValidate(_keyValue, _value, _isValid as bool);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Validate based on initial value, only do this once. We do it here instead of initState as it may trigger rebuilds up the tree
    if (_isValid == null) {
      if (widget.initialValue.isNotEmpty) {
        _validateField(widget.initialValue);
      }
    }

    //build input
    return Container(
      padding: EdgeInsets.only(top: widget.label.isNotEmpty ? 18 : 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          if (widget.label.isNotEmpty) Positioned(top: -24, child: Text(widget.label, style: Styles.inputLabel)),
          TextFormField(
            initialValue: widget.initialValue,
            style: Styles.orderTotalLabel,
            enabled: widget.isActive,
            onChanged: _handleChange,
            keyboardType: _getKeyboardType(),
            autovalidateMode: _isAutoValidating ? AutovalidateMode.always : AutovalidateMode.disabled,
            validator: _validateField,
            decoration: Styles.getInputDecoration(helper: widget.helper),
          ),
          Positioned(
            top: 6,
            left: 12,
            child: Text(_getLabel().toUpperCase(), style: Styles.labelOptional),
          ),
          if (_errorText.isNotEmpty)
            Positioned(
              top: 8,
              right: 14,
              child: Text(_errorText.toUpperCase(), style: Styles.labelNotValid),
            ),
        ],
      ),
    );
  }

  String _getLabel() {
    String label = '';
    if (!widget.isRequired && _value.isEmpty) label = 'Optional';
    if (_value.isNotEmpty && widget.label.isEmpty || widget.initialValue.isNotEmpty) return widget.helper;
    return label;
  }

  void _handleChange(String value) {
    // save value status
    _value = value;
    widget.onChange?.call(_keyValue, value);

    // TODO: Can we just always have autoValidate=true and remove this code?
    // activate validation
    Future.delayed(Duration(milliseconds: 100), () => setState(() {}));
    if (!_isAutoValidating)
      setState(() {
        _isAutoValidating = true;
      });
  }

  TextInputType? _getKeyboardType() => switch (widget.type) {
        InputType.email => TextInputType.emailAddress,
        InputType.telephone => TextInputType.numberWithOptions(decimal: true),
        InputType.number => TextInputType.numberWithOptions(signed: true, decimal: true),
        InputType.text => TextInputType.text
      };

  String? _validateField(String? value) {
    if (value == null) return null;
    _value = value;
    // if the value is required
    if (widget.isRequired && value.isEmpty) {
      isValid = false;
      _errorText = 'Required';
      return _errorText;
    }
    // if it is optional
    else if (!widget.isRequired && value.isEmpty) {
      isValid = true;
      _errorText = '';
      return null;
    }
    // validate when the input has a value
    else if (value.isNotEmpty) {
      if (switch (widget.type) {
        InputType.email => _validateEmail(value),
        InputType.telephone => _validatePhoneNumber(value),
        _ => true
      }) {
        _errorText = '';
        return null;
      }
    }
    // in other case, the item is not valid

    isValid = false;
    _errorText = 'Not Valid';
    return _errorText;
  }

  bool _validateEmail(String value) {
    RegExp emailRegExp = RegExp(r"(^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$)");
    return emailRegExp.hasMatch(value);
  }

  bool _validatePhoneNumber(String value) {
    RegExp telRegExp = RegExp(r"(^(1\s?)?(\(\d{3}\)|\d{3})[\s\-]?\d{3}[\s\-]?\d{4}$)");
    return telRegExp.hasMatch(value);
  }
}
