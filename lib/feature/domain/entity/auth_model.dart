import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/profile_model.dart';
import 'package:dio/dio.dart';

class LoginModel {
  String? email, password;

  LoginModel({
    this.email,
    this.password,
  });

  M toJson() {
    final M data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}

class RegisterModel {
  String? name, email, password, passwordconfirmation, profilepict;

  RegisterModel({
    this.name,
    this.email,
    this.password,
    this.passwordconfirmation,
    this.profilepict,
  });

  Ff toJson() async {
    return FormData.fromMap({
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (passwordconfirmation != null)
        'password_confirmation': passwordconfirmation,
      if (profilepict != null) 'profilepict': await pictureData(profilepict!),
    });
  }

  Future<MultipartFile?> pictureData(String pictures) async {
    return await ImageModel(profilepict: pictures).toJson();
  }
}
