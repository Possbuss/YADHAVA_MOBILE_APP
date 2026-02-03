
import 'dart:convert';
import 'package:Yadhava/features/customer/data/client_model.dart';
import '../../home/data/home_data.dart';
import 'cash_receipt_model.dart';

class ResponseMessageReceiptsPayments {
  final String message;
  final bool result;
  final String iDs;

  final MobileAppSalesDashBoardHome? mobileAppSalesDashBoardHome;
  final List<ClientModel>? clientModel;
  final List<CashReceiptModel>? cashReceipts;

  ResponseMessageReceiptsPayments({
    required this.message,
    required this.result,
    required this.iDs,

    required this.mobileAppSalesDashBoardHome,
    required this.clientModel,
    required this.cashReceipts
  });

  factory ResponseMessageReceiptsPayments.fromJson(Map<String, dynamic> json) {


    return ResponseMessageReceiptsPayments(
      message: json["message"] ?? "",
      result: json["result"] ?? false,
      iDs: json["iDs"] ?? "",
      mobileAppSalesDashBoardHome: json["mobileAppSalesDashBoardHome"] != null ?
      MobileAppSalesDashBoardHome.fromJson(json["mobileAppSalesDashBoardHome"])
          : null,


      clientModel:
      (json["mobileAppClientsLists"] as List?)
          ?.map((x) => ClientModel.fromJson(x))
          .toList() ??
          [],

      cashReceipts:
      (json["accountVoucherTransactionsDetailsRequestMobileApps"] as List?)
          ?.map((x) => CashReceiptModel.fromJson(x))
          .toList() ??
          [],
    );
  }
}


