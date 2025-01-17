import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/auth_model.dart';
import 'package:apotik_online/feature/domain/entity/profile_model.dart';
import 'package:apotik_online/feature/domain/entity/reset_password_model.dart';

abstract class AuthRepository {
  Fr login({required LoginModel model});
  Fr register({required RegisterModel model});
  Fr getDataUser();
  Fr logout();
  Fr sendSocial({required String provider});
  Fr checkEmail({required String email});
  Fr resendEmail({required String email});
  Fr updateImage({required ProfileModel model});
  Fr updatePassword({required PasswordModel model});
  Fr updateName({required String name});
  Fr sendResetCode({required String email});
  Fr verifyResetCode({required VerifyResetCodeModel model});
  Fr resetPassword({required ResetPasswordModel model});
}
