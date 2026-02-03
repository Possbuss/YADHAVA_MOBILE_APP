import 'dart:convert';
import 'package:Yadhava/core/constants/api_constants.dart';
import 'package:Yadhava/core/util/api_query.dart';
import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:Yadhava/features/customer/model/last_invoice_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';

class LastInvoiceRepository {
  ApiQuery apiQuery=ApiQuery();
  Session session=Session();
  GetLoginRepo loginRepo=GetLoginRepo();


  Future<bool> syncLastInvoiceAll(
      int partyId
      ) async {

    try {

      var syncStatus = await getLastInvoiceSyncStatus();
      if(syncStatus == "SYNCED"){
        return true;
      }else{
        LoginModel? loginModel = await loginRepo.getUserLoginResponse();
        int companyId=loginModel!.companyId;

        var db = LocalDbHelper();

        String token= await session.tokenExpired();
        String routeUrl="${ApiConstants.lastInvoiceAll}partyId=$partyId&companyId=$companyId";
        Response? response = await apiQuery.getQuery(routeUrl, token);

        if (response != null && response.statusCode == 200) {


          final data = response.data as List<dynamic>;
          final invoiceDetails = data.map((e) => MobileAppSalesInvoiceDetail.fromJson(e)).toList();
          await db.insertLastInvoiceData(invoiceDetails);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("LAST_INVOICE_SYNC", "SYNCED");

          return true;
        } else {
          return false;
        }
      }
    }
    catch(ex){
      return false;
    }
  }

  Future<String?> getLastInvoiceSyncStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("LAST_INVOICE_SYNC") == null) {
      return null;
    } else {
      String? invoiceSync = prefs.getString("LAST_INVOICE_SYNC");
      return invoiceSync;
    }
  }

  Future<List<MobileAppSalesInvoiceDetail>> fetchLastInvoice(
      int partyId
      ) async {

    try {

      LoginModel? loginModel = await loginRepo.getUserLoginResponse();
      int companyId=loginModel!.companyId;

      var db = LocalDbHelper();
      return await db.getLastInvoiceData(partyId, companyId);




      bool isEmpty = await db.isEmptyLastInvoiceData(partyId, companyId);
      if(!isEmpty){

      }
      else{
        String token= await session.tokenExpired();
        String routeUrl="${ApiConstants.lastInvoiceAll}partyId=$partyId&companyId=$companyId";
        Response? response = await apiQuery.getQuery(routeUrl, token);

        if (response != null && response.statusCode == 200) {
          //var responseData = response.data;

          final data = response.data as List<dynamic>;
          final lastInvoicedetails = data.map((e) => MobileAppSalesInvoiceDetail.fromJson(e)).toList();
          await db.insertLastInvoiceData(lastInvoicedetails);
          return lastInvoicedetails;
        } else {
          throw Exception("Unexpected response format");
        }

      }
      
    }
    catch(ex){
      print(ex);
      throw ex;
    }
  }

}
