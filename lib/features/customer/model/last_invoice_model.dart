// // To parse this JSON data, do
// //
// //     final lastInvoiceModel = lastInvoiceModelFromJson(jsonString);
//
// import 'package:meta/meta.dart';
// import 'dart:convert';
//
// LastInvoiceModel lastInvoiceModelFromJson(String str) => LastInvoiceModel.fromJson(json.decode(str));
//
// String lastInvoiceModelToJson(LastInvoiceModel data) => json.encode(data.toJson());
//
// class LastInvoiceModel {
//   int companyId;
//   int invoiceId;
//   int clientId;
//   String clientName;
//   int driverId;
//   String driverName;
//   String payType;
//   String invoiceNo;
//   String invoiceDate;
//   int routeId;
//   int vehicleId;
//   String vehicleNo;
//   double total;
//   int discountPercentage;
//   int discountAmount;
//   int netTotal;
//   int paidAmount;
//   dynamic receiptNo;
//   int transactionYear;
//   double latitude;
//   double longitude;
//   List<MobileAppSalesInvoiceDetail> mobileAppSalesInvoiceDetails;
//
//   LastInvoiceModel({
//     required this.companyId,
//     required this.invoiceId,
//     required this.clientId,
//     required this.clientName,
//     required this.driverId,
//     required this.driverName,
//     required this.payType,
//     required this.invoiceNo,
//     required this.invoiceDate,
//     required this.routeId,
//     required this.vehicleId,
//     required this.vehicleNo,
//     required this.total,
//     required this.discountPercentage,
//     required this.discountAmount,
//     required this.netTotal,
//     required this.paidAmount,
//     required this.receiptNo,
//     required this.transactionYear,
//     required this.latitude,
//     required this.longitude,
//     required this.mobileAppSalesInvoiceDetails,
//   });
//
//   factory LastInvoiceModel.fromJson(Map<String, dynamic> json) => LastInvoiceModel(
//     companyId: json["companyId"],
//     invoiceId: json["invoiceId"],
//     clientId: json["clientId"],
//     clientName: json["clientName"],
//     driverId: json["driverId"],
//     driverName: json["driverName"],
//     payType: json["payType"],
//     invoiceNo: json["invoiceNo"],
//     invoiceDate: json["invoiceDate"],
//     routeId: json["routeId"],
//     vehicleId: json["vehicleId"],
//     vehicleNo: json["vehicleNo"],
//     total: json["total"],
//     discountPercentage: json["discountPercentage"],
//     discountAmount: json["discountAmount"],
//     netTotal: json["netTotal"],
//     paidAmount: json["paidAmount"],
//     receiptNo: json["receiptNo"],
//     transactionYear: json["transactionYear"],
//     latitude: json["latitude"]?.toDouble(),
//     longitude: json["longitude"]?.toDouble(),
//     mobileAppSalesInvoiceDetails: List<MobileAppSalesInvoiceDetail>.from(json["mobileAppSalesInvoiceDetails"].map((x) => MobileAppSalesInvoiceDetail.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "companyId": companyId,
//     "invoiceId": invoiceId,
//     "clientId": clientId,
//     "clientName": clientName,
//     "driverId": driverId,
//     "driverName": driverName,
//     "payType": payType,
//     "invoiceNo": invoiceNo,
//     "invoiceDate": invoiceDate,
//     "routeId": routeId,
//     "vehicleId": vehicleId,
//     "vehicleNo": vehicleNo,
//     "total": total,
//     "discountPercentage": discountPercentage,
//     "discountAmount": discountAmount,
//     "netTotal": netTotal,
//     "paidAmount": paidAmount,
//     "receiptNo": receiptNo,
//     "transactionYear": transactionYear,
//     "latitude": latitude,
//     "longitude": longitude,
//     "mobileAppSalesInvoiceDetails": List<dynamic>.from(mobileAppSalesInvoiceDetails.map((x) => x.toJson())),
//   };
// }
//
// class MobileAppSalesInvoiceDetail {
//   int siNo;
//   int productId;
//   String partNumber;
//   String productName;
//   String packingDescription;
//   int packingId;
//   String packingName;
//   int quantity;
//   int foc;
//   int totalQty;
//   int srtQty;
//   int unitRate;
//   int totalRate;
//
//   MobileAppSalesInvoiceDetail({
//     required this.siNo,
//     required this.productId,
//     required this.partNumber,
//     required this.productName,
//     required this.packingDescription,
//     required this.packingId,
//     required this.packingName,
//     required this.quantity,
//     required this.foc,
//     required this.totalQty,
//     required this.srtQty,
//     required this.unitRate,
//     required this.totalRate,
//   });
//
//   factory MobileAppSalesInvoiceDetail.fromJson(Map<String, dynamic> json) => MobileAppSalesInvoiceDetail(
//     siNo: json["siNo"],
//     productId: json["productId"],
//     partNumber: json["partNumber"],
//     productName: json["productName"],
//     packingDescription: json["packingDescription"],
//     packingId: json["packingId"],
//     packingName: json["packingName"],
//     quantity: json["quantity"],
//     foc: json["foc"],
//     totalQty: json["totalQty"],
//     srtQty: json["srtQty"],
//     unitRate: json["unitRate"],
//     totalRate: json["totalRate"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "siNo": siNo,
//     "productId": productId,
//     "partNumber": partNumber,
//     "productName": productName,
//     "packingDescription": packingDescription,
//     "packingId": packingId,
//     "packingName": packingName,
//     "quantity": quantity,
//     "foc": foc,
//     "totalQty": totalQty,
//     "srtQty": srtQty,
//     "unitRate": unitRate,
//     "totalRate": totalRate,
//   };
// }
// To parse this JSON data, do
//
//     final lastInvoiceModel = lastInvoiceModelFromJson(jsonString);
import 'dart:convert';

