class MobileAppSalesInvoiceAll {
  final List<MobileAppSalesInvoiceMaster>? mobileAppSalesInvoiceMaster;
  final List<MobileAppSalesInvoiceMasterDt>? mobileAppSalesInvoiceMasterDt;

  MobileAppSalesInvoiceAll({
    required this.mobileAppSalesInvoiceMaster,
    required this.mobileAppSalesInvoiceMasterDt,
  });

  factory MobileAppSalesInvoiceAll.fromJson(Map<String, dynamic> json) {
    final List<dynamic> masterRows = (json["mobileAppSalesInvoiceMasters"] ??
        json["mobileAppSalesInvoiceMaster"] ??
        json["mobileAppSalesInvoices"] ??
        []) as List<dynamic>;
    final List<dynamic> detailRows = (json["mobileAppSalesInvoiceMasterDt"] ??
        json["mobileAppSalesInvoiceDetails"] ??
        json["mobileAppSalesInvoiceMasterDetails"] ??
        []) as List<dynamic>;

    return MobileAppSalesInvoiceAll(
      mobileAppSalesInvoiceMaster: masterRows
          .map((x) => MobileAppSalesInvoiceMaster.fromJson(x))
          .toList(),
      mobileAppSalesInvoiceMasterDt: detailRows
          .map((x) => MobileAppSalesInvoiceMasterDt.fromJson(x))
          .toList(),
    );
  }
}

class MobileAppSalesInvoiceMaster {
  final int invoiceId;
  final int companyId;
  final int routeId;
  final int branchId;
  final String branchName;
  final String invoiceType;
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
  final double roundOf;
  final double netTotal;
  final String payType;
  final String latitude;
  final String longitude;
  final String srtVoucherNo;
  final String receiptNo;
  double paidAmount;
  final String uuid;

  final List<MobileAppSalesInvoiceMasterDt> details;

  static String _normalizeInvoiceType(dynamic invoiceType, dynamic isGstBill) {
    final String normalizedInvoiceType =
        (invoiceType ?? '').toString().trim().toLowerCase();
    final String normalizedGst =
        (isGstBill ?? '').toString().trim().toUpperCase();
    if (normalizedInvoiceType == 'tax invoice' ||
        normalizedInvoiceType == 'tax_invoice' ||
        normalizedGst == 'Y') {
      return 'TAX_INVOICE';
    }
    return 'SALES_INVOICE';
  }

  MobileAppSalesInvoiceMaster(
      {required this.invoiceId,
      required this.companyId,
      required this.routeId,
      required this.branchId,
      required this.branchName,
      required this.invoiceType,
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
      required this.roundOf,
      required this.netTotal,
      required this.payType,
      required this.latitude,
      required this.longitude,
      required this.srtVoucherNo,
      required this.receiptNo,
      required this.paidAmount,
      required this.details,
      required this.uuid});

