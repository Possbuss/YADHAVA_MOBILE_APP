class SalesInvoice {
  final int companyId;
  final int invoiceId;
  final int clientId;
  final String clientName;
  final int driverId;
  final String driverName;
  final String payType;
  final String invoiceNo;
  final String invoiceDate;
  final int routeId;
  final int vehicleId;
  final String vehicleNo;
  final double netTotal;
  final int transactionYear;
  final double? latitude;
  final double? longitude;
  final List<SalesInvoiceDetail> mobileAppSalesInvoiceDetails;

  SalesInvoice({
    required this.companyId,
    required this.invoiceId,
    required this.clientId,
    required this.clientName,
    required this.driverId,
    required this.driverName,
    required this.payType,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.routeId,
    required this.vehicleId,
    required this.vehicleNo,
    required this.netTotal,
    required this.transactionYear,
    this.latitude,
    this.longitude,
    required this.mobileAppSalesInvoiceDetails,
  });

  factory SalesInvoice.fromJson(Map<String, dynamic> json) {
    return SalesInvoice(
      companyId: json['companyId'],
      invoiceId: json['invoiceId'],
      clientId: json['clientId'],
      clientName: json['clientName'],
      driverId: json['driverId'],
      driverName: json['driverName'],
      payType: json['payType'],
      invoiceNo: json['invoiceNo'],
      invoiceDate: json['invoiceDate'],
      routeId: json['routeId'],
      vehicleId: json['vehicleId'],
      vehicleNo: json['vehicleNo'],
      netTotal: (json['netTotal'] as num).toDouble(),
      transactionYear: json['transactionYear'],
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      mobileAppSalesInvoiceDetails: (json['mobileAppSalesInvoiceDetails'] as List)
          .map((e) => SalesInvoiceDetail.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'invoiceId': invoiceId,
      'clientId': clientId,
      'clientName': clientName,
      'driverId': driverId,
      'driverName': driverName,
      'payType': payType,
      'invoiceNo': invoiceNo,
      'invoiceDate': invoiceDate,
      'routeId': routeId,
      'vehicleId': vehicleId,
      'vehicleNo': vehicleNo,
      'netTotal': netTotal,
      'transactionYear': transactionYear,
      'latitude': latitude,
      'longitude': longitude,
      'mobileAppSalesInvoiceDetails': mobileAppSalesInvoiceDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class SalesInvoiceDetail {
  final int siNo;
  final int productId;
  final String partNumber;
  final String productName;
  final String packingDescription;
  final int packingId;
  final String packingName;
  final double quantity;
  final double foc;
  final double srt;
  final double totalQty;
  final double unitRate;
  final double totalRate;

  SalesInvoiceDetail({
    required this.siNo,
    required this.productId,
    required this.partNumber,
    required this.productName,
    required this.packingDescription,
    required this.packingId,
    required this.packingName,
    required this.quantity,
    required this.foc,
    required this.srt,
    required this.totalQty,
    required this.unitRate,
    required this.totalRate,
  });

  factory SalesInvoiceDetail.fromJson(Map<String, dynamic> json) {
    return SalesInvoiceDetail(
      siNo: json['siNo'],
      productId: json['productId'],
      partNumber: json['partNumber'],
      productName: json['productName'],
      packingDescription: json['packingDescription'],
      packingId: json['packingId'],
      packingName: json['packingName'],
      quantity: (json['quantity'] as num).toDouble(),
      foc: (json['foc'] as num).toDouble(),
      srt: (json['srtQty'] as num).toDouble(),
      totalQty: (json['totalQty'] as num).toDouble(),
      unitRate: (json['unitRate'] as num).toDouble(),
      totalRate: (json['totalRate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'siNo': siNo,
      'productId': productId,
      'partNumber': partNumber,
      'productName': productName,
      'packingDescription': packingDescription,
      'packingId': packingId,
      'packingName': packingName,
      'quantity': quantity,
      'foc': foc,
      'srt': srt,
      'totalQty': totalQty,
      'unitRate': unitRate,
      'totalRate': totalRate,
};
}
}
