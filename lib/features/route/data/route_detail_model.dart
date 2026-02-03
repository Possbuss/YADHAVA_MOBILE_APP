// // To parse this JSON data, do
// //
// //     final routeDetailsModel = routeDetailsModelFromJson(jsonString);
//
// import 'package:meta/meta.dart';
// import 'dart:convert';
//
// List<RouteDetailsModel> routeDetailsModelFromJson(String str) => List<RouteDetailsModel>.from(json.decode(str).map((x) => RouteDetailsModel.fromJson(x)));
//
// String routeDetailsModelToJson(List<RouteDetailsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class RouteDetailsModel {
//   int sortOrder;
//   String routeDate;
//   String routeDay;
//   int customerId;
//   String customerName;
//   String contactPersonName;
//   dynamic longitude;
//   dynamic latitude;
//
//   RouteDetailsModel({
//     required this.sortOrder,
//     required this.routeDate,
//     required this.routeDay,
//     required this.customerId,
//     required this.customerName,
//     required this.contactPersonName,
//     required this.longitude,
//     required this.latitude,
//   });
//
//   factory RouteDetailsModel.fromJson(Map<String, dynamic> json) => RouteDetailsModel(
//     sortOrder: json["sortOrder"],
//     routeDate: json["routeDate"],
//     routeDay: json["routeDay"],
//     customerId: json["customerId"],
//     customerName: json["customerName"],
//     contactPersonName: json["contactPersonName"],
//     longitude: json["longitude"],
//     latitude: json["latitude"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "sortOrder": sortOrder,
//     "routeDate": routeDate,
//     "routeDay": routeDay,
//     "customerId": customerId,
//     "customerName": customerName,
//     "contactPersonName": contactPersonName,
//     "longitude": longitude,
//     "latitude": latitude,
//   };
// }
