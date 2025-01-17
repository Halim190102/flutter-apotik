import 'package:email_validator/email_validator.dart';

class Validator {
  static validateNama(String? e) {
    if (e!.isEmpty) return 'Name cannot be empty';
    return null;
  }

  static validateDescription(String? e) {
    if (e!.isEmpty) return 'Description cannot be empty';
    return null;
  }

  static validateStock(String? e) {
    if (e!.isEmpty) return 'Stock cannot be empty';
    return null;
  }

  static validatePrice(String? e) {
    if (e!.isEmpty) return 'Price cannot be empty';
    return null;
  }

  static validateEmail(String? e) {
    if (e!.isEmpty) {
      return 'Email cannot be empty';
    } else if (!EmailValidator.validate(e)) {
      return 'Enter the appropriate format';
    }
    return null;
  }

  static validateUsername(String? e) {
    if (e!.isEmpty) return 'Usename cannot be empty';
    return null;
  }

  static validatePassLog(String? e) {
    if (e!.isEmpty) return 'Password cannot be empty';
    return null;
  }

  static validatePass(String? e) {
    if (e!.isEmpty) {
      return 'Password cannot be empty';
    } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(e)) {
      return 'Enter at least 1 uppercase letter';
    } else if (!RegExp(r'(?=.*[a-z])').hasMatch(e)) {
      return 'Enter at least 1 lowercase letter';
    } else if (!RegExp(r'(?=.*[0-9])').hasMatch(e)) {
      return 'Enter at least 1 number';
    } else if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(e)) {
      return 'Enter at least 1 special character';
    } else if (e.length < 6) {
      return 'Enter at least 6 characters';
    }
    return null;
  }

  static validatePassReplay(String? e, String? a) {
    if (e!.isEmpty) {
      return 'Confirm password cannot be empty';
    } else if (e != a) {
      return 'Confirm Password must be the same';
    }
    return null;
  }

  static validateCode(String? e) {
    if (e!.isEmpty) return 'Code cannot be empty';
    return null;
  }

  // static validateImage(String? e) {
  //   if (e!.isEmpty) return 'Image cannot be empty';
  //   return null;
  // }
}
