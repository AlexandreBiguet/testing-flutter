import 'package:email_validator/email_validator.dart';

bool validateEmail(String? string) {
  if (string == null) {
    return false;
  }

  return _isEmail(string);
}

bool _isEmail(String string) {
  return EmailValidator.validate(string);
}

bool validatePassword(String? string) {
  if (string == null) {
    return false;
  }

  if (string.length < 8) {
    return false;
  }

  return true;
}
