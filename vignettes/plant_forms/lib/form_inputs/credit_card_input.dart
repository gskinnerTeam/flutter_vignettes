import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../demo_data.dart';
import '../styles.dart';

class CreditCardInfoInput extends StatefulWidget {
  final String label;
  final String helper;
  final CreditCardInputType inputType;
  final CreditCardNetwork? cardNetwork;
  final void Function(String key, String value, bool isValid) onValidate;
  final void Function(CreditCardNetwork? cardNetwork)? onChange;
  final String initialValue;

  const CreditCardInfoInput({
    Key? key,
    this.label = '',
    this.helper = '',
    this.cardNetwork,
    required this.inputType,
    required this.onValidate,
    this.onChange,
    this.initialValue = '',
  }) : super(key: key);

  @override
  _CreditCardInfoInputState createState() => _CreditCardInfoInputState();
}

class _CreditCardInfoInputState extends State<CreditCardInfoInput> {
  MaskedTextController _textController = MaskedTextController(mask: '00');
  CreditCardNetwork? _creditCardType;
  bool _isAutoValidating = false;
  bool? _isValid;

  String _value = '';
  String _errorText = '';

  String get _keyValue => (widget.key as ValueKey).value as String;

  @override
  dispose() {
    super.dispose();
  }

  set isValid(bool isValid) {
    if (isValid != _isValid) {
      _isValid = isValid;
      widget.onValidate(_keyValue, _value, isValid);
    }
  }

  @override
  Widget build(BuildContext context) {
    // set isValid
    // isValid = false;
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
            controller: _textController,
            style: Styles.orderTotalLabel,
            onChanged: _handleChange,
            keyboardType: TextInputType.number,
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

  // TODO: Consolidate the code here and in TextInput
  String? _validateField(String? value) {
    // if is required
    if (value == null) {
      isValid = false;
      _errorText = 'Required';
      return _errorText;
    }
    // validate when the input has a value
    else if (value.isNotEmpty) {
      if (switch (widget.inputType) {
        CreditCardInputType.number => _validateCreditCardNumber(value, _creditCardType),
        CreditCardInputType.expirationDate => _validateCreditCardExpirationDate(value),
        CreditCardInputType.securityCode => _validateCreditCardSecurityCode(value, _creditCardType),
      }) {
        _errorText = '';
        return null;
      }
    }
    isValid = false;
    _errorText = 'Not Valid';
    return _errorText;
  }

  bool _validateCreditCardNumber(String value, CreditCardNetwork? cardNetwork) {
    // remove empty spaces
    String cardNumber = value.replaceAll(' ', '');
    if (cardNetwork == CreditCardNetwork.amex) {
      return cardNumber.length == 15;
    } else {
      return cardNumber.length == 16;
    }
  }

  bool _validateCreditCardSecurityCode(String value, CreditCardNetwork? cardNetwork) {
    if (cardNetwork == CreditCardNetwork.amex) {
      return value.length == 4;
    } else {
      return value.length == 3;
    }
  }

  bool _validateCreditCardExpirationDate(String value) {
    if (value.length > 3) {
      int month = int.parse(value.split('/').first);
      int year = int.parse(value.split('/').last);
      year += 2000;
      return month <= 12 && year >= DateTime.now().year;
    } else {
      return false;
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
    widget.onChange?.call(_creditCardType);
  }
}
