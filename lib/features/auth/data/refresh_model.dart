// To parse this JSON data, do
//
//     final refreshModel = refreshModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RefreshModel refreshModelFromJson(String str) => RefreshModel.fromJson(json.decode(str));

String refreshModelToJson(RefreshModel data) => json.encode(data.toJson());

class RefreshModel {
  String accessToken;
  String refreshToken;

  RefreshModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshModel.fromJson(Map<String, dynamic> json) => RefreshModel(
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
  };
}
