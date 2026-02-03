class MobileAppSalesInvoiceAll{
  final List<MobileAppSalesInvoiceMaster>? mobileAppSalesInvoiceMaster;
  final List<MobileAppSalesInvoiceMasterDt>? mobileAppSalesInvoiceMasterDt;

  MobileAppSalesInvoiceAll({
    required this.mobileAppSalesInvoiceMaster,
    required this.mobileAppSalesInvoiceMasterDt,
});

  factory MobileAppSalesInvoiceAll.fromJson(Map<String, dynamic> json){
    return MobileAppSalesInvoiceAll(
      mobileAppSalesInvoiceMaster:
      (json["mobileAppSalesInvoiceMasters"] as List?)
          ?.map((x) => MobileAppSalesInvoiceMaster.fromJson(x))
          .toList() ??
          [],

      mobileAppSalesInvoiceMasterDt:
      (json["mobileAppSalesInvoiceMasterDt"] as List?)
          ?.map((x) => MobileAppSalesInvoiceMasterDt.fromJson(x))
          .toList() ??
          [],

    );
  }
}

class MobileAppSalesInvoiceMaster{

  final int invoiceId;
  final int companyId;
  final int routeId;
  final int branchId;
  final String branchName;
  final String invoiceNo;
  final String invoiceDate;
  final int salesManId;
  final String salesManName;
  final int clientId;
  final String clientName;
  final String mobile;
  final double totalAmount;
  final double totalDiscountVal;
  final double totalDiscountPer;
  final double totalTaxableAmount;
  final double totalSgstAmount;
  final double totalCgstAmount;
  final double totalCessAmount;
  final double totalIgstAmount;
  final double netTotal;
  final String payType;
  final String latitude;
  final String longitude;
  final String srtVoucherNo;
  final String receiptNo;
  double paidAmount;
  final String uuid;

  final List<MobileAppSalesInvoiceMasterDt> details;

  MobileAppSalesInvoiceMaster({
    required this.invoiceId,
    required this.companyId,
    required this.routeId,
    required this.branchId,
    required this.branchName,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.salesManId,
    required this.salesManName,
    required this.clientId,
    required this.clientName,
    required this.mobile,
    required this.totalAmount,
    required this.totalDiscountVal,
    required this.totalDiscountPer,
    required this.totalTaxableAmount,
    required this.totalSgstAmount,
    required this.totalCgstAmount,
    required this.totalCessAmount,
    required this.totalIgstAmount,
    required this.netTotal,
    required this.payType,
    required this.latitude,
    required this.longitude,
    required this.srtVoucherNo,
    required this.receiptNo,
    required this.paidAmount,
    required this.details,
    required this.uuid
  });

  factory MobileAppSalesInvoiceMaster.fromJson(Map<String, dynamic> json){
    return MobileAppSalesInvoiceMaster(
      companyId: json["companyId"] ?? 0,
      clientId: json["clientId"] ?? 0,
      salesManId: json["salesManId"] ?? 0,
      branchId: json["branchId"] ?? 0,
      branchName: json["branchName"] ?? '',
      clientName: json["clientName"] ?? '',
      invoiceDate: json["invoiceDate"] ?? '',
      invoiceId: json["invoiceId"] ?? 0,
      invoiceNo: json["invoiceNo"] ?? '',
      mobile: json["mobile"] ?? '',
      routeId: json["routeId"] ?? 0,
      salesManName: json["salesManName"] ?? '',
      latitude: json["latitude"] ?? '',
      longitude: json["longitude"] ?? '',
      netTotal: (json['netTotal'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      payType: json["payType"] ?? '',
      receiptNo: json["receiptNo"] ?? '',
      srtVoucherNo: json["srtVoucherNo"] ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      totalCessAmount: (json['totalCessAmount'] as num?)?.toDouble() ?? 0.0,
      totalCgstAmount: (json['totalCgstAmount'] as num?)?.toDouble() ?? 0.0,
      totalDiscountVal: (json['totalDiscountVal'] as num?)?.toDouble() ?? 0.0,
      totalDiscountPer: (json['totalDiscountPer'] as num?)?.toDouble() ?? 0.0,
      totalIgstAmount: (json['totalIgstAmount'] as num?)?.toDouble() ?? 0.0,
      totalSgstAmount: (json['totalSgstAmount'] as num?)?.toDouble() ?? 0.0,
      totalTaxableAmount: (json['totalTaxableAmount'] as num?)?.toDouble() ?? 0.0,
      uuid: json["uuid"] ?? '',
      details: (json['mobileAppSalesInvoiceMasterDt'] as List<dynamic>?)
          ?.map((e) => MobileAppSalesInvoiceMasterDt.fromJson(e))
          .toList() ??
          [],
      );



  }

  Map<String, dynamic> toJson() => {
    "companyId":companyId,
    "clientId":clientId,
    "salesManId": salesManId,
    "branchId":branchId,
    "branchName":branchName,
    "clientName":clientName,
    "invoiceDate":invoiceDate,
    "invoiceId":invoiceId,
    "invoiceNo":invoiceNo,
    "mobile":mobile,
    "routeId":routeId,
    "salesManName":salesManName,
    "latitude":latitude,
    "longitude":longitude,
    "netTotal":netTotal,
    "paidAmount":paidAmount,
    "payType":payType,
    "receiptNo":receiptNo,
    "srtVoucherNo":srtVoucherNo,
    "totalAmount":totalAmount,
    "totalCessAmount":totalCessAmount,
    "totalCgstAmount":totalCgstAmount,
    "totalDiscountVal":totalDiscountVal,
    "totalIgstAmount":totalIgstAmount,
    "totalSgstAmount":totalSgstAmount,
    "totalTaxableAmount":totalTaxableAmount,
    "uuid" : uuid
  };

  static List<MobileAppSalesInvoiceMaster> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MobileAppSalesInvoiceMaster.fromJson(json)).toList();
  }


