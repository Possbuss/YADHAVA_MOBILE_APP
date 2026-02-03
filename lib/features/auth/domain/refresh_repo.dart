import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../data/refresh_model.dart';

class RefreshRepo{
  final ApiQuery apiQuery=ApiQuery();
  
  Future<Response?>refreshRepo(
      Map<String, dynamic>data
      )async{
    try{
      Response? response=await apiQuery.postQueryWithoutToken(ApiConstants.refreshToken, data);
      // Response? response=await apiQuery.postQuery(ApiConstants.refreshToken, data);
      return response;
    }catch(e){
      Exception(e);
    }
    return null;
  }

  storeToken(RefreshModel userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userProfileJson = json.encode(userData.toJson());
    prefs.setString("TOKEN_RESPONSE", userProfileJson);
  }

  Future<RefreshModel?> getTokenResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("TOKEN_RESPONSE") == null) {
      return null;
    } else {
      String? userResponse = prefs.getString("TOKEN_RESPONSE");
      return RefreshModel.fromJson(json.decode(userResponse!));
    }
  }
  Future<void> clearUserLoginResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("TOKEN_RESPONSE");
    await prefs.clear();
  }

}