
class RouteHistory {
  final String routeDate;
  final String routeDay;
  final int salesManId;
  final String salesManName;
  final int routeId;
  final String routeName;
  final int vehicleId;
  final String vehicleName;
  final int companyId;

  RouteHistory({
    required this.routeDate,
    required this.routeDay,
    required this.salesManId,
    required this.salesManName,
    required this.routeId,
    required this.routeName,
    required this.vehicleId,
    required this.vehicleName,
    required this.companyId,
  });

  factory RouteHistory.fromJson(Map<String, dynamic> json) {
    return RouteHistory(
      routeDate: json['routeDate'],
      routeDay: json['routeDay'],
      salesManId: json['salesManId'],
      salesManName: json['salesManName'],
      routeId: json['routeId'],
      routeName: json['routeName'],
      vehicleId: json['vehicleId'],
      vehicleName: json['vehicleName'],
      companyId : json['companyId'],
    );
  }

  Map<String, dynamic> toJson() => {
    "routeDate": routeDate,
    "routeDay": routeDay,
    "salesManId": salesManId,
    "salesManName": salesManName,
    "routeId": routeId,
    "routeName": routeName,
    "vehicleId": vehicleId,
    "vehicleName": vehicleName,
    "companyId":companyId
  };
}