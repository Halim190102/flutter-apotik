import 'dart:io';

import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:dio/dio.dart';

class ProfileModel {
  int? id;
  String? profilepict, name, email, role, emailVerifiedAt;

  ProfileModel({
    this.id,
    this.profilepict,
    this.name,
    this.email,
    this.role,
    this.emailVerifiedAt,
  });

  ProfileModel.fromJson(M json) {
    id = json['id'];
    profilepict = json['profilepict'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    emailVerifiedAt = json['email_verified_at'];
  }

  Ff toJson() async {
    return FormData.fromMap({
      if (id != null) 'id': id,
      if (profilepict != null) 'profilepict': await pictureData(profilepict!),
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (emailVerifiedAt != null) 'email_verified_at': emailVerifiedAt,
    });
  }

  Future<MultipartFile?> pictureData(String pictures) async {
    return await ImageModel(profilepict: pictures).toJson();
  }
}

class ImageModel {
  final String profilepict;

  ImageModel({
    required this.profilepict,
  });

  Future<MultipartFile?> toJson() async {
    if (profilepict.isEmpty) return null;

    String filePath = File(profilepict).path;
    String fileName = filePath.split('/').last;

    return await MultipartFile.fromFile(
      filePath,
      filename: fileName,
    );
  }
}

class PasswordModel {
  final String currentpassword, password, passwordconfirmation;

  PasswordModel({
    required this.currentpassword,
    required this.password,
    required this.passwordconfirmation,
  });

  M toJson() {
    final M data = <String, dynamic>{};
    data['current_password'] = currentpassword;
    data['password'] = password;
    data['password_confirmation'] = passwordconfirmation;
    return data;
  }
}
