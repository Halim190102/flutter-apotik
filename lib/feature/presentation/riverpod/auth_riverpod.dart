import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/data/datasources/local/token_datasource.dart';
import 'package:apotik_online/feature/data/datasources/network/api/auth_api.dart';
import 'package:apotik_online/feature/data/repositories/auth_repository_impl.dart';
import 'package:apotik_online/feature/domain/entity/auth_model.dart';
import 'package:apotik_online/feature/domain/entity/profile_model.dart';
import 'package:apotik_online/feature/domain/entity/reset_password_model.dart';
import 'package:apotik_online/feature/domain/entity/token_model.dart';
import 'package:apotik_online/feature/domain/repositories/auth_repository.dart';
import 'package:apotik_online/feature/domain/usecase/auth_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authApiProvider =
    Provider<AuthApi>((ref) => AuthApi(ref.read(dioClientProvider).dio));

final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepositoryImpl(ref.read(authApiProvider)));

final useCaseProvider = Provider<AuthUseCase>(
    (ref) => AuthUseCase(ref.read(authRepositoryProvider)));

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref.read(useCaseProvider));
});

class AuthProvider extends BaseProvider {
  String emails = '';

  ProfileModel? profile;

  List<ProfileModel> patients = [];

  final AuthUseCase _usecase;

  AuthProvider(this._usecase);

  Fv login({
    required LoginModel model,
  }) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.login(model: model);
    if (response.statusCode == 200 && response.data['access_token'] != null) {
      TokenModel token = TokenModel.fromJson(response.data);
      await TokenDataSource.saveToken(token);
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      emails = model.email!;

      changeGlobalState(
        s: GlobalState.error,
        message: response.data['message'],
      );
    }
  }

  Fv register({required RegisterModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.register(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Registered successfully') {
      emails = model.email!;

      changeGlobalState(
        s: GlobalState.none,
        message: '',
      );
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['email'][0]);
    }
  }

  Fv getDataUser() async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.getDataUser();
    if (response.statusCode == 200 &&
        response.data['message'] == 'Get data success') {
      profile = ProfileModel.fromJson(
        response.data['data'],
      );
      if (profile?.role == 'admin') {
        for (var a in response.data['patient']) {
          final patient = ProfileModel.fromJson(a);
          patients.add(patient);
        }
      }
      changeGlobalState(
        s: GlobalState.none,
        message: response.data['message'],
      );
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv updateImage({required ProfileModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.updateImage(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Profile image updated successfully') {
      profile = ProfileModel.fromJson(
        response.data['data'],
      );
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv updateName({required String name}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.updateName(name: name);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Name updated successfully') {
      profile?.name = response.data['data']['name'];
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv updatePassword({required PasswordModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.updatePassword(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Password updated successfully') {
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv logout() async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.logout();
    if (response.statusCode == 200 &&
        response.data['message'] == 'Logged out successfully') {
      await TokenDataSource.clearToken();
      profile = null;
      emails = '';
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    }
  }

  Fs sendSocial({required String provider}) async {
    Response response = await _usecase.sendSocial(provider: provider);
    return response.data['url'];
  }

  Fv checkEmail() async {
    changeGlobalState(s: GlobalState.loading);

    Response response = await _usecase.checkEmail(email: emails);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Email has already been verified') {
      emails = '';

      changeGlobalState(
        s: GlobalState.none,
        message: response.data['message'],
      );
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv resendEmail() async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.resendEmail(email: emails);
    if (response.statusCode == 200) {
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv sendResetCode({required String email}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response =
        await _usecase.sendResetCode(email: email != '' ? email : emails);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Verification code has been send') {
      if (email != '') {
        emails = email;
      }
      changeGlobalState(
        s: GlobalState.none,
        message: response.data['message'],
      );
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv verifyResetCode({required String code}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.verifyResetCode(
      model: VerifyResetCodeModel(
        email: emails,
        code: code,
      ),
    );
    if (response.statusCode == 200 &&
        response.data['message'] == 'Reset code verified successfully') {
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv resetPassword(
      {required String password, required String passwordconfirmation}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.resetPassword(
        model: ResetPasswordModel(
      email: emails,
      password: password,
      passwordconfirmation: passwordconfirmation,
    ));
    if (response.statusCode == 200 &&
        response.data['message'] == 'Reset password success') {
      emails = '';
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  void option(int i) {
    switch (i) {
      case 1:
        changeGlobalState(s: GlobalState.error, message: 'Unauthorized');
        break;
      case 2:
        changeGlobalState(s: GlobalState.error, message: "You're offline");
        break;
    }
  }
}