  MobileAppSalesInvoiceMaster copyWith({
    int? companyId,
    int? invoiceId,
    int? clientId,
    String? clientName,
    int? driverId,
    String? driverName,
    String? payType,
    String? invoiceNo,
    String? invoiceDate,
    int? routeId,
    int? vehicleId,
    String? vehicleNo,
    double? netTotal,
    double? total,
    double? discountAmount,
    double? discountPercentage,
    double? paidAmount,

    List<MobileAppSalesInvoiceMasterDt>? details,
  }) {
    return MobileAppSalesInvoiceMaster(
      paidAmount: paidAmount??this.paidAmount,
      totalDiscountVal: discountAmount ?? this.totalDiscountVal,
      totalDiscountPer: discountPercentage ?? this.totalDiscountPer,
      companyId: companyId ?? this.companyId,
      invoiceId: invoiceId ?? this.invoiceId,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      salesManId: driverId ?? this.salesManId,
      salesManName: driverName ?? this.salesManName,
      payType: payType ?? this.payType,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      routeId: routeId ?? this.routeId,
      branchId: vehicleId ?? this.branchId,
      branchName: vehicleNo ?? this.branchName,
      netTotal: netTotal ?? this.netTotal,
      totalAmount: total ?? this.totalAmount,
      details: details ?? this.details,
      mobile: mobile,
      latitude: latitude,
      longitude: longitude,
      receiptNo: receiptNo,
      srtVoucherNo: srtVoucherNo,
      totalCessAmount: totalCessAmount,
      totalCgstAmount: totalCgstAmount,
      totalIgstAmount: totalIgstAmount,
      totalTaxableAmount: totalTaxableAmount,
      totalSgstAmount: totalSgstAmount,
      uuid: uuid
    );
  }
}

class MobileAppSalesInvoiceMasterDt{

  final int invoiceId;
  final int companyId;
  final int routeId;
  final int branchId;
  final String branchName;
  final String invoiceNo;
  final String invoiceDate;
  final int salesManId;
  final String salesManName;
  final int clientId;
  final String clientName;
  final String mobile;
  final int siNo;
  final int productId;
  final String partNumber;
  final String productName;
  final int packingId;
  final String packingName;
  final int packQty;
  final int packingOrder;
  final int packMultiplyQty;
  final double quantity;
  final double foc;
  final double srtQty;
  final double totalQty;
  final double unitRate;
  final double totalRate;
  final double netRate;

  MobileAppSalesInvoiceMasterDt({
    required this.invoiceId,
    required this.companyId,
    required this.routeId,
    required this.branchId,
    required this.branchName,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.salesManId,
    required this.salesManName,
    required this.clientId,
    required this.clientName,
    required this.mobile,
    required this.siNo,
    required this.productId,
    required this.partNumber,
    required this.productName,
    required this.packingId,
    required this.packingName,
    required this.packQty,
    required this.packingOrder,
    required this.packMultiplyQty,
    required this.quantity,
    required this.foc,
    required this.srtQty,
    required this.totalQty,
    required this.unitRate,
    required this.totalRate,
    required this.netRate,
  });

