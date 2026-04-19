import 'package:dio/dio.dart';

import '../../../core/data/auth_storage.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../data/login_model.dart';

class GetLoginRepo{
   static final GetLoginRepo _instance = GetLoginRepo._internal();

   factory GetLoginRepo() => _instance;

   GetLoginRepo._internal();

   final ApiQuery apiQuery=ApiQuery();
   final AuthStorage _authStorage = AuthStorage();

   Future<LoginModel> loginRepo(
       Map<String,dynamic>data
       )async{
      try {
         final Response? response = await apiQuery.postQueryWithoutToken(
             ApiConstants.login, data);
         if (response == null || response.statusCode != 200) {
            throw Exception('Unexpected login response.');
         }

         final dynamic rawData = response.data;
         if (rawData is! List || rawData.isEmpty || rawData.first is! Map<String, dynamic>) {
            throw Exception('Invalid login response format.');
         }

         return LoginModel.fromJson(rawData.first as Map<String, dynamic>);
      } catch (ex) {
         throw Exception('Login failed: $ex');
      }
   }

   /// login

   Future<void> storeUserLoginResponse(LoginModel userData) =>
       _authStorage.storeLogin(userData);

   Future<LoginModel?> getUserLoginResponse() => _authStorage.getLogin();

   Future<void> clearUserLoginResponse() async {
      await _authStorage.clearLogin();
   }


   /// psd

   Future<void> storeStringValue(String key, String value) =>
       _authStorage.storeString(key, value);

   Future<String?> getStringValue(String key) => _authStorage.getString(key);

   Future<void> clearStringValue(String key) => _authStorage.clearString(key);

}
