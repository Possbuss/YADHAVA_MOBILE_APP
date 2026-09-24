// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:posbuss_milk/core/constants/api_constants.dart';
// import 'package:posbuss_milk/features/customer/model/InvoiceModel.dart';
//
// import '../../../core/util/api_query.dart';
// import '../../../core/util/session.dart';
//
// class InvoiceRepository {
//   final ApiQuery apiQuery=ApiQuery();
//   Session session = Session();
//
//
//   /// Update Sales Invoice
//   Future<String> updateInvoice(MobileAppSalesInvoice invoice) async {
//     const url = '${ApiConstants.baseUrl}${ApiConstants.updateSalesInvoice}';
//
//     try {
//       String token = await session.tokenExpired();
//
//       final response = await apiQuery.postQuery(ApiConstants.updateSalesInvoice, token,  jsonEncode(_mapInvoiceToJson(invoice)) as Map<String, dynamic>);
//
//       // http.post(
//       //   Uri.parse(url),
//       //   headers: {'Content-Type': 'application/json'},
//       //   body: jsonEncode(_mapInvoiceToJson(invoice)),
//       // );
//
//       if (response!.statusCode == 200) {
//         return "Invoice updated successfully!";
//       } else {
//         final errorResponse = jsonDecode(response.data);
//         throw Exception(errorResponse['message'] ?? 'Failed to update invoice.');
//       }
//     } catch (error) {
//       throw Exception('Failed to update invoice: $error');
//     }
//   }
//
//   /// Convert MobileAppSalesInvoice to JSON
//   Map<String, dynamic> _mapInvoiceToJson(MobileAppSalesInvoice invoice) {
//     return {
//       "companyId": invoice.companyId,
//       "invoiceId": invoice.invoiceId,
//       "clientId": invoice.clientId,
//       "clientName": invoice.clientName,
//       "driverId": invoice.driverId,
//       "driverName": invoice.driverName,
//       "payType": invoice.payType,
//       "invoiceNo": invoice.invoiceNo,
//       "invoiceDate": invoice.invoiceDate,
//       "routeId": invoice.routeId,
//       "vehicleId": invoice.vehicleId,
//       "vehicleNo": invoice.vehicleNo,
//       "netTotal": invoice.netTotal,
//       "transactionYear": DateTime.now().year,
//       "latitude": 0,
//       "longitude": 0,
//       "mobileAppSalesInvoiceDetails": invoice.details.map((detail) {
//         return {
//           "siNo": detail.siNo,
//           "productId": detail.productId,
//           "partNumber": detail.partNumber,
//           "productName": detail.productName,
//           "packingDescription": detail.packingDescription,
//           "packingId": detail.packingId,
//           "packingName": detail.packingName,
//           "quantity": detail.quantity,
//           "foc": detail.foc,
//           "totalQty": detail.totalQty,
//           "unitRate": detail.unitRate,
//           "totalRate": detail.totalRate,
//         };
//       }).toList(),
//     };
//   }
// }

import 'dart:developer';

import 'package:Yadhava/features/customer/model/mobile_app_sales_Invoice_all.dart';
import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/local_db_helper.dart';
import '../../../core/util/session.dart';
import '../model/response_message_invoice.dart';

class InvoiceRepository {
  final ApiQuery apiQuery = ApiQuery();
  final Session session = Session();

  double _round4(double value) =>
      value.isFinite ? double.parse(value.toStringAsFixed(4)) : 0.0;

