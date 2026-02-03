// ignore_for_file: use_build_context_synchronously

import 'package:Yadhava/features/auth/domain/refresh_repo.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/local_db_helper.dart';
import '../../../core/util/session.dart';
import '../../splash/presentation/splash.dart';
import '../data/login_model.dart';
import '../data/logout_model.dart';
import 'login_repo.dart';

class Logoutrepo {
  final ApiQuery apiQuery = ApiQuery();
  GetLoginRepo loginRepo = GetLoginRepo();
  Session session = Session();
  Future<void> logout(BuildContext context) async {
    String token = await session.tokenExpired();

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

      final response = await apiQuery.postQuery(ApiConstants.logout, token, logoutModel.toJson());

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

        GetLoginRepo().clearUserLoginResponse();

        GetLoginRepo().clearStringValue("LAST_INVOICE_SYNC");
        GetLoginRepo().clearStringValue("INVOICE_SYNC");

        GetLoginRepo().clearStringValue("USER_PSD");
        GetLoginRepo().clearStringValue("GET_ALL_COMPANY_RESPONSE");
        GetLoginRepo().clearStringValue("selected_vehicle");
        GetLoginRepo().clearStringValue("selected_route");
        RefreshRepo().clearUserLoginResponse();
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
