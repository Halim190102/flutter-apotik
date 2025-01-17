import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/auth_model.dart';
import 'package:apotik_online/feature/domain/entity/profile_model.dart';
import 'package:apotik_online/feature/domain/entity/reset_password_model.dart';
import 'package:apotik_online/feature/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Fr login({required LoginModel model}) async {
    return await repository.login(model: model);
  }

  Fr register({required RegisterModel model}) async {
    return await repository.register(model: model);
  }

  Fr sendSocial({required String provider}) async {
    return await repository.sendSocial(provider: provider);
  }

  Fr getDataUser() async {
    return await repository.getDataUser();
  }

  Fr logout() async {
    return await repository.logout();
  }

  Fr checkEmail({required String email}) async {
    return await repository.checkEmail(email: email);
  }

  Fr resendEmail({required String email}) async {
    return await repository.resendEmail(email: email);
  }

  Fr updateImage({required ProfileModel model}) async {
    return await repository.updateImage(model: model);
  }

  Fr updatePassword({required PasswordModel model}) async {
    return await repository.updatePassword(model: model);
  }

  Fr updateName({required String name}) async {
    return await repository.updateName(name: name);
  }

  Fr sendResetCode({required String email}) async {
    return await repository.sendResetCode(email: email);
  }

  Fr verifyResetCode({required VerifyResetCodeModel model}) async {
    return await repository.verifyResetCode(model: model);
  }

  Fr resetPassword({required ResetPasswordModel model}) async {
    return await repository.resetPassword(model: model);
  }
}
