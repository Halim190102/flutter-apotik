import 'package:flutter/material.dart';

const String baseUrl = 'http://192.168.1.9:8000';

const a = '/api/';

const String cartItemsEndPoint = '${a}cart_items';

class AuthApiEndpoints {
  static const String login = '${a}login';
  static const String register = '${a}register';
  static const String logout = '${a}logout';
  static const String getDataUser = '${a}profile';
  static const String checkVerifyEmail = '${a}check_verify_email';
  static const String resend = '${a}resend_email';
  static const String refresh = '${a}refresh';
  static const String updateName = '${a}update_name';
  static const String updatePassword = '${a}update_password';
  static const String updateImage = '${a}update_image';
  static const String sendResetCode = '${a}send_reset_code';
  static const String verifyResetCode = '${a}verify_reset_code';
  static const String resetPassword = '${a}reset_password';
  static const String social = '${a}auth';
}

class DrugsApiEndpoints {
  static const String drugsCategories = '${a}categories';
  static const String drugsCategoriesMulti = '${a}categories_delete';
  static const String drugsProducts = '${a}products';
  static const String drugsProductsMulti = '${a}products_delete';
}

class OrdersApiEndpoints {
  static const String orders = '${a}orders';
  static const String changeStatus = '${a}change_status';
  static const String cancelled = '${a}cancelled';
  static const String ordersMulti = '${a}orders_delete';
}

class GlobalVariable {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
}
