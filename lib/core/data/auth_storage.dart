import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/login_model.dart';
import '../../features/auth/data/refresh_model.dart';

class AuthStorage {
  static const String _userLoginResponseKey = 'USER_LOGIN_RESPONSE';
  static const String _tokenResponseKey = 'TOKEN_RESPONSE';

  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  Future<void> storeLogin(LoginModel userData) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(_userLoginResponseKey, json.encode(userData.toJson()));
  }

  Future<LoginModel?> getLogin() async {
    final SharedPreferences prefs = await _prefs;
    final String? userResponse = prefs.getString(_userLoginResponseKey);
    if (userResponse == null) {
      return null;
    }

    return LoginModel.fromJson(json.decode(userResponse));
  }

  Future<void> clearLogin() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(_userLoginResponseKey);
  }

  Future<void> storeRefreshToken(RefreshModel tokenData) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(_tokenResponseKey, json.encode(tokenData.toJson()));
  }

  Future<RefreshModel?> getRefreshToken() async {
    final SharedPreferences prefs = await _prefs;
    final String? tokenResponse = prefs.getString(_tokenResponseKey);
    if (tokenResponse == null) {
      return null;
    }

    return RefreshModel.fromJson(json.decode(tokenResponse));
  }

  Future<void> clearRefreshToken() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(_tokenResponseKey);
  }

  Future<void> storeString(String key, String value) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(key);
  }

  Future<void> clearString(String key) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(key);
  }

  Future<void> clearSessionData() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(_userLoginResponseKey);
    await prefs.remove(_tokenResponseKey);
  }
}
