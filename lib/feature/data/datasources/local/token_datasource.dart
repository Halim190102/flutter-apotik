import 'dart:async';
import 'dart:convert';

import 'package:apotik_online/feature/domain/entity/token_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenDataSource {
  static const String _tokenKey = 'token';

  static Future<void> saveToken(TokenModel token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenJson = jsonEncode(token.toJson());
    await prefs.setString(_tokenKey, tokenJson);
  }

  static Future<TokenModel?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenJson = prefs.getString(_tokenKey);
    if (tokenJson == null) return null;

    Map<String, dynamic> tokenMap = jsonDecode(tokenJson);
    return TokenModel.fromJson(tokenMap);
  }

  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
