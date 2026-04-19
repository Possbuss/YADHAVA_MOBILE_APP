import 'package:Yadhava/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

import '../../../core/util/api_query.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
// Assuming the SalesSummery model is in this path

class HomeRepository {
  final ApiQuery apiQuery = ApiQuery();
  final GetLoginRepo loginRepo = GetLoginRepo();

  Future<Response?> fetchMobileAppSalesDashBoardHome(
      {required String date}) async {
    LoginModel? storedResponse = await loginRepo.getUserLoginResponse();

    try {
      final response = await apiQuery.getQuery(
          '${ApiConstants.mobileAppSalesDashBoardHome}companyId=${storedResponse?.companyId}&vehicleId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&driverId=${storedResponse?.employeeId}&invoiceDate=$date');

      return response;
    } catch (e) {
      throw Exception('Error fetching sales summary: $e');
    }
  }
}
