
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../data/getall_company_model.dart';

class GetCompanyListRepo {
  final ApiQuery apiQuery = ApiQuery();

  Future<Response?> getCompanyListRepo() async {
    try {
      final response = await apiQuery.getWithOutQuery(ApiConstants.companyGetAll);
      return response;
    } catch (ex) {
      throw Exception('Failed to fetch company list: ${ex.toString()}');
    }
  }

  // storeCompanyDetail(GetAllCompanyModel userData) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String userProfileJson = json.encode(userData.toJson());
  //   prefs.setString("GET_ALL_COMPANY_RESPONSE", userProfileJson);
  // }

  Future<void> storeCompanyDetails(List<GetAllCompanyModel> companies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String companyListJson = json.encode(companies.map((e) => e.toJson()).toList());
    await prefs.setString("GET_ALL_COMPANY_RESPONSE", companyListJson);
  }

  Future<List<GetAllCompanyModel>> getStoredCompanyDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? companyListJson = prefs.getString("GET_ALL_COMPANY_RESPONSE");

    if (companyListJson != null) {
      List<dynamic> decodedList = json.decode(companyListJson);
      return decodedList.map((e) => GetAllCompanyModel.fromJson(e)).toList();
    }
    return [];
  }


}
