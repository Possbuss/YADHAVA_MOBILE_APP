class SalesQuotation {
  final int invoiceId;
  final int companyId;
  final int branchId;
  final String quoteDate;
  final String quoteNo;
  final int salesManId;
  final String salesManName;
  final int saleAccountId;
  final String saleAccountName;
  final int customerAccountId;
  final String customerAccountName;
  final String address;
  final String telFax;
  final String mobile;
  final String email;
  final String poBox;
  final String contactPersonDetails;
  final int currencyId;
  final String currencyName;
  final double currencyRate;
  final String invoiceNo;
  final String invoiceDate;
  final String remarks;
  final double tenderdAmount;
  final double balanceToPay;
  final double roundOf;
  final double totalAmount;
  final double totalDiscount;
  final double totalDiscountVal;
  final double totalTaxableAmount;
  final double totalIgstAmount;
  final double totalCgstAmount;
  final double totalSgstAmount;
  final double totalCessAmount;
  final double netTotal;
  final double totalItems;
  final double totalQty;
  final String orderStatus;
  final String programStatus;
  final String paidStatus;
  final double advanceAmount;
  final double bagQty;
  final String transactionYear;
  final List<SalesQuotationDetail> inventorySalesQuotationDetails;

  const SalesQuotation({
    required this.invoiceId,
    required this.companyId,
    required this.branchId,
    required this.quoteDate,
    required this.quoteNo,
    required this.salesManId,
    required this.salesManName,
    required this.saleAccountId,
    required this.saleAccountName,
    required this.customerAccountId,
    required this.customerAccountName,
    required this.address,
    required this.telFax,
    required this.mobile,
    required this.email,
    required this.poBox,
    required this.contactPersonDetails,
    required this.currencyId,
    required this.currencyName,
    required this.currencyRate,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.remarks,
    required this.tenderdAmount,
    required this.balanceToPay,
    required this.roundOf,
    required this.totalAmount,
    required this.totalDiscount,
    required this.totalDiscountVal,
    required this.totalTaxableAmount,
    required this.totalIgstAmount,
    required this.totalCgstAmount,
    required this.totalSgstAmount,
    required this.totalCessAmount,
    required this.netTotal,
    required this.totalItems,
    required this.totalQty,
    required this.orderStatus,
    required this.programStatus,
    required this.paidStatus,
    required this.advanceAmount,
    required this.bagQty,
    required this.transactionYear,
    required this.inventorySalesQuotationDetails,
  });

  factory SalesQuotation.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> source = _unwrap(json);
    final dynamic details = _value(
      source,
      const [
        'inventorySalesQuotationDetails',
        'InventorySalesQuotationDetails'
      ],
    );

    return SalesQuotation(
      invoiceId: _int(source, const ['invoiceId', 'InvoiceId']),
      companyId: _int(source, const ['companyId', 'CompanyId']),
      branchId: _int(source, const ['branchId', 'BranchId']),
      quoteDate: _string(source, const ['quoteDate', 'QuoteDate']),
      quoteNo: _string(source, const ['quoteNo', 'QuoteNo']),
      salesManId: _int(source, const ['salesManId', 'SalesManId']),
      salesManName: _string(source, const ['salesManName', 'SalesManName']),
      saleAccountId: _int(source, const ['saleAccountId', 'SaleAccountId']),
      saleAccountName:
          _string(source, const ['saleAccountName', 'SaleAccountName']),
      customerAccountId:
          _int(source, const ['customerAccountId', 'CustomerAccountId']),
      customerAccountName: _string(
        source,
        const ['customerAccountName', 'CustomerAccountName'],
      ),
      address: _string(source, const ['address', 'Address']),
      telFax: _string(source, const ['telFax', 'TelFax']),
      mobile: _string(source, const ['mobile', 'Mobile']),
      email: _string(source, const ['email', 'Email']),
      poBox: _string(source, const ['poBox', 'PoBox']),
      contactPersonDetails: _string(
        source,
        const ['contactPersonDetails', 'ContactPersonDetails'],
      ),
      currencyId: _int(source, const ['currencyId', 'CurrencyId']),
      currencyName: _string(source, const ['currencyName', 'CurrencyName']),
      currencyRate: _double(source, const ['currencyRate', 'CurrencyRate']),
      invoiceNo: _string(source, const ['invoiceNo', 'InvoiceNo']),
      invoiceDate: _string(source, const ['invoiceDate', 'InvoiceDate']),
      remarks: _string(source, const ['remarks', 'Remarks']),
      tenderdAmount: _double(source, const ['tenderdAmount', 'TenderdAmount']),
      balanceToPay: _double(source, const ['balanceToPay', 'BalanceToPay']),
      roundOf: _double(source, const ['roundOf', 'RoundOf']),
      totalAmount: _double(source, const ['totalAmount', 'TotalAmount']),
      totalDiscount: _double(source, const ['totalDiscount', 'TotalDiscount']),
      totalDiscountVal:
          _double(source, const ['totalDiscountVal', 'TotalDiscountVal']),
      totalTaxableAmount:
          _double(source, const ['totalTaxableAmount', 'TotalTaxableAmount']),
      totalIgstAmount:
          _double(source, const ['totalIgstAmount', 'TotalIgstAmount']),
      totalCgstAmount:
          _double(source, const ['totalCgstAmount', 'TotalCgstAmount']),
      totalSgstAmount:
          _double(source, const ['totalSgstAmount', 'TotalSgstAmount']),
      totalCessAmount:
          _double(source, const ['totalCessAmount', 'TotalCessAmount']),
      netTotal: _double(source, const ['netTotal', 'NetTotal']),
      totalItems: _double(source, const ['totalItems', 'TotalItems']),
      totalQty: _double(source, const ['totalQty', 'TotalQty']),
      orderStatus: _string(source, const ['orderStatus', 'OrderStatus']),
      programStatus: _string(source, const ['programStatus', 'ProgramStatus']),
      paidStatus: _string(source, const ['paidStatus', 'PaidStatus']),
      advanceAmount: _double(source, const ['advanceAmount', 'AdvanceAmount']),
      bagQty: _double(source, const ['bagQty', 'BagQty']),
      transactionYear:
          _string(source, const ['transactionYear', 'TransactionYear']),
      inventorySalesQuotationDetails: details is List
          ? details
              .whereType<Map<String, dynamic>>()
              .map(SalesQuotationDetail.fromJson)
              .toList()
          : const <SalesQuotationDetail>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'InvoiceId': invoiceId,
      'CompanyId': companyId,
      'BranchId': branchId,
      'QuoteDate': quoteDate,
      'QuoteNo': quoteNo,
      'SalesManId': salesManId,
      'SalesManName': salesManName,
      'SaleAccountId': saleAccountId,
      'SaleAccountName': saleAccountName,
      'CustomerAccountId': customerAccountId,
      'CustomerAccountName': customerAccountName,
      'Address': address,
      'TelFax': telFax,
      'Mobile': mobile,
      'Email': email,
      'PoBox': poBox,
      'ContactPersonDetails': contactPersonDetails,
      'CurrencyId': currencyId,
      'CurrencyName': currencyName,
      'CurrencyRate': currencyRate,
      'InvoiceNo': invoiceNo,
      'InvoiceDate': invoiceDate,
      'Remarks': remarks,
      'TenderdAmount': tenderdAmount,
      'BalanceToPay': balanceToPay,
      'RoundOf': roundOf,
      'TotalAmount': totalAmount,
      'TotalDiscount': totalDiscount,
      'TotalDiscountVal': totalDiscountVal,
      'TotalTaxableAmount': totalTaxableAmount,
      'TotalIgstAmount': totalIgstAmount,
      'TotalCgstAmount': totalCgstAmount,
      'TotalSgstAmount': totalSgstAmount,
      'TotalCessAmount': totalCessAmount,
      'NetTotal': netTotal,
      'TotalItems': totalItems,
      'TotalQty': totalQty,
      'OrderStatus': orderStatus,
      'ProgramStatus': programStatus,
      'PaidStatus': paidStatus,
      'AdvanceAmount': advanceAmount,
      'BagQty': bagQty,
      'TransactionYear': transactionYear,
      'inventorySalesQuotationDetails':
          inventorySalesQuotationDetails.map((e) => e.toJson()).toList(),
    };
  }

  SalesQuotation copyWith({
    int? invoiceId,
    String? quoteNo,
    String? quoteDate,
    String? remarks,
    double? totalAmount,
    double? totalQty,
    double? totalItems,
    double? netTotal,
    List<SalesQuotationDetail>? inventorySalesQuotationDetails,
  }) {
    return SalesQuotation(
      invoiceId: invoiceId ?? this.invoiceId,
      companyId: companyId,
      branchId: branchId,
      quoteDate: quoteDate ?? this.quoteDate,
      quoteNo: quoteNo ?? this.quoteNo,
      salesManId: salesManId,
      salesManName: salesManName,
      saleAccountId: saleAccountId,
      saleAccountName: saleAccountName,
      customerAccountId: customerAccountId,
      customerAccountName: customerAccountName,
      address: address,
      telFax: telFax,
      mobile: mobile,
      email: email,
      poBox: poBox,
      contactPersonDetails: contactPersonDetails,
      currencyId: currencyId,
      currencyName: currencyName,
      currencyRate: currencyRate,
      invoiceNo: invoiceNo,
      invoiceDate: invoiceDate,
      remarks: remarks ?? this.remarks,
      tenderdAmount: tenderdAmount,
      balanceToPay: balanceToPay,
      roundOf: roundOf,
      totalAmount: totalAmount ?? this.totalAmount,
      totalDiscount: totalDiscount,
      totalDiscountVal: totalDiscountVal,
      totalTaxableAmount: totalTaxableAmount,
      totalIgstAmount: totalIgstAmount,
      totalCgstAmount: totalCgstAmount,
      totalSgstAmount: totalSgstAmount,
      totalCessAmount: totalCessAmount,
      netTotal: netTotal ?? this.netTotal,
      totalItems: totalItems ?? this.totalItems,
      totalQty: totalQty ?? this.totalQty,
      orderStatus: orderStatus,
      programStatus: programStatus,
      paidStatus: paidStatus,
      advanceAmount: advanceAmount,
      bagQty: bagQty,
      transactionYear: transactionYear,
      inventorySalesQuotationDetails:
          inventorySalesQuotationDetails ?? this.inventorySalesQuotationDetails,
    );
  }

  static Map<String, dynamic> _unwrap(Map<String, dynamic> json) {
    final dynamic nested = _value(
      json,
      const [
        'inventorySalesQuotation',
        'InventorySalesQuotation',
        'data',
        'Data'
      ],
    );
    if (nested is Map<String, dynamic>) {
      return nested;
    }
    return json;
  }

  static dynamic _value(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      if (json.containsKey(key)) return json[key];
    }
    return null;
  }

  static int _int(Map<String, dynamic> json, List<String> keys) =>
      int.tryParse(_value(json, keys)?.toString() ?? '') ?? 0;
  static double _double(Map<String, dynamic> json, List<String> keys) =>
      double.tryParse(_value(json, keys)?.toString() ?? '') ?? 0;
  static String _string(Map<String, dynamic> json, List<String> keys) =>
      _value(json, keys)?.toString() ?? '';
}

