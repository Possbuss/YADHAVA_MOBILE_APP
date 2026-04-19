import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../getall_company_model.dart';

class CompanyLocalDataSource {
  static const String _companyListKey = 'GET_ALL_COMPANY_RESPONSE';

  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  Future<void> storeCompanyDetails(List<GetAllCompanyModel> companies) async {
    final SharedPreferences prefs = await _prefs;
    final String companyListJson =
        json.encode(companies.map((e) => e.toJson()).toList());
    await prefs.setString(_companyListKey, companyListJson);
  }

  Future<List<GetAllCompanyModel>> getStoredCompanyDetails() async {
    final SharedPreferences prefs = await _prefs;
    final String? companyListJson = prefs.getString(_companyListKey);

    if (companyListJson == null || companyListJson.isEmpty) {
      return [];
    }

    final List<dynamic> decodedList = json.decode(companyListJson);
    return decodedList
        .map((e) => GetAllCompanyModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