  Future<bool?> updateInvoice(MobileAppSalesInvoiceMaster invoice) async {
    try {
      String token = await session.tokenExpired();
      final Map<String, dynamic> data = _mapInvoiceToJson(invoice);
      final Response? response = await apiQuery.postQueryWithTimeout(
        ApiConstants.updateSalesInvoice,
        token,
        data,
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      );

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final responseData = response.data;
        if (responseData is! Map<String, dynamic>) {
          throw Exception('The update API returned an invalid response.');
        }
        final bool isUpdated =
            responseData['result'] == true || responseData['Result'] == true;
        log(isUpdated.toString());

        if (!isUpdated) {
          final String message = (responseData['message'] ??
                  responseData['Message'] ??
                  'The server did not update the invoice.')
              .toString();
          throw Exception(message);
        }

        var responseMessageMobileSalesInvoice =
            ResponseMessageMobileSalesInvoice.fromJson(response.data);

        if (responseMessageMobileSalesInvoice.result) {
          var db = LocalDbHelper();
          final invoiceData =
              responseMessageMobileSalesInvoice.mobileAppSalesInvoiceAll;
          final dashboardData =
              responseMessageMobileSalesInvoice.mobileAppSalesDashBoardHome;

          if (invoiceData?.mobileAppSalesInvoiceMaster?.isNotEmpty ?? false) {
            await db.clearInvoiceTablesByInvoiceNo(
                invoice.invoiceNo, invoice.companyId);

            await db.insertInvoices(invoiceData!.mobileAppSalesInvoiceMaster,
                invoiceData.mobileAppSalesInvoiceMasterDt);
          }

          if (dashboardData != null) {
            await db.clearTransactions();
            await db.insertTransactions(dashboardData.mobileAppSalesDashBoard);

            await db.clearProductStocks();
            await db
                .insertProductStocks(dashboardData.mobileAppStockBalanceVans);

            await db.clearSalesSummary();
            await db.insertSalesSummary(dashboardData.mobileAppSales);

            await db.clearCreditSummary();
            await db.insertCreditSummary(dashboardData.mobileAppSalesCredit);

            await db.clearCashSummary();
            await db.insertCashSummary(dashboardData.mobileAppSalesCash);

            await db.clearCashCreditDetails();
            await db.insertCashCreditDetails(
                dashboardData.salesInvoiceCollectionCreditCashCustomerImports);
          }

          await db.updateClients(
              responseMessageMobileSalesInvoice.clientModel, invoice.clientId);
          await db.updateLastInvoiceData(
              responseMessageMobileSalesInvoice.lastInvoiceModel,
              invoice.clientId,
              invoice.companyId);
          await db.updateRouteHistory(
              responseMessageMobileSalesInvoice.routeHistory,
              invoice.routeId,
              invoice.companyId);
          await db.updateRouteHistoryDetails(
              responseMessageMobileSalesInvoice.routeDetails,
              invoice.invoiceDate,
              invoice.routeId,
              invoice.companyId);
        }

        return true;
      } else if (response != null) {
        throw Exception('Failed with status: ${response.statusCode}');
      } else {
        throw Exception('No response received from the server.');
      }
    } catch (error) {
      if (error is DioException &&
          error.type == DioExceptionType.receiveTimeout) {
        throw Exception(
            'The server is taking too long to update this invoice. Please try again.');
      }
      throw Exception('Failed to update invoice: $error');
    }
  }

  Map<String, dynamic> _mapInvoiceToJson(MobileAppSalesInvoiceMaster invoice) {
    return {
      "CompanyId": invoice.companyId,
      "InvoiceId": invoice.invoiceId,
      "ClientId": invoice.clientId,
      "ClientName": invoice.clientName,
      "DriverId": invoice.salesManId,
      "DriverName": invoice.salesManName,
      "PayType": invoice.payType,
      "InvoiceNo": invoice.invoiceNo,
      "InvoiceDate": invoice.invoiceDate,
      "RouteId": invoice.routeId,
      "VehicleId": invoice.branchId,
      "VehicleNo": invoice.branchName,
      "Total": _round4(invoice.totalAmount),
      "DiscountPercentage": _round4(invoice.totalDiscountPer),
      "DiscountAmount": _round4(invoice.totalDiscountVal),
      "TotalTaxableAmount": _round4(invoice.totalTaxableAmount),
      "TotalCgstAmount": _round4(invoice.totalCgstAmount),
      "TotalSgstAmount": _round4(invoice.totalSgstAmount),
      "TotalIgstAmount": _round4(invoice.totalIgstAmount),
      "TotalCessAmount": _round4(invoice.totalCessAmount),
      "RoundOf": _round4(invoice.roundOf),
      "NetTotal": _round4(invoice.netTotal),
      "PaidAmount": _round4(invoice.paidAmount),
      "ReceiptNo": invoice.receiptNo,
      "IsGstBill": invoice.invoiceType == 'TAX_INVOICE' ? 'Y' : 'N',
      "InvoiceType": invoice.invoiceType == 'TAX_INVOICE'
          ? 'Tax Invoice'
          : 'Sales Invoice',
      "TransactionYear": DateTime.now().year,
      "Latitude": 0,
      "Longitude": 0,
      "uuid": invoice.uuid,
      "mobileAppSalesInvoiceDetails": invoice.details.map((detail) {
        return {
          "SiNo": detail.siNo,
          "ProductId": detail.productId,
          "PartNumber": detail.partNumber,
          "ProductName": detail.productName,
          "PackingDescription": detail.productName,
          "PackingId": detail.packingId,
          "PackingName": detail.packingName,
          "Quantity": _round4(detail.quantity),
          "Foc": _round4(detail.foc),
          "TotalQty": _round4(detail.totalQty),
          "SrtQty": _round4(detail.srtQty),
          "UnitRate": _round4(detail.unitRate),
          "TotalRate": _round4(detail.totalRate),
          "TaxPercentage": _round4(detail.gstPercentage),
          "TaxableRate": _round4(detail.taxableAmount),
          "IgstPercentage": _round4(detail.igstPercentage),
          "IgstAmount": _round4(detail.igstAmount),
          "CgstPercentage": _round4(detail.cgstPercentage),
          "CgstAmount": _round4(detail.cgstAmount),
          "SgstPercentage": _round4(detail.sgstPercentage),
          "SgstAmount": _round4(detail.sgstAmount),
          "CessPercentage": _round4(detail.cessPercentage),
          "CessAmount": _round4(detail.cessAmount),
          "NetRate": _round4(detail.netAmount),
          "CompanyId": detail.companyId,
          "ClientId": detail.clientId,
          "InvoiceId": detail.invoiceId,
        };
      }).toList(),
    };
  }
}
