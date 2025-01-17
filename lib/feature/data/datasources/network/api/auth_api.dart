import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/data/datasources/local/token_datasource.dart';
import 'package:apotik_online/feature/domain/entity/auth_model.dart';
import 'package:apotik_online/feature/domain/entity/profile_model.dart';
import 'package:apotik_online/feature/domain/entity/token_model.dart';
import 'package:apotik_online/feature/domain/entity/reset_password_model.dart';
import 'package:dio/dio.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Fr register({required RegisterModel model}) async {
    return await dio.post(
      AuthApiEndpoints.register,
      data: await model.toJson(),
    );
  }

  Fr login({required LoginModel model}) async {
    return await dio.post(
      AuthApiEndpoints.login,
      data: model.toJson(),
    );
  }

  Fr sendSocial({required String provider}) async {
    return await dio.get('${AuthApiEndpoints.social}/$provider');
  }

  Fr getDataUser() async {
    return await dio.get(
      AuthApiEndpoints.getDataUser,
    );
  }

  Fr logout() async {
    TokenModel? tokens = await TokenDataSource.getToken();
    FormData form = FormData.fromMap({
      'refresh_token': tokens?.refreshToken,
    });
    return await dio.post(
      AuthApiEndpoints.logout,
      data: form,
    );
  }

  Fr checkEmail({
    required String email,
  }) async {
    FormData form = FormData.fromMap({
      'email': email,
    });
    return await dio.post(
      AuthApiEndpoints.checkVerifyEmail,
      data: form,
    );
  }

  Fr resendEmail({
    required String email,
  }) async {
    FormData form = FormData.fromMap({
      'email': email,
    });
    return await dio.post(
      AuthApiEndpoints.resend,
      data: form,
    );
  }

  Fr updateImage({required ProfileModel model}) async {
    return await dio.post(
      AuthApiEndpoints.updateImage,
      data: await model.toJson(),
    );
  }

  Fr updateName({required String name}) async {
    FormData form = FormData.fromMap({
      'name': name,
    });
    return await dio.post(
      AuthApiEndpoints.updateName,
      data: form,
    );
  }

  Fr updatePassword({
    required PasswordModel model,
  }) async {
    return await dio.post(
      AuthApiEndpoints.updatePassword,
      data: model.toJson(),
    );
  }

  Fr sendResetCode({
    required String email,
  }) async {
    FormData form = FormData.fromMap({
      'email': email,
    });
    return await dio.post(
      AuthApiEndpoints.sendResetCode,
      data: form,
    );
  }

  Fr verifyResetCode({
    required VerifyResetCodeModel model,
  }) async {
    return await dio.post(
      AuthApiEndpoints.verifyResetCode,
      data: model.toJson(),
    );
  }

  Fr resetPassword({
    required ResetPasswordModel model,
  }) async {
    return await dio.post(
      AuthApiEndpoints.resetPassword,
      data: model.toJson(),
    );
  }
}
