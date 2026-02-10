class ClientActiveInActiveModel {

  final int? clientId;
  final String? clientName;
  final int? routeId;
  final String? invoiceDate;
  final String? clientType;

  ClientActiveInActiveModel({
    this.clientId,
    this.clientName,
    this.routeId,
    this.invoiceDate,
    this.clientType,
  });

  // Factory method to create a Client from JSON
  factory ClientActiveInActiveModel.fromJson(Map<String, dynamic> json) {
    return ClientActiveInActiveModel(
        clientId: json['clientId'],
        clientName: json['clientName'],
        routeId: json['routeId']??"",
        invoiceDate: json['invoiceDate']??"",
        clientType: json['clientType']??"",
    );
  }

  // Method to convert a Client instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'clientId':clientId,
      'clientName': clientName,
      'routeId': routeId,
      'invoiceDate': invoiceDate,
      'clientType':clientType
    };
  }
}