  factory MobileAppSalesInvoiceMaster.fromJson(Map<String, dynamic> json) {
    return MobileAppSalesInvoiceMaster(
      companyId: json["CompanyId"] ?? json["companyId"] ?? 0,
      clientId: json["ClientId"] ?? json["clientId"] ?? 0,
      salesManId:
          json["DriverId"] ?? json["salesManId"] ?? json["driverId"] ?? 0,
      branchId: json["VehicleId"] ?? json["branchId"] ?? json["vehicleId"] ?? 0,
      branchName: (json["VehicleNo"] ?? json["branchName"] ?? "").toString(),
      invoiceType: _normalizeInvoiceType(
        json["InvoiceType"] ?? json["invoiceType"],
        json["isGstBill"] ?? json["IsGstBill"],
      ),
      clientName: (json["ClientName"] ?? json["clientName"] ?? "").toString(),
      invoiceDate:
          (json["InvoiceDate"] ?? json["invoiceDate"] ?? "").toString(),
      invoiceId: json["InvoiceId"] ?? json["invoiceId"] ?? 0,
      invoiceNo: (json["InvoiceNo"] ?? json["invoiceNo"] ?? "").toString(),
      mobile: (json["mobile"] ?? "").toString(),
      routeId: json["RouteId"] ?? json["routeId"] ?? 0,
      salesManName:
          (json["DriverName"] ?? json["salesManName"] ?? "").toString(),
      latitude: (json["Latitude"] ?? json["latitude"] ?? "").toString(),
      longitude: (json["Longitude"] ?? json["longitude"] ?? "").toString(),
      netTotal:
          (json['NetTotal'] ?? json['netTotal'] as num?)?.toDouble() ?? 0.0,
      paidAmount:
          (json['PaidAmount'] ?? json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      payType: (json["PayType"] ?? json["payType"] ?? "").toString(),
      receiptNo: (json["ReceiptNo"] ?? json["receiptNo"] ?? "").toString(),
      srtVoucherNo:
          (json["srtVoucherNo"] ?? json["SrtVoucherNo"] ?? "").toString(),
      totalAmount:
          (json['Total'] ?? json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      totalCessAmount:
          (json['TotalCessAmount'] ?? json['totalCessAmount'] as num?)
                  ?.toDouble() ??
              0.0,
      totalCgstAmount:
          (json['TotalCgstAmount'] ?? json['totalCgstAmount'] as num?)
                  ?.toDouble() ??
              0.0,
      totalDiscountVal:
          (json['DiscountAmount'] ?? json['totalDiscountVal'] as num?)
                  ?.toDouble() ??
              0.0,
      totalDiscountPer:
          (json['DiscountPercentage'] ?? json['totalDiscountPer'] as num?)
                  ?.toDouble() ??
              0.0,
      totalIgstAmount:
          (json['TotalIgstAmount'] ?? json['totalIgstAmount'] as num?)
                  ?.toDouble() ??
              0.0,
      totalSgstAmount:
          (json['TotalSgstAmount'] ?? json['totalSgstAmount'] as num?)
                  ?.toDouble() ??
              0.0,
      roundOf: (json['roundOf'] as num?)?.toDouble() ??
          (json['RoundOf'] as num?)?.toDouble() ??
          0.0,
      totalTaxableAmount:
          (json['TotalTaxableAmount'] ?? json['totalTaxableAmount'] as num?)
                  ?.toDouble() ??
              0.0,
      uuid: (json["uuid"] ?? "").toString(),
      details: ((json['mobileAppSalesInvoiceMasterDt'] ??
                  json['mobileAppSalesInvoiceDetails']) as List<dynamic>?)
              ?.map((e) => MobileAppSalesInvoiceMasterDt.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "companyId": companyId,
        "clientId": clientId,
        "salesManId": salesManId,
        "branchId": branchId,
        "branchName": branchName,
        "isGstBill": invoiceType == 'TAX_INVOICE' ? 'Y' : 'N',
        "InvoiceType":
            invoiceType == 'TAX_INVOICE' ? 'Tax Invoice' : 'Sales Invoice',
        "clientName": clientName,
        "invoiceDate": invoiceDate,
        "invoiceId": invoiceId,
        "invoiceNo": invoiceNo,
        "mobile": mobile,
        "routeId": routeId,
        "salesManName": salesManName,
        "latitude": latitude,
        "longitude": longitude,
        "netTotal": netTotal,
        "paidAmount": paidAmount,
        "payType": payType,
        "receiptNo": receiptNo,
        "srtVoucherNo": srtVoucherNo,
        "totalAmount": totalAmount,
        "totalCessAmount": totalCessAmount,
        "totalCgstAmount": totalCgstAmount,
        "totalDiscountVal": totalDiscountVal,
        "totalIgstAmount": totalIgstAmount,
        "totalSgstAmount": totalSgstAmount,
        "roundOf": roundOf,
        "totalTaxableAmount": totalTaxableAmount,
        "uuid": uuid
      };

  Map<String, dynamic> toDbJson() => {
        "companyId": companyId,
        "routeId": routeId,
        "branchId": branchId,
        "branchName": branchName,
        "invoiceType": invoiceType,
        "invoiceNo": invoiceNo,
        "invoiceDate": invoiceDate,
        "salesManId": salesManId,
        "salesManName": salesManName,
        "clientId": clientId,
        "clientName": clientName,
        "mobile": mobile,
        "totalAmount": totalAmount,
        "totalDiscountVal": totalDiscountVal,
        "totalTaxableAmount": totalTaxableAmount,
        "totalSgstAmount": totalSgstAmount,
        "totalCgstAmount": totalCgstAmount,
        "totalCessAmount": totalCessAmount,
        "totalIgstAmount": totalIgstAmount,
        "roundOf": roundOf,
        "netTotal": netTotal,
        "payType": payType,
        "latitude": latitude,
        "longitude": longitude,
        "srtVoucherNo": srtVoucherNo,
        "receiptNo": receiptNo,
        "paidAmount": paidAmount,
        "invoiceId": invoiceId,
        "uuid": uuid,
      };

  static List<MobileAppSalesInvoiceMaster> fromJsonList(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => MobileAppSalesInvoiceMaster.fromJson(json))
        .toList();
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
    String? invoiceType,
    String? invoiceDate,
    int? routeId,
    int? vehicleId,
    String? vehicleNo,
    double? netTotal,
    double? total,
    double? discountAmount,
    double? discountPercentage,
    double? totalTaxableAmount,
    double? totalSgstAmount,
    double? totalCgstAmount,
    double? totalIgstAmount,
    double? totalCessAmount,
    double? roundOf,
    double? paidAmount,
    List<MobileAppSalesInvoiceMasterDt>? details,
  }) {
    return MobileAppSalesInvoiceMaster(
        paidAmount: paidAmount ?? this.paidAmount,
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
        invoiceType: invoiceType ?? this.invoiceType,
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
        totalCessAmount: totalCessAmount ?? this.totalCessAmount,
        totalCgstAmount: totalCgstAmount ?? this.totalCgstAmount,
        totalIgstAmount: totalIgstAmount ?? this.totalIgstAmount,
        totalTaxableAmount: totalTaxableAmount ?? this.totalTaxableAmount,
        totalSgstAmount: totalSgstAmount ?? this.totalSgstAmount,
        roundOf: roundOf ?? this.roundOf,
        uuid: uuid);
  }
}

class MobileAppSalesInvoiceMasterDt {
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
  final double gstPercentage;
  final double sgstPercentage;
  final double cgstPercentage;
  final double igstPercentage;
  final double cessPercentage;
  final double taxableAmount;
  final double sgstAmount;
  final double cgstAmount;
  final double igstAmount;
  final double cessAmount;
  final double netAmount;

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
    required this.gstPercentage,
    required this.sgstPercentage,
    required this.cgstPercentage,
    required this.igstPercentage,
    required this.cessPercentage,
    required this.taxableAmount,
    required this.sgstAmount,
    required this.cgstAmount,
    required this.igstAmount,
    required this.cessAmount,
    required this.netAmount,
  });

