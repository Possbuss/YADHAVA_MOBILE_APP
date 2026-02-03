class ClientModel {
  final int?companyId;
  final int? id;
  final String? name;
  final String? contactPersonName;
  final int? routeId;
  final String? routeName;
  final double? amount;
  final String? mobile;
  final int?  salesmanId;
  final String? salesmanName;
  final double? latitude;
  final double? longitude;
  final int? transactionYear;
  final int? clientSortOrder;
  final String? isActive;
  final String? createdDate;

  ClientModel({
     this.companyId,
     this.id,
     this.name,
     this.contactPersonName,
     this.routeId,
     this.routeName,
     this.amount,
     this.salesmanId,
     this.salesmanName,
     this.mobile,
    this.latitude,
    this.longitude,
    this.transactionYear,
    this.clientSortOrder,
    this.isActive,
    this.createdDate
  });

  // Factory method to create a Client from JSON
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      companyId: json['companyId'],
      id: json['id'],
      name: json['name']??"",
      contactPersonName: json['contactPersonName']??"",
      routeId: json['routeId'],
      routeName: json['routeName']??"",
      amount: (json['amount'] as num).toDouble()??0,
      mobile: json['mobile'] ?? "",
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
        clientSortOrder : json['clientSortOrder'],
      transactionYear: json['transactionYear'] ?? 0,
        salesmanId: json['salesmanId'],
        salesmanName: json['salesmanName'],
        isActive: json['isActive'],
        createdDate: json['createdDate']
    );
  }

  // Method to convert a Client instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'companyId':companyId,
      'id': id,
      'name': name,
      'contactPersonName': contactPersonName,
      'routeId': routeId,
      'routeName': routeName,
      'amount': amount,
      'mobile': mobile,
      'salesmanId':salesmanId,
      'salesmanName':salesmanName,
      'latitude': latitude,
      'longitude': longitude,
      'transactionYear':transactionYear,
      'clientSortOrder':clientSortOrder,
      'isActive':isActive,
      'createdDate':createdDate
    };
  }
}



class ClientRequestModel {
  final int?companyId;
  final int? clientId;
  final int? routeId;
  final String? dateTime;

  ClientRequestModel({
    this.routeId,
    this.clientId,
    this.companyId,
    this.dateTime
  });

  // Factory method to create a Client from JSON
  factory ClientRequestModel.fromJson(Map<String, dynamic> json) {
    return ClientRequestModel(
        companyId: json['companyId'],
        clientId: json['clientId'],
        routeId: json['routeId'],
        dateTime: json['dateTime']
    );
  }

  // Method to convert a Client instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'companyId':companyId,
      'clientId': clientId,
      'routeId': routeId,
      'dateTime':dateTime
    };
  }
}
