// // To parse this JSON data, do
// //
// //     final cashReceiptModel = cashReceiptModelFromJson(jsonString);
//
// import 'dart:convert';
//
// List<CashReceiptModel> cashReceiptModelFromJson(String str) => List<CashReceiptModel>.from(json.decode(str).map((x) => CashReceiptModel.fromJson(x)));
//
// String cashReceiptModelToJson(List<CashReceiptModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class CashReceiptModel {
//   int companyId;
//   String voucherNo;
//   String voucherDate;
//   int accountId;
//   String accountName;
//   int voucherTypeId;
//   String voucherTypeName;
//   int debit;
//   int credit;
//
//
//   CashReceiptModel({
//     required this.companyId,
//     required this.voucherNo,
//     required this.voucherDate,
//     required this.accountId,
//     required this.accountName,
//     required this.voucherTypeId,
//     required this.voucherTypeName,
//     required this.debit,
//     required this.credit,
//   });
//
//   CashReceiptModel copyWith({
//     int? companyId,
//     String? voucherNo,
//     String? voucherDate,
//     int? accountId,
//     String? accountName,
//     int? voucherTypeId,
//     String? voucherTypeName,
//     int? debit,
//     int? credit,
//   }) =>
//       CashReceiptModel(
//         companyId: companyId ?? this.companyId,
//         voucherNo: voucherNo ?? this.voucherNo,
//         voucherDate: voucherDate ?? this.voucherDate,
//         accountId: accountId ?? this.accountId,
//         accountName: accountName ?? this.accountName,
//         voucherTypeId: voucherTypeId ?? this.voucherTypeId,
//         voucherTypeName: voucherTypeName ?? this.voucherTypeName,
//         debit: debit ?? this.debit,
//         credit: credit ?? this.credit,
//       );
//
//   factory CashReceiptModel.fromJson(Map<String, dynamic> json) => CashReceiptModel(
//     companyId: json["companyId"],
//     voucherNo: json["voucherNo"],
//     voucherDate: json["voucherDate"],
//     accountId: json["accountId"],
//     accountName: json["accountName"],
//     voucherTypeId: json["voucherTypeId"],
//     voucherTypeName: json["voucherTypeName"],
//     debit: json["debit"],
//     credit: json["credit"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "companyId": companyId,
//     "voucherNo": voucherNo,
//     "voucherDate": voucherDate,
//     "accountId": accountId,
//     "accountName": accountName,
//     "voucherTypeId": voucherTypeId,
//     "voucherTypeName": voucherTypeName,
//     "debit": debit,
//     "credit": credit,
//   };
// }

// To parse this JSON data, do
//
//     final cashReceiptModel = cashReceiptModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<CashReceiptModel> cashReceiptModelFromJson(String str) => List<CashReceiptModel>.from(json.decode(str).map((x) => CashReceiptModel.fromJson(x)));

String cashReceiptModelToJson(List<CashReceiptModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CashReceiptModel {
  int companyId;
  int customerId;
  String customerName;
  String voucherNo;
  String voucherDate;
  String payMode;
  String voucherType;
  double paidAmount;
  String transactionYear;
  int userId;
  int vehicleId;
  int routeId;
  int driverId;

  CashReceiptModel({
    required this.companyId,
    required this.customerId,
    required this.customerName,
    required this.voucherNo,
    required this.voucherDate,
    required this.payMode,
    required this.voucherType,
    required this.paidAmount,
    required this.transactionYear,
    required this.userId,
    required this.vehicleId,
    required this.routeId,
    required this.driverId,
  });

  factory CashReceiptModel.fromJson(Map<String, dynamic> json) => CashReceiptModel(
    companyId: json["companyId"] ?? 0,
    customerId: json["customerId"] ?? 0,
    customerName: json["customerName"].toString() ?? "",
    voucherNo: json["voucherNo"].toString() ?? "",
    voucherDate: json["voucherDate"].toString() ?? "",
    payMode: json["payMode"].toString() ?? "",
    voucherType: json["voucherType"].toString() ?? "",
    paidAmount: (json["paidAmount"] is double)
        ? (json["paidAmount"] as double).toDouble()
        : (json["paidAmount"] as double? ?? 0.0),
    transactionYear: "0",//json["transactionYear"] ?? 0,
    userId: json["userId"] ?? 0,
    vehicleId: json["vehicleId"] ?? 0,
    routeId: json["routeId"] ?? 0,
    driverId: json["driverId"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "companyId": companyId,
    "customerId": customerId,
    "customerName": customerName,
    "voucherNo": voucherNo,
    "voucherDate": voucherDate,
    "payMode": payMode,
    "voucherType": voucherType,
    "paidAmount": paidAmount,
    "transactionYear": transactionYear,
    "userId": userId,
    "vehicleId": vehicleId,
    "routeId": routeId,
    "driverId": driverId,
  };
}
