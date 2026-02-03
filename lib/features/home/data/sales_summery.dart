// // To parse this JSON data, do
// //
// //     final salesSummery = salesSummeryFromJson(jsonString);
//
// import 'dart:convert';
//
// List<SalesSummery> salesSummeryFromJson(String str) {
//   final jsonData = json.decode(str);
//   return new List<SalesSummery>.from(jsonData.map((x) => SalesSummery.fromJson(x)));
// }
//
// String salesSummeryToJson(List<SalesSummery> data) {
//   final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
//   return json.encode(dyn);
// }
//
// class SalesSummery {
//   String routeDate;
//   String routeDay;
//   int salesManId;
//   SalesManName salesManName;
//   int routeId;
//   RouteName routeName;
//   int vehicleId;
//   VehicleName vehicleName;
//
//   SalesSummery({
//     required this.routeDate,
//     required this.routeDay,
//     required this.salesManId,
//     required this.salesManName,
//     required this.routeId,
//     required this.routeName,
//     required this.vehicleId,
//     required this.vehicleName,
//   });
//
//   factory SalesSummery.fromJson(Map<String, dynamic> json) => new SalesSummery(
//     routeDate: json["routeDate"],
//     routeDay: json["routeDay"],
//     salesManId: json["salesManId"],
//     salesManName: salesManNameValues.map[json["salesManName"]],
//     routeId: json["routeId"],
//     routeName: routeNameValues.map[json["routeName"]],
//     vehicleId: json["vehicleId"],
//     vehicleName: vehicleNameValues.map[json["vehicleName"]],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "routeDate": routeDate,
//     "routeDay": routeDay,
//     "salesManId": salesManId,
//     "salesManName": salesManNameValues.reverse[salesManName],
//     "routeId": routeId,
//     "routeName": routeNameValues.reverse[routeName],
//     "vehicleId": vehicleId,
//     "vehicleName": vehicleNameValues.reverse[vehicleName],
//   };
// }
//
// enum RouteName { KECHERI }
//
// final routeNameValues = new EnumValues({
//   "KECHERI": RouteName.KECHERI
// });
//
// enum SalesManName { JOBY, SANTHOSH, RICHARD }
//
// final salesManNameValues = new EnumValues({
//   "JOBY": SalesManName.JOBY,
//   "RICHARD": SalesManName.RICHARD,
//   "SANTHOSH": SalesManName.SANTHOSH
// });
//
// enum VehicleName { IRIS_7096, CARRY_3496 }
//
// final vehicleNameValues = new EnumValues({
//   "CARRY 3496": VehicleName.CARRY_3496,
//   "IRIS 7096": VehicleName.IRIS_7096
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap;
//   }
// }
class SalesSummery {
  final String invoiceNo;
  final String invoiceDate;
  final int customerAccountId;
  final String customerAccountName;
  final double totalAmount;
  final double discountAmount;
  final double netTotal;

  SalesSummery({
    required this.invoiceNo,
    required this.invoiceDate,
    required this.customerAccountId,
    required this.customerAccountName,
    required this.totalAmount,
    required this.discountAmount,
    required this.netTotal,
  });

  factory SalesSummery.fromJson(Map<String, dynamic> json) {
    return SalesSummery(
      invoiceNo: json['invoiceNo'] ?? '',
      invoiceDate: json['invoiceDate'] ?? '',
      customerAccountId: json['customerAccountId'] ?? 0,
      customerAccountName: json['customerAccountName'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      netTotal: (json['netTotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceNo': invoiceNo,
      'invoiceDate': invoiceDate,
      'customerAccountId': customerAccountId,
      'customerAccountName': customerAccountName,
      'totalAmount': totalAmount,
      'discountAmount': discountAmount,
      'netTotal': netTotal,
    };
  }
}
