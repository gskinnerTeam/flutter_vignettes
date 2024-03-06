import 'package:flutter/cupertino.dart';

mixin FormMixin {
  @protected
  Map<String, bool> validInputsMap = {};

  @protected
  double formCompletion = 0;

  @protected
  bool isFormErrorVisible = false;

  @protected
  void onItemValidate(String name, String value, bool isValid);

  @protected
  void onItemChange(String name, String value);

  int countValidItems() {
    int count = 0;
    validInputsMap.forEach((name, isValid) {
      if (isValid) count++;
    });
    return count;
  }
}
