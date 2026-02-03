
import 'addItem_model.dart';

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
  final int routeId;
  final int vehicleId;
  final String vehicleNo;
  final double total;
  final double discountPercentage;
  final double discountAmount;
  final double netTotal;
  final int transactionYear;
  final double latitude;
  final double longitude;
  final double paidAmount;
  final List<Product> mobileAppSalesInvoiceDetails;

  OrderModel(
      {
        required this.id,
        required this.uuid,
        required this.paidAmount,
        required  this.total,
        required this.discountPercentage,
        required this.discountAmount,
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
        required this.latitude,
        required this.longitude,
        required this.mobileAppSalesInvoiceDetails,
  });



  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'uuid':uuid,
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
      "total": total,
      "discountPercentage": discountPercentage,
      "discountAmount": discountAmount,
      'netTotal': netTotal,
      'transactionYear': transactionYear,
      'latitude': latitude,
      'longitude': longitude,
      'paidAmount':paidAmount,
      'mobileAppSalesInvoiceDetails': mobileAppSalesInvoiceDetails.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id : json['id'],
      uuid : json['uuid'],
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
      total: (json['total'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      discountAmount: json['discountAmount'],
      netTotal: (json['netTotal'] as num).toDouble(),
      transactionYear: json['transactionYear'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      mobileAppSalesInvoiceDetails: (json['mobileAppSalesInvoiceDetails'] as List)
          .map((item) => Product.fromJson(item))
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
  final double unitRate;
  final double totalRate;

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
    required this.srtQty,
    required this.foc,
    required this.totalQty,
    required this.unitRate,
    required this.totalRate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      orderId: json['orderId'] ?? 0,
      siNo: json['siNo'] ?? 0,
      productId: json['productId'],
      partNumber: json['partNumber'].toString(),
      productName: json['productName'],
      packingDescription: json['packingDescription'],
      packingId: json['packingId'],
      packingName: json['packingName'],
      quantity: json['quantity'],
      foc: int.tryParse(json['foc']?.toString() ?? '0') ?? 0, // Fixed parsing
      totalQty: json['quantity'],
      unitRate: double.tryParse(json['unitRate']?.toString() ?? '0.0') ?? 0.0,
      totalRate: json['totalRate'],
      srtQty: int.tryParse(json['srtQty']?.toString() ?? '0') ?? 0, // Fixed parsing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'siNo': siNo,
      'productId': productId,
      'partNumber': partNumber,
      'productName': productName,
      'packingDescription': packingDescription,
      'packingId': packingId,
      'packingName': packingName,
      'quantity': quantity,
      'foc': foc,
      'totalQty': totalQty,
      "srtQty": srtQty,
      'unitRate': unitRate,
      'totalRate': totalRate,
    };
  }
}