class SalesQuotationDetail {
  final int siNo;
  final int productId;
  final String partNumber;
  final String productName;
  final String packingDescription;
  final int packingId;
  final String packingName;
  final double quantity;
  final double foc;
  final double srtQty;
  final double totalQty;
  final double unitRate;
  final double totalRate;

  const SalesQuotationDetail({
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
    required this.unitRate,
    required this.totalRate,
  });

  factory SalesQuotationDetail.fromJson(Map<String, dynamic> json) {
    return SalesQuotationDetail(
      siNo: int.tryParse(json['siNo']?.toString() ?? '') ?? 0,
      productId: int.tryParse(json['productId']?.toString() ?? '') ?? 0,
      partNumber: json['partNumber']?.toString() ?? '',
      productName: json['productName']?.toString() ?? '',
      packingDescription: json['packingDescription']?.toString() ?? '',
      packingId: int.tryParse(json['packingId']?.toString() ?? '') ?? 0,
      packingName: json['packingName']?.toString() ?? '',
      quantity: double.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      foc: double.tryParse(json['foc']?.toString() ?? '') ?? 0,
      srtQty: double.tryParse(
            json['srtQty']?.toString() ?? json['srt']?.toString() ?? '',
          ) ??
          0,
      totalQty: double.tryParse(json['totalQty']?.toString() ?? '') ?? 0,
      unitRate: double.tryParse(json['unitRate']?.toString() ?? '') ?? 0,
      totalRate: double.tryParse(json['totalRate']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
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
      'SrtQty': srtQty,
      'TotalQty': totalQty,
      'UnitRate': unitRate,
      'TotalRate': totalRate,
    };
  }

  SalesQuotationDetail copyWith({
    int? siNo,
    double? quantity,
    double? unitRate,
    double? totalRate,
  }) {
    return SalesQuotationDetail(
      siNo: siNo ?? this.siNo,
      productId: productId,
      partNumber: partNumber,
      productName: productName,
      packingDescription: packingDescription,
      packingId: packingId,
      packingName: packingName,
      quantity: quantity ?? this.quantity,
      foc: foc,
      srtQty: srtQty,
      totalQty: quantity ?? this.quantity,
      unitRate: unitRate ?? this.unitRate,
      totalRate: totalRate ?? this.totalRate,
    );
  }
}

class SalesQuotationRegisterItem {
  final int invoiceId;
  final String quoteNo;
  final String quoteDate;
  final String customerAccountName;
  final String remarks;
  final double netTotal;
  final String orderStatus;

  const SalesQuotationRegisterItem({
    required this.invoiceId,
    required this.quoteNo,
    required this.quoteDate,
    required this.customerAccountName,
    required this.remarks,
    required this.netTotal,
    required this.orderStatus,
  });

  factory SalesQuotationRegisterItem.fromJson(Map<String, dynamic> json) {
    return SalesQuotationRegisterItem(
      invoiceId: int.tryParse(
            (json['invoiceId'] ?? json['InvoiceId'] ?? 0).toString(),
          ) ??
          0,
      quoteNo: (json['quoteNo'] ?? json['QuoteNo'] ?? '').toString(),
      quoteDate: (json['quoteDate'] ?? json['QuoteDate'] ?? '').toString(),
      customerAccountName:
          (json['customerAccountName'] ?? json['CustomerAccountName'] ?? '')
              .toString(),
      remarks: (json['remarks'] ?? json['Remarks'] ?? '').toString(),
      netTotal: double.tryParse(
            (json['netTotal'] ?? json['NetTotal'] ?? 0).toString(),
          ) ??
          0,
      orderStatus:
          (json['orderStatus'] ?? json['OrderStatus'] ?? '').toString(),
    );
  }
}
