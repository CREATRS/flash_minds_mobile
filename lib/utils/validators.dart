import 'package:get/get.dart';

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  } else if (!GetUtils.isEmail(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? lenghtValidator(String? value, int length) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  } else if (value.length < length) {
    return 'This field must be at least $length characters';
  }
  return null;
}

String? requiredValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}
