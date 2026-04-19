import 'package:Yadhava/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

import '../../../core/util/api_query.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';

class CashCreditSummaryRepository {
  final ApiQuery apiQuery = ApiQuery();
  final GetLoginRepo loginRepo = GetLoginRepo();

  Future<Response?> fetchCreditSummary({required String date}) async {
    LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
    try {
      final response = await apiQuery.getQuery(
          '${ApiConstants.cashCreditSalesSummeryGet}companyId=${storedResponse?.companyId}&payType=CREDIT&branchId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&driverId=${storedResponse?.employeeId}&invoiceDate=$date');

      return response;
    } catch (e) {
      throw Exception('Error fetching sales summary: $e');
    }
  }

  Future<Response?> fetchCashSummary({required String date}) async {
    LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
    try {
      final response = await apiQuery.getQuery(
          '${ApiConstants.cashCreditSalesSummeryGet}companyId=${storedResponse?.companyId}&payType=CASH&branchId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&driverId=${storedResponse?.employeeId}&invoiceDate=$date');

      return response;
    } catch (e) {
      throw Exception('Error fetching sales summary: $e');
    }
  }

  Future<Response?> fetchCashCreditSummary({required String date}) async {
    LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
    try {
      final response = await apiQuery.getQuery(
          '${ApiConstants.mobileCollectionCreditCashCustomer}companyId=${storedResponse?.companyId}&payType=CASH&vehicleId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&salesmanId=${storedResponse?.employeeId}&voucherDate=$date');

      return response;
    } catch (e) {
      throw Exception('Error fetching credit cash summary: $e');
    }
  }
}
