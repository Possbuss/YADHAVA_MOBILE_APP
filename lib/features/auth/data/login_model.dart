// // // To parse this JSON data, do
// // //
// // //     final loginModel = loginModelFromJson(jsonString);
// //
// // import 'dart:convert';
// //
// // List<LoginModel> loginModelFromJson(String str) => List<LoginModel>.from(json.decode(str).map((x) => LoginModel.fromJson(x)));
// //
// // String loginModelToJson(List<LoginModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
// //
// // class LoginModel {
// //   final int companyId;
// //   final String userName;
// //   final int userId;
// //   final int vehicleId;
// //   final int driverId;
// //   final String deviceId;
// //   final String signInDate;
// //   final dynamic signOutDate;
// //   final dynamic userPassword;
// //   final String loginMessage;
// //   final String userType;
// //   final String tokken;
// //   final String refreshToken;
// //   final int employeeId;
// //   final String employeeName;
// //   final int routeId;
// //   final String routeName;
// //
// //   LoginModel({
// //     required this.companyId,
// //     required this.userName,
// //     required this.userId,
// //     required this.vehicleId,
// //     required this.driverId,
// //     required this.deviceId,
// //     required this.signInDate,
// //     required this.signOutDate,
// //     required this.userPassword,
// //     required this.loginMessage,
// //     required this.userType,
// //     required this.tokken,
// //     required this.refreshToken,
// //     required this.employeeId,
// //     required this.employeeName,
// //     required this.routeId,
// //     required this.routeName
// //   });
// //
// //   factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
// //     companyId: json["companyId"],
// //     userName: json["userName"],
// //     userId: json["userId"],
// //     vehicleId: json["vehicleId"],
// //     driverId: json["driverId"],
// //     deviceId: json["deviceId"],
// //     signInDate: json["signInDate"],
// //     signOutDate: json["signOutDate"],
// //     userPassword: json["userPassword"],
// //     loginMessage: json["loginMessage"],
// //     userType: json["userType"],
// //     tokken: json["tokken"],
// //       refreshToken:json['refreshToken'],
// //     employeeId: json["employeeId"],
// //     employeeName: json["employeeName"],
// //     routeId: json["routeId"],
// //     routeName: json["routeName"]
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "companyId": companyId,
// //     "userName": userName,
// //     "userId": userId,
// //     "vehicleId": vehicleId,
// //     "driverId": driverId,
// //     "deviceId": deviceId,
// //     "signInDate": signInDate,
// //     "signOutDate": signOutDate,
// //     "userPassword": userPassword,
// //     "loginMessage": loginMessage,
// //     "userType": userType,
// //     "tokken": tokken,
// //     "refreshToken":refreshToken,
// //     "employeeId": employeeId,
// //     "employeeName": employeeName,
// //     "routeId":routeId,
// //     "routeName":routeName,
// //   };
// // }
//
//
// // To parse this JSON data, do
// //
// //     final loginModel = loginModelFromJson(jsonString);
//
// import 'package:meta/meta.dart';
// import 'dart:convert';
//
// List<LoginModel> loginModelFromJson(String str) => List<LoginModel>.from(json.decode(str).map((x) => LoginModel.fromJson(x)));
//
// String loginModelToJson(List<LoginModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class LoginModel {
//   int companyId;
//   String userName;
//   int userId;
//   int vehicleId;
//   int driverId;
//   String deviceId;
//   String signInDate;
//   dynamic signOutDate;
//   dynamic userPassword;
//   String loginMessage;
//   String userType;
//   String tokken;
//   String refreshToken;
//   int employeeId;
//   String employeeName;
//   int routeId;
//   String routeName;
//
//   LoginModel({
//     required this.companyId,
//     required this.userName,
//     required this.userId,
//     required this.vehicleId,
//     required this.driverId,
//     required this.deviceId,
//     required this.signInDate,
//     required this.signOutDate,
//     required this.userPassword,
//     required this.loginMessage,
//     required this.userType,
//     required this.tokken,
//     required this.refreshToken,
//     required this.employeeId,
//     required this.employeeName,
//     required this.routeId,
//     required this.routeName,
//   });
//
//   factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
//     companyId: json["companyId"],
//     userName: json["userName"],
//     userId: json["userId"],
//     vehicleId: json["vehicleId"],
//     driverId: json["driverId"],
//     deviceId: json["deviceId"],
//     signInDate: json["signInDate"],
//     signOutDate: json["signOutDate"],
//     userPassword: json["userPassword"],
//     loginMessage: json["loginMessage"],
//     userType: json["userType"],
//     tokken: json["tokken"],
//     refreshToken: json["refreshToken"],
//     employeeId: json["employeeId"],
//     employeeName: json["employeeName"],
//     routeId: json["routeId"],
//     routeName: json["routeName"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "companyId": companyId,
//     "userName": userName,
//     "userId": userId,
//     "vehicleId": vehicleId,
//     "driverId": driverId,
//     "deviceId": deviceId,
//     "signInDate": signInDate,
//     "signOutDate": signOutDate,
//     "userPassword": userPassword,
//     "loginMessage": loginMessage,
//     "userType": userType,
//     "tokken": tokken,
//     "refreshToken": refreshToken,
//     "employeeId": employeeId,
//     "employeeName": employeeName,
//     "routeId": routeId,
//     "routeName": routeName,
//   };
// }

// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

List<LoginModel> loginModelFromJson(String str) => List<LoginModel>.from(json.decode(str).map((x) => LoginModel.fromJson(x)));

String loginModelToJson(List<LoginModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginModel {
  int companyId;
  String userName;
  int userId;
  int vehicleId;
  int driverId;
  String deviceId;
  String signInDate;
  dynamic signOutDate;
  dynamic userPassword;
  String loginMessage;
  String userType;
  String tokken;
  String refreshToken;
  int employeeId;
  String employeeName;
  int routeId;
  String routeName;
  String vehicleName;

  LoginModel({
    required this.companyId,
    required this.userName,
    required this.userId,
    required this.vehicleId,
    required this.driverId,
    required this.deviceId,
    required this.signInDate,
    required this.signOutDate,
    required this.userPassword,
    required this.loginMessage,
    required this.userType,
    required this.tokken,
    required this.refreshToken,
    required this.employeeId,
    required this.employeeName,
    required this.routeId,
    required this.routeName,
    required this.vehicleName
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    companyId: json["companyId"],
    userName: json["userName"],
    userId: json["userId"],
    vehicleId: json["vehicleId"],
    driverId: json["driverId"],
    deviceId: json["deviceId"],
    signInDate: json["signInDate"],
    signOutDate: json["signOutDate"],
    userPassword: json["userPassword"],
    loginMessage: json["loginMessage"],
    userType: json["userType"],
    tokken: json["tokken"],
    refreshToken: json["refreshToken"],
    employeeId: json["employeeId"],
    employeeName: json["employeeName"],
    routeId: json["routeId"],
    routeName: json["routeName"],
    vehicleName: json["vehicleName"],
  );

  Map<String, dynamic> toJson() => {
    "companyId": companyId,
    "userName": userName,
    "userId": userId,
    "vehicleId": vehicleId,
    "driverId": driverId,
    "deviceId": deviceId,
    "signInDate": signInDate,
    "signOutDate": signOutDate,
    "userPassword": userPassword,
    "loginMessage": loginMessage,
    "userType": userType,
    "tokken": tokken,
    "refreshToken": refreshToken,
    "employeeId": employeeId,
    "employeeName": employeeName,
    "routeId": routeId,
    "routeName": routeName,
    "vehicleName": vehicleName,
  };
}
