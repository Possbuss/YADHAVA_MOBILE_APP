class RouteDetailsModel {
  final int sortOrder;
  final String routeDate;
  final String routeDay;
  final int customerId;
  final String customerName;
  final String contactPersonName;
  final int salesManId;
  final int companyId;
  final int routeId;
  final double? longitude;
  final double? latitude;


  RouteDetailsModel({
    required this.sortOrder,
    required this.routeDate,
    required this.routeDay,
    required this.customerId,
    required this.customerName,
    required this.contactPersonName,
    required this.salesManId,
    required this.companyId,
    required this.routeId,
    this.longitude,
    this.latitude,

  });

  factory RouteDetailsModel.fromJson(Map<String, dynamic> json) {
    return RouteDetailsModel(
      sortOrder: json['sortOrder'] ?? 0,
      routeDate: json['routeDate'] ?? "",
      routeDay: json['routeDay'] ?? "",
      customerId: json['customerId'] ?? 0,
      customerName: json['customerName'] ?? "",
      contactPersonName: json['contactPersonName'] ?? "",
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      routeId: json['routeId'] ?? 0,
      companyId: json['companyId'] ?? 0,
      salesManId: json['salesManId'] ?? 0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sortOrder": sortOrder,
      "routeDate": routeDate,
      "routeDay": routeDay,
      "customerId": customerId,
      "customerName": customerName,
      "contactPersonName": contactPersonName,
      "longitude": longitude,
      "latitude": latitude,
      "routeId":routeId,
      "companyId":companyId,
      "salesManId":salesManId
    };
  }

  static List<RouteDetailsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => RouteDetailsModel.fromJson(json)).toList();
  }
}
