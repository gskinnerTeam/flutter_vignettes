import 'package:plant_forms/demo_data.dart';
import 'package:plant_forms/demo_data.dart';

class InputValidator {
  const InputValidator();

  static bool validate(type, String value, {CreditCardNetwork cardNetwork}) {
    if (type.runtimeType == InputType) {
      switch (type as InputType) {
        case InputType.email:
          return _validateEmail(value);
        case InputType.telephone:
          return _validatePhoneNumber(value);
          break;
        default:
          return true;
      }
    }
    if (type.runtimeType == CreditCardInputType) {
      switch (type as CreditCardInputType) {
        case CreditCardInputType.number:
          return _validateCreditCardNumber(value, cardNetwork);
        case CreditCardInputType.expirationDate:
          return _validateCreditCardExpirationDate(value);
        case CreditCardInputType.securityCode:
          return _validateCreditCardSecurityCode(value, cardNetwork);
      }
    }
    return false;
  }

  static bool _validateEmail(String value) {
    RegExp emailRegExp = RegExp(r"(^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$)");
    return emailRegExp.hasMatch(value);
  }

  static bool _validatePhoneNumber(String value) {
    RegExp telRegExp = RegExp(r"(^(1\s?)?(\(\d{3}\)|\d{3})[\s\-]?\d{3}[\s\-]?\d{4}$)");
    return telRegExp.hasMatch(value);
  }

  static bool _validateCreditCardNumber(String value, CreditCardNetwork cardNetwork) {
    // remove empty spaces
    String cardNumber = value.replaceAll(' ', '');
    if (cardNetwork == CreditCardNetwork.amex) {
      return cardNumber.length == 15;
    } else {
      return cardNumber.length == 16;
    }
  }

  static bool _validateCreditCardSecurityCode(String value, CreditCardNetwork cardNetwork) {
    if (cardNetwork == CreditCardNetwork.amex) {
      return value.length == 4;
    } else {
      return value.length == 3;
    }
  }

  static bool _validateCreditCardExpirationDate(String value) {
    if (value.length > 3) {
      int month = int.parse(value.split('/').first);
      int year = int.parse(value.split('/').last);
      year += 2000;
      return month <= 12 && year >= DateTime.now().year;
    } else {
      return false;
    }
  }
}
