import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
import '../data/mobile_app_user_profile.dart';

class MobileAppUserProfileRepo {
  static const String _storageKey = 'MOBILE_APP_USER_PROFILE';

  final ApiQuery _apiQuery = ApiQuery();
  final Session _session = Session();
  final GetLoginRepo _loginRepo = GetLoginRepo();

  Future<MobileAppUserProfile?> getStoredProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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

  Future<MobileAppUserProfile?> getProfile() async {
    final LoginModel? loginModel = await _loginRepo.getUserLoginResponse();
    if (loginModel == null) {
      return null;
    }

    final MobileAppUserProfile? storedProfile = await getStoredProfile();

    try {
      final String token = await _session.tokenExpired();
      final response = await _apiQuery.getQuery(
        '${ApiConstants.getMobileAppUserProfile}companyId=${loginModel.companyId}&employeeId=${loginModel.employeeId}',
        token,
      );

      final dynamic data = response?.data;
      if (data is Map<String, dynamic>) {
        final MobileAppUserProfile remoteProfile =
            MobileAppUserProfile.fromJson(
          data,
        ).copyWith(
          userPassword: storedProfile?.userPassword ?? '',
          localImagePath: storedProfile?.localImagePath ?? '',
        );

        await storeProfile(remoteProfile);
        await updateStoredLoginProfile(remoteProfile);
        return remoteProfile;
      }
    } catch (_) {
      if (storedProfile != null) {
        return storedProfile;
      }
    }

    final MobileAppUserProfile fallbackProfile = MobileAppUserProfile.fromLogin(
      loginModel,
    ).copyWith(
      localImagePath: storedProfile?.localImagePath ?? '',
      employeeImage: storedProfile?.employeeImage ?? '',
      mobile: storedProfile?.mobile ?? '',
      phone: storedProfile?.phone ?? '',
      emailId: storedProfile?.emailId ?? '',
      address: storedProfile?.address ?? '',
      userPassword: storedProfile?.userPassword ?? '',
    );
    await storeProfile(fallbackProfile);
    return fallbackProfile;
  }

  Future<void> storeProfile(MobileAppUserProfile profile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, json.encode(profile.toJson()));
  }

  Future<void> updateStoredLoginProfile(MobileAppUserProfile profile) async {
    final LoginModel? loginModel = await _loginRepo.getUserLoginResponse();
    if (loginModel == null) {
      return;
    }

    loginModel.userName = profile.userName;
    loginModel.employeeName = profile.name;
    await _loginRepo.storeUserLoginResponse(loginModel);
  }

  Future<void> updateProfile(MobileAppUserProfile profile) async {
    final String token = await _session.tokenExpired();
    final response = await _apiQuery.postQuery(
      ApiConstants.updateMobileAppUserProfile,
      token,
      profile.toRequestJson(),
    );

    final dynamic data = response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic result = data['result'];
      if (result == false) {
        throw Exception(
            (data['message'] ?? 'Failed to update profile.').toString());
      }
    }

    await storeProfile(profile);
    await updateStoredLoginProfile(profile);
  }
}
