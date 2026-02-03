class LogoutModel {
  final int userId;
  final int routeId;
  final int vehicleId;
  final String deviceId;
  final int companyId;

  LogoutModel({
    required this.userId,
    required this.routeId,
    required this.vehicleId,
    required this.deviceId,
    required this.companyId,
  });

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      userId: json['userId'],
      routeId: json['routeId'],
      vehicleId: json['vehicleId'],
      deviceId: json['deviceId'],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'routeId': routeId,
      'vehicleId': vehicleId,
      'deviceId': deviceId,
      'companyId': companyId,
    };
  }
}