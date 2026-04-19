class OrderModel {
  final int id;
  final String uuid;
  final int companyId;
  final int invoiceId;
  final int clientId;
  final String clientName;
  final int driverId;
  final String driverName;
  final String payType;
  final String invoiceNo;
  final String invoiceDate;
  final String receiptNo;
  final int routeId;
  final int vehicleId;
  final String vehicleNo;
  final String invoiceType;
  final double total;
  final double discountPercentage;
  final double discountAmount;
  final double totalTaxableAmount;
  final double totalSgstAmount;
  final double totalCgstAmount;
  final double totalIgstAmount;
  final double totalCessAmount;
  final double roundOf;
  final double netTotal;
  final int transactionYear;
  final double latitude;
  final double longitude;
  final double paidAmount;
  final List<Product> mobileAppSalesInvoiceDetails;

  OrderModel({
    required this.id,
    required this.uuid,
    required this.companyId,
    required this.invoiceId,
    required this.clientId,
    required this.clientName,
    required this.driverId,
    required this.driverName,
    required this.payType,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.receiptNo,
    required this.routeId,
    required this.vehicleId,
    required this.vehicleNo,
    required this.invoiceType,
    required this.total,
    required this.discountPercentage,
    required this.discountAmount,
    required this.totalTaxableAmount,
    required this.totalSgstAmount,
    required this.totalCgstAmount,
    required this.totalIgstAmount,
    required this.totalCessAmount,
    required this.roundOf,
    required this.netTotal,
    required this.transactionYear,
    required this.latitude,
    required this.longitude,
    required this.paidAmount,
    required this.mobileAppSalesInvoiceDetails,
  });

  static String toInvoiceTypeLabel(String value) {
    return value == 'TAX_INVOICE' ? 'Tax Invoice' : 'Sales Invoice';
  }

  static String fromInvoiceTypeValue(dynamic invoiceType, dynamic isGstBill) {
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

  static double roundToFourDecimals(double value) {
    return double.parse(value.toStringAsFixed(4));
  }

  static double computeRoundOf(double amount) {
    return roundToFourDecimals(amount.roundToDouble() - amount);
  }

  Map<String, dynamic> toJson() {
    return {
      'CompanyId': companyId,
      'InvoiceId': invoiceId,
      'ClientId': clientId,
      'ClientName': clientName,
      'DriverId': driverId,
      'DriverName': driverName,
      'PayType': payType,
      'InvoiceNo': invoiceNo,
      'InvoiceDate': invoiceDate,
      'ReceiptNo': receiptNo,
      'RouteId': routeId,
      'VehicleId': vehicleId,
      'VehicleNo': vehicleNo,
      'Total': roundToFourDecimals(total),
      'DiscountPercentage': roundToFourDecimals(discountPercentage),
      'DiscountAmount': roundToFourDecimals(discountAmount),
      'TotalTaxableAmount': roundToFourDecimals(totalTaxableAmount),
      'TotalCgstAmount': roundToFourDecimals(totalCgstAmount),
      'TotalSgstAmount': roundToFourDecimals(totalSgstAmount),
      'TotalIgstAmount': roundToFourDecimals(totalIgstAmount),
      'TotalCessAmount': roundToFourDecimals(totalCessAmount),
      'RoundOf': roundToFourDecimals(roundOf),
      'NetTotal': roundToFourDecimals(netTotal),
      'PaidAmount': roundToFourDecimals(paidAmount),
      'IsGstBill': invoiceType == 'TAX_INVOICE' ? 'Y' : 'N',
      'InvoiceType': toInvoiceTypeLabel(invoiceType),
      'TransactionYear': transactionYear,
      'Latitude': roundToFourDecimals(latitude),
      'Longitude': roundToFourDecimals(longitude),
      'uuid': uuid,
      'mobileAppSalesInvoiceDetails': mobileAppSalesInvoiceDetails
          .map((item) => item.toJson(
                companyId: companyId,
                clientId: clientId,
                invoiceId: invoiceId,
              ))
          .toList(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      uuid: json['uuid'] ?? '',
      companyId: json['CompanyId'] ?? json['companyId'] ?? 0,
      invoiceId: json['InvoiceId'] ?? json['invoiceId'] ?? 0,
      clientId: json['ClientId'] ?? json['clientId'] ?? 0,
      clientName: json['ClientName'] ?? json['clientName'] ?? '',
      driverId: json['DriverId'] ?? json['driverId'] ?? 0,
      driverName: json['DriverName'] ?? json['driverName'] ?? '',
      payType: json['PayType'] ?? json['payType'] ?? '',
      invoiceNo: json['InvoiceNo'] ?? json['invoiceNo'] ?? '',
      invoiceDate: json['InvoiceDate'] ?? json['invoiceDate'] ?? '',
      receiptNo: json['ReceiptNo'] ?? json['receiptNo'] ?? '',
      routeId: json['RouteId'] ?? json['routeId'] ?? 0,
      vehicleId: json['VehicleId'] ?? json['vehicleId'] ?? 0,
      vehicleNo: json['VehicleNo'] ?? json['vehicleNo'] ?? '',
      invoiceType: fromInvoiceTypeValue(
        json['InvoiceType'] ?? json['invoiceType'],
        json['IsGstBill'] ?? json['isGstBill'],
      ),
      total: ((json['Total'] ?? json['total']) as num?)?.toDouble() ?? 0.0,
      discountPercentage:
          ((json['DiscountPercentage'] ?? json['discountPercentage']) as num?)
                  ?.toDouble() ??
              0.0,
      discountAmount:
          ((json['DiscountAmount'] ?? json['discountAmount']) as num?)
                  ?.toDouble() ??
              0.0,
      totalTaxableAmount:
          ((json['TotalTaxableAmount'] ?? json['totalTaxableAmount']) as num?)
                  ?.toDouble() ??
              0.0,
      totalSgstAmount:
          ((json['TotalSgstAmount'] ?? json['totalSgstAmount']) as num?)
                  ?.toDouble() ??
              0.0,
      totalCgstAmount:
          ((json['TotalCgstAmount'] ?? json['totalCgstAmount']) as num?)
                  ?.toDouble() ??
              0.0,
      totalIgstAmount:
          ((json['TotalIgstAmount'] ?? json['totalIgstAmount']) as num?)
                  ?.toDouble() ??
              0.0,
      totalCessAmount:
          ((json['TotalCessAmount'] ?? json['totalCessAmount']) as num?)
                  ?.toDouble() ??
              0.0,
      roundOf:
          ((json['RoundOf'] ?? json['roundOf']) as num?)?.toDouble() ?? 0.0,
      netTotal:
          ((json['NetTotal'] ?? json['netTotal']) as num?)?.toDouble() ?? 0.0,
      transactionYear: json['TransactionYear'] ?? json['transactionYear'] ?? 0,
      latitude:
          ((json['Latitude'] ?? json['latitude']) as num?)?.toDouble() ?? 0.0,
      longitude:
          ((json['Longitude'] ?? json['longitude']) as num?)?.toDouble() ?? 0.0,
      paidAmount:
          ((json['PaidAmount'] ?? json['paidAmount']) as num?)?.toDouble() ??
              0.0,
      mobileAppSalesInvoiceDetails:
          (json['mobileAppSalesInvoiceDetails'] as List<dynamic>? ?? [])
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }
}

class Product {
  final int orderId;
  final int siNo;
  final int productId;
  final String partNumber;
  final String productName;
  final String packingDescription;
  final int packingId;
  final String packingName;
  final int quantity;
  final int foc;
  final int srtQty;
  final int totalQty;
  final int companyId;
  final int clientId;
  final int invoiceId;
  final double unitRate;
  final double totalRate;
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

  Product({
    required this.orderId,
    required this.siNo,
    required this.productId,
    required this.partNumber,
    required this.productName,
    required this.packingDescription,
    required this.packingId,
    required this.packingName,
    required this.quantity,
    required this.foc,
    required this.srtQty,
    required this.totalQty,
    required this.companyId,
    required this.clientId,
    required this.invoiceId,
    required this.unitRate,
    required this.totalRate,
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

  factory Product.fromJson(Map<String, dynamic> json) {
    final double lineTotal =
        ((json['TotalRate'] ?? json['totalRate']) as num?)?.toDouble() ?? 0.0;
    return Product(
      orderId: json['orderId'] ?? 0,
      siNo: json['SiNo'] ?? json['siNo'] ?? 0,
      productId: json['ProductId'] ?? json['productId'] ?? 0,
      partNumber: (json['PartNumber'] ?? json['partNumber'] ?? '').toString(),
      productName: json['ProductName'] ?? json['productName'] ?? '',
      packingDescription:
          json['PackingDescription'] ?? json['packingDescription'] ?? '',
      packingId: json['PackingId'] ?? json['packingId'] ?? 0,
      packingName: json['PackingName'] ?? json['packingName'] ?? '',
      quantity: ((json['Quantity'] ?? json['quantity']) as num?)?.toInt() ?? 0,
      foc: int.tryParse((json['Foc'] ?? json['foc'])?.toString() ?? '0') ?? 0,
      srtQty:
          int.tryParse((json['SrtQty'] ?? json['srtQty'])?.toString() ?? '0') ??
              0,
      totalQty: ((json['TotalQty'] ?? json['totalQty']) as num?)?.toInt() ??
          ((json['Quantity'] ?? json['quantity']) as num?)?.toInt() ??
          0,
      companyId: json['CompanyId'] ?? json['companyId'] ?? 0,
      clientId: json['ClientId'] ?? json['clientId'] ?? 0,
      invoiceId: json['InvoiceId'] ?? json['invoiceId'] ?? 0,
      unitRate: OrderModel.roundToFourDecimals(double.tryParse(
              (json['UnitRate'] ?? json['unitRate'])?.toString() ?? '0') ??
          0.0),
      totalRate: OrderModel.roundToFourDecimals(lineTotal),
      gstPercentage: ((json['TaxPercentage'] ?? json['gstPercentage']) as num?)
              ?.toDouble() ??
          0.0,
      sgstPercentage:
          ((json['SgstPercentage'] ?? json['sgstPercentage']) as num?)
                  ?.toDouble() ??
              0.0,
      cgstPercentage:
          ((json['CgstPercentage'] ?? json['cgstPercentage']) as num?)
                  ?.toDouble() ??
              0.0,
      igstPercentage:
          ((json['IgstPercentage'] ?? json['igstPercentage']) as num?)
                  ?.toDouble() ??
              0.0,
      cessPercentage:
          ((json['CessPercentage'] ?? json['cessPercentage']) as num?)
                  ?.toDouble() ??
              0.0,
      taxableAmount: OrderModel.roundToFourDecimals(
          ((json['TaxableRate'] ?? json['taxableAmount']) as num?)
                  ?.toDouble() ??
              lineTotal),
      sgstAmount: OrderModel.roundToFourDecimals(
          ((json['SgstAmount'] ?? json['sgstAmount']) as num?)?.toDouble() ??
              0.0),
      cgstAmount: OrderModel.roundToFourDecimals(
          ((json['CgstAmount'] ?? json['cgstAmount']) as num?)?.toDouble() ??
              0.0),
      igstAmount: OrderModel.roundToFourDecimals(
          ((json['IgstAmount'] ?? json['igstAmount']) as num?)?.toDouble() ??
              0.0),
      cessAmount: OrderModel.roundToFourDecimals(
          ((json['CessAmount'] ?? json['cessAmount']) as num?)?.toDouble() ??
              0.0),
      netAmount: OrderModel.roundToFourDecimals(
          ((json['NetRate'] ?? json['netAmount']) as num?)?.toDouble() ??
              lineTotal),
    );
  }

  Map<String, dynamic> toJson({
    int? companyId,
    int? clientId,
    int? invoiceId,
  }) {
    return {
      'SiNo': siNo,
      'ProductId': productId,
      'PartNumber': partNumber,
      'ProductName': productName,
      'PackingDescription': packingDescription,
      'PackingId': packingId,
      'PackingName': packingName,
      'Quantity': quantity,
      'Foc': foc,
      'TotalQty': totalQty,
      'SrtQty': srtQty,
      'UnitRate': OrderModel.roundToFourDecimals(unitRate),
      'TotalRate': OrderModel.roundToFourDecimals(totalRate),
      'TaxPercentage': OrderModel.roundToFourDecimals(gstPercentage),
      'TaxableRate': OrderModel.roundToFourDecimals(taxableAmount),
      'IgstPercentage': OrderModel.roundToFourDecimals(igstPercentage),
      'IgstAmount': OrderModel.roundToFourDecimals(igstAmount),
      'CgstPercentage': OrderModel.roundToFourDecimals(cgstPercentage),
      'CgstAmount': OrderModel.roundToFourDecimals(cgstAmount),
      'SgstPercentage': OrderModel.roundToFourDecimals(sgstPercentage),
      'SgstAmount': OrderModel.roundToFourDecimals(sgstAmount),
      'CessPercentage': OrderModel.roundToFourDecimals(cessPercentage),
      'CessAmount': OrderModel.roundToFourDecimals(cessAmount),
      'NetRate': OrderModel.roundToFourDecimals(netAmount),
      'CompanyId': companyId ?? this.companyId,
      'ClientId': clientId ?? this.clientId,
      'InvoiceId': invoiceId ?? this.invoiceId,
    };
  }
}
