import 'dart:convert';

import 'package:Yadhava/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

import '../../../core/util/api_query.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
import '../data/sales_summery.dart'; // Assuming the SalesSummery model is in this path

class CashCreditSummaryRepository {
  final ApiQuery apiQuery = ApiQuery();
  Session session = Session();
  GetLoginRepo loginRepo = GetLoginRepo();

  Future<Response?> fetchCreditSummary({required String date}) async {
    String token = await session.tokenExpired();
    LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
    print(
        '${ApiConstants.cashCreditSalesSummeryGet}companyId=${storedResponse?.companyId}&payType=CREDIT&branchId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&driverId=${storedResponse?.employeeId}&invoiceDate=$date');
    try {
      final response = await apiQuery.getQuery(
          '${ApiConstants.cashCreditSalesSummeryGet}companyId=${storedResponse?.companyId}&payType=CREDIT&branchId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&driverId=${storedResponse?.employeeId}&invoiceDate=$date',
          token);

      return response;
    } catch (e) {
      throw Exception('Error fetching sales summary: $e');
    }
  }

  Future<Response?> fetchCashSummary({required String date}) async {
    String token = await session.tokenExpired();
    LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
    print(
        '${ApiConstants.cashCreditSalesSummeryGet}companyId=${storedResponse?.companyId}&payType=CASH&branchId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&driverId=${storedResponse?.employeeId}&invoiceDate=$date');
    try {
      final response = await apiQuery.getQuery(
          '${ApiConstants.cashCreditSalesSummeryGet}companyId=${storedResponse?.companyId}&payType=CASH&branchId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&driverId=${storedResponse?.employeeId}&invoiceDate=$date',
          token);

      return response;
    } catch (e) {
      throw Exception('Error fetching sales summary: $e');
    }
  }

  Future<Response?> fetchCashCreditSummary({required String date}) async {
    String token = await session.tokenExpired();
    LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
    print(
        '${ApiConstants.mobileCollectionCreditCashCustomer}companyId=${storedResponse?.companyId}&payType=CASH&vehicleId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&salesmanId=${storedResponse?.employeeId}&voucherDate=$date');
    try {
      final response = await apiQuery.getQuery(
          '${ApiConstants.mobileCollectionCreditCashCustomer}companyId=${storedResponse?.companyId}&payType=CASH&vehicleId=${storedResponse?.vehicleId}&routeId=${storedResponse?.routeId}&salesmanId=${storedResponse?.employeeId}&voucherDate=$date',
          token);

      return response;
    } catch (e) {
      throw Exception('Error fetching credit cash summary: $e');
    }
  }
}
