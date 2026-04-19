// ignore_for_file: use_build_context_synchronously

import 'package:Yadhava/features/auth/domain/refresh_repo.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/local_db_helper.dart';
import '../../splash/presentation/splash.dart';
import '../data/login_model.dart';
import '../data/logout_model.dart';
import 'login_repo.dart';

class Logoutrepo {
  final ApiQuery apiQuery = ApiQuery();
  final GetLoginRepo loginRepo = GetLoginRepo();
  final RefreshRepo _refreshRepo = RefreshRepo();

  Future<void> logout(BuildContext context) async {
    try {
      LoginModel? loginModel = await loginRepo.getUserLoginResponse();
      if (loginModel == null) throw Exception("LoginModel is null");

      LogoutModel logoutModel = LogoutModel(
        userId: loginModel.userId,
        routeId: loginModel.routeId,
        vehicleId: loginModel.vehicleId,
        deviceId: loginModel.deviceId,
        companyId: loginModel.companyId,
      );

      final response =
          await apiQuery.postQuery(ApiConstants.logout, logoutModel.toJson());

      if (response == null) throw Exception("No response received from the API");

      if (response.statusCode == 200) {

        var db = LocalDbHelper();

        db.clearCashCreditDetails();
        db.clearCashSummary();
        db.clearCreditSummary();
        db.clearSalesSummary();
        db.clearProductStocks();
        db.clearCompanyDetails();
        db.clearRouteHistoryAllData();
        db.clearTransactions();
        db.clearReceiptsPaymentsAll();
        db.clearLastInvoiceDataAll();
        db.clearInvoiceTablesAllData();
        db.clearPendingOrdersData();

        await loginRepo.clearUserLoginResponse();

        await loginRepo.clearStringValue("LAST_INVOICE_SYNC");
        await loginRepo.clearStringValue("INVOICE_SYNC");

        await loginRepo.clearStringValue("USER_PSD");
        await loginRepo.clearStringValue("GET_ALL_COMPANY_RESPONSE");
        await loginRepo.clearStringValue("selected_vehicle");
        await loginRepo.clearStringValue("selected_route");
        await _refreshRepo.clearUserLoginResponse();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        throw Exception('Unexpected error occurred.');
      }
    } catch (ex) {
      throw Exception('Failed to logout: ${ex.toString()}');
    }
  }

}