LastInvoiceModel lastInvoiceModelFromJson(String str) =>
    LastInvoiceModel.fromJson(json.decode(str));

String lastInvoiceModelToJson(LastInvoiceModel data) =>
    json.encode(data.toJson());

class LastInvoiceModel {
  final int companyId;
  final int invoiceId;
  final int clientId;
  final String clientName;
  final int driverId;
  final String driverName;
  final String payType;
  final String invoiceNo;
  final String invoiceDate;
  final int routeId;
  final int vehicleId;
  final String vehicleNo;
  final double total;
  final double discountPercentage;
  final double discountAmount;
  final double netTotal;
  final double paidAmount;
  final dynamic receiptNo;
  final int transactionYear;
  final double latitude;
  final double longitude;
  final List<MobileAppSalesInvoiceDetail>? mobileAppSalesInvoiceDetails;

  LastInvoiceModel({
    required this.companyId,
    required this.invoiceId,
    required this.clientId,
    required this.clientName,
    required this.driverId,
    required this.driverName,
    required this.payType,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.routeId,
    required this.vehicleId,
    required this.vehicleNo,
    required this.total,
    required this.discountPercentage,
    required this.discountAmount,
    required this.netTotal,
    required this.paidAmount,
    required this.receiptNo,
    required this.transactionYear,
    required this.latitude,
    required this.longitude,
    required this.mobileAppSalesInvoiceDetails,
  });

  factory LastInvoiceModel.fromJson(Map<String, dynamic> json) {
    return LastInvoiceModel(
      companyId: json["companyId"],
      invoiceId: json["invoiceId"],
      clientId: json["clientId"],
      clientName: json["clientName"],
      driverId: json["driverId"],
      driverName: json["driverName"],
      payType: json["payType"],
      invoiceNo: json["invoiceNo"],
      invoiceDate: json["invoiceDate"],
      routeId: json["routeId"],
      vehicleId: json["vehicleId"],
      vehicleNo: json["vehicleNo"],
      total: (json["total"] ?? 0).toDouble(),
      discountPercentage: json["discountPercentage"] ?? 0,
      discountAmount: (json["discountAmount"] ?? 0).toDouble(),
      netTotal: (json["netTotal"] ?? 0).toDouble(),
      paidAmount: (json["paidAmount"] ?? 0).toDouble(),
      receiptNo: json["receiptNo"],
      transactionYear: json["transactionYear"],
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
      mobileAppSalesInvoiceDetails:
          (json["mobileAppSalesInvoiceDetails"] as List?)
                  ?.map((x) => MobileAppSalesInvoiceDetail.fromJson(x))
                  .toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() => {
        "companyId": companyId,
        "invoiceId": invoiceId,
        "clientId": clientId,
        "clientName": clientName,
        "driverId": driverId,
        "driverName": driverName,
        "payType": payType,
        "invoiceNo": invoiceNo,
        "invoiceDate": invoiceDate,
        "routeId": routeId,
        "vehicleId": vehicleId,
        "vehicleNo": vehicleNo,
        "total": total,
        "discountPercentage": discountPercentage,
        "discountAmount": discountAmount,
        "netTotal": netTotal,
        "paidAmount": paidAmount,
        "receiptNo": receiptNo,
        "transactionYear": transactionYear,
        "latitude": latitude,
        "longitude": longitude,
        "mobileAppSalesInvoiceDetails":
            mobileAppSalesInvoiceDetails?.map((x) => x.toJson()).toList(),
      };
}

class MobileAppSalesInvoiceDetail {
  final int siNo;
  final int productId;
  final int companyId;
  final int clientId;
  final String? partNumber;
  final String? productName;
  final String? packingDescription;
  final int packingId;
  final String? packingName;
  final double? quantity;
  final double? foc;
  final double? totalQty;
  final double? srtQty;
  final double? unitRate;
  final double? totalRate;


  MobileAppSalesInvoiceDetail({
    required this.siNo,
    required this.productId,
    required this.companyId,
    required this.clientId,
    required this.partNumber,
    required this.productName,
    required this.packingDescription,
    required this.packingId,
    required this.packingName,
    required this.quantity,
    required this.foc,
    required this.totalQty,
    required this.srtQty,
    required this.unitRate,
    required this.totalRate,
  });

  factory MobileAppSalesInvoiceDetail.fromJson(Map<String, dynamic> json) {
    return MobileAppSalesInvoiceDetail(
      siNo: json["siNo"],
      productId: json["productId"],
      partNumber: json["partNumber"],
      productName: json["productName"],
      packingDescription: json["packingDescription"],
      packingId: json["packingId"],
      packingName: json["packingName"],
      quantity: json["quantity"],
      foc: json["foc"],
      totalQty: json["totalQty"],
      srtQty: json["srtQty"],
      unitRate: json["unitRate"],
      totalRate: json["totalRate"],
      companyId: json["companyId"],
      clientId: json["clientId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "siNo": siNo,
        "productId": productId,
        "partNumber": partNumber,
        "productName": productName,
        "packingDescription": packingDescription,
        "packingId": packingId,
        "packingName": packingName,
        "quantity": quantity,
        "foc": foc,
        "totalQty": totalQty,
        "srtQty": srtQty,
        "unitRate": unitRate,
        "totalRate": totalRate,
        "companyId":companyId,
        "clientId":clientId
      };

  static List<MobileAppSalesInvoiceDetail> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MobileAppSalesInvoiceDetail.fromJson(json)).toList();
  }
}
