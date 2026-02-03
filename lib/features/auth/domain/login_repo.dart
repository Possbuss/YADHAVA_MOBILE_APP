// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../data/login_model.dart';

class GetLoginRepo{
   final ApiQuery apiQuery=ApiQuery();

   Future<Response?>LoginRepo(
       Map<String,dynamic>data
       )async{
      try {
         Response? response = await apiQuery.postQueryWithoutToken(
             ApiConstants.login, data);
         return response;
      }catch(ex){
         Exception(ex);
      }
      return null;
   }

   /// login

   storeUserLoginResponse(LoginModel userData) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userProfileJson = json.encode(userData.toJson());
      prefs.setString("USER_LOGIN_RESPONSE", userProfileJson);
   }

   Future<LoginModel?> getUserLoginResponse() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("USER_LOGIN_RESPONSE") == null) {
         return null;
      } else {
         String? userResponse = prefs.getString("USER_LOGIN_RESPONSE");
         return LoginModel.fromJson(json.decode(userResponse!));
      }
   }
   Future<void> clearUserLoginResponse() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("USER_LOGIN_RESPONSE");
      await prefs.clear();
   }


   /// psd

   Future<void> storeStringValue(String key, String value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
   }

   Future<String?> getStringValue(String key) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
   }

   Future<void> clearStringValue(String key) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
   }

}