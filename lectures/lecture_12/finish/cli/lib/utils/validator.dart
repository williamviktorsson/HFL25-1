class Validator {
// check that nullable string is number
  static bool isNumber(String? value) {
    if (value == null) {
      return false;
    }
    final n = num.tryParse(value);
    return n != null;
  }

  static bool isString(String? value) {
    return value != null && value.isNotEmpty;
  }

  static bool isIndex(String? value, Iterable list) {
    if (!isNumber(value)) {
      return false;
    }
    final index = int.parse(value!);
    return index >= 1 && index < list.length + 1;
  }
}
