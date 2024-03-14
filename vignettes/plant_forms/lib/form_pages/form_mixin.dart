mixin FormMixin {
  Map<String, bool> validInputsMap = {};
  double formCompletion = 0;
  bool isFormErrorVisible = false;

  void onItemValidate(String name, bool isValid, {String value});
  void onItemChange(String name, String value);

  int countValidItems() {
    int count = 0;
    validInputsMap.forEach((name, isValid) {
      if (isValid) count++;
    });
    return count;
  }
}
