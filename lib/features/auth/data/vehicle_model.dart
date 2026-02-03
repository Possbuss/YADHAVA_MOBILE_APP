// To parse this JSON data, do
//
//     final vehicleModel = vehicleModelFromJson(jsonString);

import 'dart:convert';

List<VehicleModel> vehicleModelFromJson(String str) => List<VehicleModel>.from(json.decode(str).map((x) => VehicleModel.fromJson(x)));

String vehicleModelToJson(List<VehicleModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleModel {
  final int branchId;
  final String branchName;
  final int companyId;
  final String locationType;
  final String isActive;

  VehicleModel({
    required this.branchId,
    required this.branchName,
    required this.companyId,
    required this.locationType,
    required this.isActive,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) => VehicleModel(
    branchId: json["branchId"],
    branchName: json["branchName"],
    companyId: json["companyId"],
    locationType: json["locationType"],
    isActive: json["isActive"],
  );

  Map<String, dynamic> toJson() => {
    "branchId": branchId,
    "branchName": branchName,
    "companyId": companyId,
    "locationType": locationType,
    "isActive": isActive,
  };
}
