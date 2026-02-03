// To parse this JSON data, do
//
//     final routeModel = routeModelFromJson(jsonString);

import 'dart:convert';

List<RouteModel> routeModelFromJson(String str) => List<RouteModel>.from(json.decode(str).map((x) => RouteModel.fromJson(x)));

String routeModelToJson(List<RouteModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RouteModel {
  final int masterId;
  final String masterName;
  final int masterTypeId;
  final String masterType;
  final String isActive;
  final int companyId;

  RouteModel({
    required this.masterId,
    required this.masterName,
    required this.masterTypeId,
    required this.masterType,
    required this.isActive,
    required this.companyId,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
    masterId: json["masterId"],
    masterName: json["masterName"],
    masterTypeId: json["masterTypeId"],
    masterType: json["masterType"],
    isActive: json["isActive"],
    companyId: json["companyId"],
  );

  Map<String, dynamic> toJson() => {
    "masterId": masterId,
    "masterName": masterName,
    "masterTypeId": masterTypeId,
    "masterType": masterType,
    "isActive": isActive,
    "companyId": companyId,
  };
}
