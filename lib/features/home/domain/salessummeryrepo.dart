import 'dart:convert';

import 'package:Yadhava/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

import '../../../core/util/api_query.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
// Assuming the SalesSummery model is in this path

class SalesSummaryRepository {
  final ApiQuery apiQuery = ApiQuery();
  Session session = Session();
  GetLoginRepo loginRepo = GetLoginRepo();

  Future<Response?> fetchSalesSummary({required String date}) async {
    String token = await session.tokenExpired();
    LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
    print(
        '${ApiConstants.salesSummeryStatus}companyId=${storedResponse?.companyId}&vehicleId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&driverId=${storedResponse?.employeeId}&vchDate=$date');
    try {
      final response = await apiQuery.getQuery(
          '${ApiConstants.salesSummeryStatus}companyId=${storedResponse?.companyId}&vehicleId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&driverId=${storedResponse?.employeeId}&vchDate=$date',
          token);

      return response;
    } catch (e) {
      throw Exception('Error fetching sales summary: $e');
    }
  }
}
