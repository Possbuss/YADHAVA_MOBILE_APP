class ProductStock {
  final int productId;
  final String partNumber;
  final String productName;
  final int packingId;
  final String packingName;
  final int companyId;
  final double sellingPrice;
  final double stock;
  final double stockValue;
  final double srtQty;

  ProductStock({
    required this.productId,
    required this.partNumber,
    required this.productName,
    required this.packingId,
    required this.packingName,
    required this.companyId,
    required this.sellingPrice,
    required this.stock,
    required this.stockValue,
    required this.srtQty,
  });

  factory ProductStock.fromJson(Map<String, dynamic> json) {
    return ProductStock(
      productId: json['productId'],
      partNumber: json['partNumber'],
      productName: json['productName'],
      packingId: json['packingId'],
      packingName: json['packingName'],
      companyId: json['companyId'],
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      stock: (json['stock'] as num).toDouble(),
      stockValue: (json['stockValue'] as num).toDouble(),
      srtQty: (json['srtQty'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'partNumber': partNumber,
      'productName': productName,
      'packingId': packingId,
      'packingName': packingName,
      'companyId': companyId,
      'sellingPrice': sellingPrice,
      'stock': stock,
      'stockValue': stockValue,
      'srtQty': srtQty
    };
  }
}
