import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../mobile_app_user_profile.dart';

class MobileAppUserProfileLocalDataSource {
  static const String _storageKey = 'MOBILE_APP_USER_PROFILE';

  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  Future<MobileAppUserProfile?> getProfile() async {
    final SharedPreferences prefs = await _prefs;
    final String? storedValue = prefs.getString(_storageKey);
    if (storedValue == null || storedValue.isEmpty) {
      return null;
    }

    try {
      return MobileAppUserProfile.fromJson(
        json.decode(storedValue) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> storeProfile(MobileAppUserProfile profile) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(_storageKey, json.encode(profile.toJson()));
  }
}