  factory MobileAppSalesInvoiceMasterDt.fromJson(Map<String, dynamic> json) {
    final double parsedSgstPercentage =
        ((json['SgstPercentage'] ?? json['sgstPercentage']) as num?)
                ?.toDouble() ??
            0.0;
    final double parsedCgstPercentage =
        ((json['CgstPercentage'] ?? json['cgstPercentage']) as num?)
                ?.toDouble() ??
            0.0;
    final double parsedIgstPercentage =
        ((json['IgstPercentage'] ?? json['igstPercentage']) as num?)
                ?.toDouble() ??
            0.0;
    final double parsedTaxPercentage = ((json['TaxPercentage'] ??
                json['taxPercentage'] ??
                json['gstPercentage']) as num?)
            ?.toDouble() ??
        (parsedSgstPercentage + parsedCgstPercentage + parsedIgstPercentage);
    final double parsedTaxableAmount = ((json['TaxableRate'] ??
                json['taxableRate'] ??
                json['taxableAmount']) as num?)
            ?.toDouble() ??
        ((json['TotalRate'] ?? json['totalRate']) as num?)?.toDouble() ??
        0.0;

    return MobileAppSalesInvoiceMasterDt(
      companyId: json["CompanyId"] ?? json["companyId"] ?? 0,
      clientId: json["ClientId"] ?? json["clientId"] ?? 0,
      siNo: json["SiNo"] ?? json["siNo"] ?? 0,
      packMultiplyQty: json["packMultiplyQty"] ?? 0,
      packingOrder: json["packingOrder"] ?? 0,
      salesManId:
          json["DriverId"] ?? json["salesManId"] ?? json["driverId"] ?? 0,
      branchId: json["VehicleId"] ?? json["branchId"] ?? json["vehicleId"] ?? 0,
      branchName: (json["VehicleNo"] ?? json["branchName"] ?? "").toString(),
      clientName: (json["ClientName"] ?? json["clientName"] ?? "").toString(),
      foc: ((json['Foc'] ?? json['foc']) as num?)?.toDouble() ?? 0.0,
      invoiceDate:
          (json["InvoiceDate"] ?? json["invoiceDate"] ?? "").toString(),
      invoiceId: json["InvoiceId"] ?? json["invoiceId"] ?? 0,
      invoiceNo: (json["InvoiceNo"] ?? json["invoiceNo"] ?? "").toString(),
      mobile: (json["mobile"] ?? "").toString(),
      netRate:
          ((json['NetRate'] ?? json['netRate']) as num?)?.toDouble() ?? 0.0,
      packingId: json["PackingId"] ?? json["packingId"] ?? 0,
      packingName:
          (json["PackingName"] ?? json["packingName"] ?? "").toString(),
      packQty: json["packQty"] ?? 0,
      partNumber: (json["PartNumber"] ?? json["partNumber"] ?? "").toString(),
      productId: json["ProductId"] ?? json["productId"] ?? 0,
      productName:
          (json["ProductName"] ?? json["productName"] ?? "").toString(),
      quantity:
          ((json['Quantity'] ?? json['quantity']) as num?)?.toDouble() ?? 0.0,
      routeId: json["RouteId"] ?? json["routeId"] ?? 0,
      salesManName:
          (json["DriverName"] ?? json["salesManName"] ?? "").toString(),
      srtQty: ((json['SrtQty'] ?? json['srtQty']) as num?)?.toDouble() ?? 0.0,
      totalQty:
          ((json['TotalQty'] ?? json['totalQty']) as num?)?.toDouble() ?? 0.0,
      totalRate:
          ((json['TotalRate'] ?? json['totalRate']) as num?)?.toDouble() ?? 0.0,
      unitRate:
          ((json['UnitRate'] ?? json['unitRate']) as num?)?.toDouble() ?? 0.0,
      gstPercentage: parsedTaxPercentage,
      sgstPercentage: parsedSgstPercentage,
      cgstPercentage: parsedCgstPercentage,
      igstPercentage: parsedIgstPercentage,
      cessPercentage:
          ((json['CessPercentage'] ?? json['cessPercentage']) as num?)
                  ?.toDouble() ??
              0.0,
      taxableAmount: parsedTaxableAmount,
      sgstAmount:
          ((json['SgstAmount'] ?? json['sgstAmount']) as num?)?.toDouble() ??
              0.0,
      cgstAmount:
          ((json['CgstAmount'] ?? json['cgstAmount']) as num?)?.toDouble() ??
              0.0,
      igstAmount:
          ((json['IgstAmount'] ?? json['igstAmount']) as num?)?.toDouble() ??
              0.0,
      cessAmount:
          ((json['CessAmount'] ?? json['cessAmount']) as num?)?.toDouble() ??
              0.0,
      netAmount: ((json['NetRate'] ?? json['netAmount']) as num?)?.toDouble() ??
          (json['totalRate'] as num?)?.toDouble() ??
          0.0,
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
        "mobile": mobile,
        "netRate": netRate,
        "packingId": packingId,
        "packingName": packingName,
        "packQty": packQty,
        "partNumber": partNumber,
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "routeId": routeId,
        "salesManName": salesManName,
        "srtQty": srtQty,
        "totalQty": totalQty,
        "totalRate": totalRate,
        "unitRate": unitRate,
        "TaxPercentage": gstPercentage,
        "SgstPercentage": sgstPercentage,
        "CgstPercentage": cgstPercentage,
        "IgstPercentage": igstPercentage,
        "CessPercentage": cessPercentage,
        "TaxableRate": taxableAmount,
        "SgstAmount": sgstAmount,
        "CgstAmount": cgstAmount,
        "IgstAmount": igstAmount,
        "CessAmount": cessAmount,
        "NetRate": netAmount,
      };

  Map<String, dynamic> toDbJson() => {
        "invoiceId": invoiceId,
        "companyId": companyId,
        "routeId": routeId,
        "branchId": branchId,
        "branchName": branchName,
        "invoiceNo": invoiceNo,
        "invoiceDate": invoiceDate,
        "salesManId": salesManId,
        "salesManName": salesManName,
        "clientId": clientId,
        "clientName": clientName,
        "mobile": mobile,
        "siNo": siNo,
        "productId": productId,
        "partNumber": partNumber,
        "productName": productName,
        "packingId": packingId,
        "packingName": packingName,
        "packQty": packQty,
        "packingOrder": packingOrder,
        "packMultiplyQty": packMultiplyQty,
        "quantity": quantity,
        "foc": foc,
        "srtQty": srtQty,
        "totalQty": totalQty,
        "unitRate": unitRate,
        "totalRate": totalRate,
        "netRate": netRate,
        "gstPercentage": gstPercentage,
        "sgstPercentage": sgstPercentage,
        "cgstPercentage": cgstPercentage,
        "igstPercentage": igstPercentage,
        "taxableAmount": taxableAmount,
        "sgstAmount": sgstAmount,
        "cgstAmount": cgstAmount,
        "igstAmount": igstAmount,
        "netAmount": netAmount,
      };

  static List<MobileAppSalesInvoiceMasterDt> fromJsonList(
      List<dynamic> jsonList) {
    return jsonList
        .map((json) => MobileAppSalesInvoiceMasterDt.fromJson(json))
        .toList();
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
    double? srtQty,
    double? netRate,
    double? gstPercentage,
    double? sgstPercentage,
    double? cgstPercentage,
    double? igstPercentage,
    double? cessPercentage,
    double? taxableAmount,
    double? sgstAmount,
    double? cgstAmount,
    double? igstAmount,
    double? cessAmount,
    double? netAmount,
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
        gstPercentage: gstPercentage ?? this.gstPercentage,
        sgstPercentage: sgstPercentage ?? this.sgstPercentage,
        cgstPercentage: cgstPercentage ?? this.cgstPercentage,
        igstPercentage: igstPercentage ?? this.igstPercentage,
        cessPercentage: cessPercentage ?? this.cessPercentage,
        taxableAmount: taxableAmount ?? this.taxableAmount,
        sgstAmount: sgstAmount ?? this.sgstAmount,
        cgstAmount: cgstAmount ?? this.cgstAmount,
        igstAmount: igstAmount ?? this.igstAmount,
        cessAmount: cessAmount ?? this.cessAmount,
        netAmount: netAmount ?? this.netAmount,
        packQty: packQty,
        netRate: netRate ?? this.netRate,
        salesManName: salesManName);
  }
}
