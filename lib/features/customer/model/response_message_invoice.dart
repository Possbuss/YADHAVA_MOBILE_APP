import 'dart:convert';

import 'package:Yadhava/features/customer/data/client_model.dart';
import 'package:Yadhava/features/customer/model/last_invoice_model.dart';
import 'package:Yadhava/features/customer/model/mobile_app_sales_Invoice_all.dart';
import 'package:Yadhava/features/home/data/stockStsModel.dart';
import 'package:Yadhava/features/route/model/route_history_model.dart';
import 'package:Yadhava/features/route/presentation/pages/route_details/route_details.dart';

import '../../home/data/home_data.dart';
import '../../route/model/route_detailsModel.dart';

LastInvoiceModel lastInvoiceModelFromJson(String str) =>
    LastInvoiceModel.fromJson(json.decode(str));

String lastInvoiceModelToJson(LastInvoiceModel data) =>
    json.encode(data.toJson());

class ResponseMessageMobileSalesInvoice {
  final String message;
  final bool result;
  final String iDs;

  final MobileAppSalesInvoiceAll? mobileAppSalesInvoiceAll;
  final MobileAppSalesDashBoardHome? mobileAppSalesDashBoardHome;
  final List<ClientModel>? clientModel;
  final List<MobileAppSalesInvoiceDetail>? lastInvoiceModel;
  final List<RouteHistory>? routeHistory;
  final List<RouteDetailsModel>? routeDetails;

  ResponseMessageMobileSalesInvoice(
      {required this.message,
      required this.result,
      required this.iDs,
      required this.mobileAppSalesInvoiceAll,
      required this.mobileAppSalesDashBoardHome,
      required this.clientModel,
      required this.lastInvoiceModel,
      required this.routeHistory,
      required this.routeDetails});

  factory ResponseMessageMobileSalesInvoice.fromJson(
      Map<String, dynamic> json) {
    return ResponseMessageMobileSalesInvoice(
      message: (json["Message"] ?? json["message"] ?? "").toString(),
      result: json["Result"] ?? json["result"] ?? false,
      iDs: (json["IDs"] ?? json["iDs"] ?? json["ids"] ?? "").toString(),
      mobileAppSalesInvoiceAll: json["mobileAppSalesInvoiceAll"] != null
          ? MobileAppSalesInvoiceAll.fromJson(json["mobileAppSalesInvoiceAll"])
          : null,
      mobileAppSalesDashBoardHome: json["mobileAppSalesDashBoardHome"] != null
          ? MobileAppSalesDashBoardHome.fromJson(
              json["mobileAppSalesDashBoardHome"])
          : null,
      clientModel: (json["mobileAppClientsLists"] as List?)
              ?.map((x) => ClientModel.fromJson(x))
              .toList() ??
          [],
      lastInvoiceModel: (json["mobileAppLastSalesInvoiceDetails"] as List?)
              ?.map((x) => MobileAppSalesInvoiceDetail.fromJson(x))
              .toList() ??
          [],
      routeHistory: (json["mobileAppSalesRouteHistory"] as List?)
              ?.map((x) => RouteHistory.fromJson(x))
              .toList() ??
          [],
      routeDetails: ((json["mobileAppSalesRouteHistoryDetails"] ??
                  json["mobileAppSalesRouteHistoryDeatils"]) as List?)
              ?.map((x) => RouteDetailsModel.fromJson(x))
              .toList() ??
          [],
    );
  }
}
