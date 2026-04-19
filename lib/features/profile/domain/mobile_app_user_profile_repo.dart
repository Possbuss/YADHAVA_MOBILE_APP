import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
import '../data/mobile_app_user_profile.dart';
import '../data/local/mobile_app_user_profile_local_data_source.dart';

class MobileAppUserProfileRepo {
  MobileAppUserProfileRepo({
    ApiQuery? apiQuery,
    GetLoginRepo? loginRepo,
    MobileAppUserProfileLocalDataSource? localDataSource,
  })  : _apiQuery = apiQuery ?? ApiQuery(),
        _loginRepo = loginRepo ?? GetLoginRepo(),
        _localDataSource =
            localDataSource ?? MobileAppUserProfileLocalDataSource();

  final ApiQuery _apiQuery;
  final GetLoginRepo _loginRepo;
  final MobileAppUserProfileLocalDataSource _localDataSource;

  Future<MobileAppUserProfile?> getStoredProfile() =>
      _localDataSource.getProfile();

  Future<MobileAppUserProfile?> getProfile() async {
    final LoginModel? loginModel = await _loginRepo.getUserLoginResponse();
    if (loginModel == null) {
      return null;
    }

    final MobileAppUserProfile? storedProfile = await getStoredProfile();

    try {
      final response = await _apiQuery.getQuery(
        '${ApiConstants.getMobileAppUserProfile}companyId=${loginModel.companyId}&employeeId=${loginModel.employeeId}',
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

  Future<void> storeProfile(MobileAppUserProfile profile) =>
      _localDataSource.storeProfile(profile);

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
    final response = await _apiQuery.postQuery(
      ApiConstants.updateMobileAppUserProfile,
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
