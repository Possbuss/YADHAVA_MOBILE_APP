import 'package:dio/dio.dart';

import '../../../core/data/auth_storage.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../data/refresh_model.dart';

class RefreshRepo{
  final ApiQuery apiQuery=ApiQuery();
  final AuthStorage _authStorage = AuthStorage();
  
  Future<RefreshModel> refreshRepo(
      Map<String, dynamic>data
      )async{
    try{
      final Response? response =
          await apiQuery.postQueryWithoutToken(ApiConstants.refreshToken, data);
      if (response == null || response.statusCode != 200) {
        throw Exception('Unexpected refresh response.');
      }

      final dynamic responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw Exception('Invalid refresh token response format.');
      }

      return RefreshModel.fromJson(responseData);
    } catch (e) {
      throw Exception('Refresh token request failed: $e');
    }
  }

  Future<void> storeToken(RefreshModel userData) =>
      _authStorage.storeRefreshToken(userData);

  Future<RefreshModel?> getTokenResponse() => _authStorage.getRefreshToken();

  Future<void> clearUserLoginResponse() async {
    await _authStorage.clearRefreshToken();
  }

}