  factory MobileAppSalesInvoiceMasterDt.fromJson(Map<String, dynamic> json){
      return MobileAppSalesInvoiceMasterDt(
        companyId: json["companyId"] ?? 0,
        clientId: json["clientId"]  ?? 0,
        siNo: json["siNo"] ?? 0,
        packMultiplyQty: json["packMultiplyQty"] ?? 0,
        packingOrder: json["packingOrder"] ?? 0,
        salesManId: json["salesManId"]?? 0,
        branchId: json["branchId"]?? 0,
        branchName: json["branchName"]??'',
        clientName: json["clientName"]??'',
        foc: (json['foc'] as num?)?.toDouble() ?? 0.0,
        invoiceDate: json["invoiceDate"]?? '',
        invoiceId: json["invoiceId"] ??0,
        invoiceNo: json["invoiceNo"]?? '',
        mobile: json["mobile"]??'',
        netRate: (json['netRate'] as num?)?.toDouble() ?? 0.0,
        packingId: json["packingId"]?? 0,
        packingName: json["packingName"]??'',
        packQty: json["packQty"]?? 0,
        partNumber: json["partNumber"]??'',
        productId: json["productId"]?? 0,
        productName: json["productName"]??'',
        quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
        routeId: json["routeId"]?? 0,
        salesManName: json["salesManName"]??'',
        srtQty: (json['srtQty'] as num?)?.toDouble() ?? 0.0,
        totalQty: (json['totalQty'] as num?)?.toDouble() ?? 0.0,
        totalRate: (json['totalRate'] as num?)?.toDouble() ?? 0.0,
        unitRate: (json['unitRate'] as num?)?.toDouble() ?? 0.0,
      );
  }

  Map<String, dynamic> toJson() => {
    "companyId": companyId,
    "clientId": clientId,
    "siNo": siNo,
    "packMultiplyQty": packMultiplyQty,
    "packingOrder": packingOrder,
    "salesManId": salesManId,
    "branchId": branchId,
    "branchName": branchName,
    "clientName": clientName,
    "foc": foc,
    "invoiceDate": invoiceDate,
    "invoiceId": invoiceId,
    "invoiceNo": invoiceNo,
    "mobile":mobile,
    "netRate":netRate,
    "packingId":packingId,
    "packingName":packingName,
    "packQty":packQty,
    "partNumber":partNumber,
    "productId":productId,
    "productName":productName,
    "quantity":quantity,
    "routeId":routeId,
    "salesManName":salesManName,
    "srtQty":srtQty,
    "totalQty":totalQty,
    "totalRate":totalRate,
    "unitRate":unitRate,
  };

  static List<MobileAppSalesInvoiceMasterDt> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MobileAppSalesInvoiceMasterDt.fromJson(json)).toList();
  }


  MobileAppSalesInvoiceMasterDt copyWith({
    int? siNo,
    int? productId,
    String? partNumber,
    String? productName,
    String? packingDescription,
    int? packingId,
    String? packingName,
    double? quantity,
    double? foc,
    double? totalQty,
    double? unitRate,
    double? totalRate,
    double? srtQty
  }) {
    return MobileAppSalesInvoiceMasterDt(
        siNo: siNo ?? this.siNo,
        productId: productId ?? this.productId,
        partNumber: partNumber ?? this.partNumber,
        productName: productName ?? this.productName,
        packingId: packingId ?? this.packingId,
        packingName: packingName ?? this.packingName,
        quantity: quantity ?? this.quantity,
        foc: foc ?? this.foc,
        totalQty: totalQty ?? this.totalQty,
        unitRate: unitRate ?? this.unitRate,
        totalRate: totalRate ?? this.totalRate,
        srtQty: srtQty ?? this.srtQty,
        companyId: companyId,
        clientId: clientId,
      mobile: mobile,
      routeId: routeId,
      packMultiplyQty: packMultiplyQty,
      packingOrder: packingOrder,
      salesManId: salesManId,
      branchId: branchId,
      branchName: branchName,
      clientName: clientName,
      invoiceDate: invoiceDate,
      invoiceId: invoiceId,
      invoiceNo: invoiceNo,
      netRate: netRate,
      packQty: packQty,
      salesManName: salesManName

    );
  }

}