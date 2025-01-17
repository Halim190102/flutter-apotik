import 'package:apotik_online/core/utils/global_utils.dart';

class VerifyResetCodeModel {
  String? email, code;

  VerifyResetCodeModel({
    this.email,
    this.code,
  });

  M toJson() {
    final M data = <String, dynamic>{};
    data['email'] = email;
    data['code'] = code;
    return data;
  }
}

class ResetPasswordModel {
  String? email, password, passwordconfirmation;

  ResetPasswordModel({
    this.email,
    this.password,
    this.passwordconfirmation,
  });

  M toJson() {
    final M data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['password_confirmation'] = passwordconfirmation;
    return data;
  }
}
