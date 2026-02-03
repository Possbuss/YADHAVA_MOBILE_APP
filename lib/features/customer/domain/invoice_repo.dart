
import 'package:Yadhava/features/customer/model/mobile_app_sales_Invoice_all.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/local_db_helper.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';

import 'package:shared_preferences/shared_preferences.dart';

class InvoiceRepo {
  final ApiQuery apiQuery = ApiQuery();
  GetLoginRepo loginRepo = GetLoginRepo();
  Session session = Session();
  late MobileAppSalesInvoiceAll mobileAppSalesInvoiceAll;

  Future<bool> syncInvoiceDataAll({
    required int routeId,
    required int companyId,
  }) async {
    try {
      int salesmanId = 0;
      int vehicleId = 0;
      int clientId = 0;

      var syncStatus = await getInvoiceSyncStatus();
      if(syncStatus == "SYNCED"){
        return true;
      }
      else{


        String token = await session.tokenExpired();
        final response = await apiQuery.getQuery(
            "${ApiConstants.mobileAppInvoices}salesmanId=$salesmanId&routeId=$routeId&vehicleId=$vehicleId&companyId=$companyId&clientId=$clientId",
            token);

        if (response != null && response.statusCode == 200) {
          mobileAppSalesInvoiceAll =
              MobileAppSalesInvoiceAll.fromJson(response.data);

          final db = LocalDbHelper();

          if (mobileAppSalesInvoiceAll.mobileAppSalesInvoiceMaster!.isNotEmpty) {
            await db.clearInvoiceTablesAll(companyId);
            await db.insertInvoices(
                mobileAppSalesInvoiceAll.mobileAppSalesInvoiceMaster,
                mobileAppSalesInvoiceAll.mobileAppSalesInvoiceMasterDt);
          }

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("INVOICE_SYNC", "SYNCED");

          return true;
        } else if (response != null &&
            (response.statusCode == 401 || response.statusCode == 400)) {
          return false;
        } else {
          return false;
        }

      }
    } catch (ex) {
      return false;
    }
  }

  Future<String?> getInvoiceSyncStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("INVOICE_SYNC") == null) {
      return null;
    } else {
      String? invoiceSync = prefs.getString("INVOICE_SYNC");
      return invoiceSync;
    }
  }

  Future<List<MobileAppSalesInvoiceMaster>> getInvoices({
    required int salesmanId,
    required int routeId,
    required int vehicleId,
    required int companyId,
    required int clientId,
  }) async {
    try {
      vehicleId = 0;
      routeId = 0;

      final db = LocalDbHelper();

      var result = await db.getAllInvoices(clientId, vehicleId, companyId);
      return result;


      var isEmpty = await db.isEmptyInvoice(clientId, companyId);

      if (!isEmpty) {
        var result = await db.getAllInvoices(clientId, vehicleId, companyId);
        return result;
      } else {
        LoginModel? loginModel = await loginRepo.getUserLoginResponse();
        if (loginModel == null) {
          throw Exception("User login response is null");
        }

        String token = await session.tokenExpired();
        final response = await apiQuery.getQuery(
            "${ApiConstants.mobileAppInvoices}salesmanId=$salesmanId&routeId=$routeId&vehicleId=$vehicleId&companyId=$companyId&clientId=$clientId",
            token);

        if (response != null && response.statusCode == 200) {
          final data = response.data;
          mobileAppSalesInvoiceAll =
              MobileAppSalesInvoiceAll.fromJson(response.data);

          if (mobileAppSalesInvoiceAll
              .mobileAppSalesInvoiceMaster!.isNotEmpty) {
            await db.clearInvoiceTables(clientId, companyId);
            await db.insertInvoices(
                mobileAppSalesInvoiceAll.mobileAppSalesInvoiceMaster,
                mobileAppSalesInvoiceAll.mobileAppSalesInvoiceMasterDt);
          }
          var result = await db.getAllInvoices(clientId, vehicleId, companyId);
          return result;
        } else if (response != null &&
            (response.statusCode == 401 || response.statusCode == 400)) {
          print("Error: ${response.statusCode}, Unauthorized or Bad Request.");
          throw Exception('Unauthorized or Bad Request');
        } else {
          print("Unexpected response: ${response?.statusCode}");
          throw Exception('Unexpected error occurred.');
        }
      }
    } catch (ex) {
      throw Exception('Failed to fetch invoice details: ${ex.toString()}');
    }
  }

  Future<void> deleteInvoice(String invoiceNo, int companyId) async {
    String token = await session.tokenExpired();

    try {
      final Map<String, dynamic> payload = {
        "invoiceNo": invoiceNo,
        "companyId": 1,
      };

      final response = await apiQuery.postQuery(
        ApiConstants.deleteInvoice,
        token,
        payload,
      );

      if (response != null && response.statusCode == 200) {
        if (response.data == 'Success') {
          print("MobileAppSalesInvoice deleted successfully.");
          var db = LocalDbHelper();
          await db.clearInvoiceTablesByInvoiceNo(invoiceNo, companyId);
        } else {
          print(response.data);
        }
      } else {
        print(
            "Failed to delete MobileAppSalesInvoice: ${response?.statusCode}");
        throw Exception('Failed to delete MobileAppSalesInvoice');
      }
    } catch (ex) {
      throw Exception(
          'Failed to delete MobileAppSalesInvoice: ${ex.toString()}');
    }
  }
}
