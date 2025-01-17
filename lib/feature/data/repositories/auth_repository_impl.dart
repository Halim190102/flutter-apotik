import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/data/datasources/network/api/auth_api.dart';
import 'package:apotik_online/feature/domain/entity/auth_model.dart';
import 'package:apotik_online/feature/domain/entity/profile_model.dart';
import 'package:apotik_online/feature/domain/entity/reset_password_model.dart';
import 'package:apotik_online/feature/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Fr login({required LoginModel model}) async {
    return await api.login(model: model);
  }

  @override
  Fr getDataUser() async {
    return await api.getDataUser();
  }

  @override
  Fr register({required RegisterModel model}) async {
    return await api.register(model: model);
  }

  @override
  Fr sendSocial({required String provider}) async {
    return await api.sendSocial(provider: provider);
  }

  @override
  Fr logout() async {
    return await api.logout();
  }

  @override
  Fr checkEmail({required String email}) async {
    return await api.checkEmail(email: email);
  }

  @override
  Fr resendEmail({required String email}) async {
    return await api.resendEmail(email: email);
  }

  @override
  Fr updateImage({required ProfileModel model}) async {
    return await api.updateImage(model: model);
  }

  @override
  Fr resetPassword({required ResetPasswordModel model}) async {
    return await api.resetPassword(model: model);
  }

  @override
  Fr sendResetCode({required String email}) async {
    return await api.sendResetCode(email: email);
  }

  @override
  Fr verifyResetCode({required VerifyResetCodeModel model}) async {
    return await api.verifyResetCode(model: model);
  }

  @override
  Fr updateName({required String name}) async {
    return await api.updateName(name: name);
  }

  @override
  Fr updatePassword({required PasswordModel model}) async {
    return await api.updatePassword(model: model);
  }
}
