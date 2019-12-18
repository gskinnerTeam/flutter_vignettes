import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../demo_data.dart';
import 'input_validator.dart';
import '../styles.dart';

class CreditCardInfoInput extends StatefulWidget {
  final String label;
  final String helper;
  final CreditCardInputType inputType;
  final CreditCardNetwork cardNetwork;
  final Function onValidate;
  final Function onChange;

  const CreditCardInfoInput(
      {Key key,
      this.label = '',
      this.helper = '',
      this.cardNetwork,
      @required this.inputType,
      @required this.onValidate,
      this.onChange})
      : super(key: key);

  @override
  _CreditCardInfoInputState createState() => _CreditCardInfoInputState();
}

class _CreditCardInfoInputState extends State<CreditCardInfoInput> {
  MaskedTextController _textController;
  CreditCardNetwork _creditCardType;
  bool _isAutoValidating = false;
  bool _isValid;

  String _value = '';
  String _errorText = '';

  String get keyValue => (widget.key as ValueKey).value as String;

  @override
  initState() {
    _textController = MaskedTextController(mask: '00');
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  set isValid(bool isValid) {
    if (isValid != _isValid) {
      _isValid = isValid;
      widget.onValidate(keyValue, _isValid, value: _value);
    }
  }

  @override
  Widget build(BuildContext context) {
    // set isValid
    isValid = false;

    //build input
    return Container(
      padding: EdgeInsets.only(top: widget.label.isNotEmpty ? 18 : 0),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          if (widget.label.isNotEmpty) Positioned(top: -24, child: Text(widget.label, style: Styles.inputLabel)),
          TextFormField(
            controller: _textController,
            style: Styles.orderTotalLabel,
            onChanged: _handleChange,
            keyboardType: TextInputType.number,
            autovalidate: _isAutoValidating,
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
          if (widget.inputType == CreditCardInputType.number)
            Positioned(top: 15, right: 18, child: Icon(_getCreditCardIcon(), size: 28, color: Styles.darkGrayColor))
        ],
      ),
    );
  }

  IconData _getCreditCardIcon() {
    switch (_creditCardType) {
      case CreditCardNetwork.visa:
        return FontAwesomeIcons.ccVisa;
      case CreditCardNetwork.mastercard:
        return FontAwesomeIcons.ccMastercard;
      case CreditCardNetwork.amex:
        return FontAwesomeIcons.ccAmex;
      default:
        return Icons.credit_card;
    }
  }

  String _getLabel() {
    String label = '';
    if (_value.isNotEmpty && widget.label.isEmpty) return widget.helper;
    return label;
  }

  void _handleChange(String value) {
    _value = value;
    Future.delayed(Duration(milliseconds: 100), () => setState(() {}));
    if (value.length == 2) _updateInputMask();
    if (!_isAutoValidating) {
      setState(() {
        _isAutoValidating = true;
      });
    }
  }

  String _validateField(String value) {
    // if is required
    if (value.isEmpty) {
      isValid = false;
      _errorText = 'Required';
      return _errorText;
    }
    // validate when the input has a value
    else if (value.isNotEmpty && InputValidator.validate(widget.inputType, value, cardNetwork: widget.cardNetwork)) {
      isValid = true;
      _errorText = '';
      return null;
    }
    // the value is not valid
    else {
      isValid = false;
      _errorText = 'Not Valid';
      return _errorText;
    }
  }

  void _updateInputMask() {
    switch (widget.inputType) {
      case CreditCardInputType.number:
        // Visa
        if (_value.substring(0, 1).compareTo('4') == 0) {
          _creditCardType = CreditCardNetwork.visa;
          _textController.updateMask('0000 0000 0000 0000');
        }
        // AMEX
        else if (_value.substring(0, 2) == '34' || _value.substring(0, 2) == '37') {
          _creditCardType = CreditCardNetwork.amex;
          _textController.updateMask('0000 000000 00000');
        }
        // Mastercard
        else if (_value.substring(0, 2) == '51' ||
            _value.substring(0, 2) == '52' ||
            _value.substring(0, 2) == '53' ||
            _value.substring(0, 2) == '54' ||
            _value.substring(0, 2) == '55') {
          _creditCardType = CreditCardNetwork.mastercard;
          _textController.updateMask('0000 0000 0000 0000');
        } else
          _creditCardType = null;
        break;
      case CreditCardInputType.expirationDate:
        _textController.updateMask('00/00');
        _textController.beforeChange = (String previous, String next) {
          return next.length <= 5;
        };
        break;
      case CreditCardInputType.securityCode:
        if (widget.cardNetwork == CreditCardNetwork.amex)
          _textController.updateMask('0000');
        else
          _textController.updateMask('000');
        break;
    }
    widget.onChange(_creditCardType);
  }
}
