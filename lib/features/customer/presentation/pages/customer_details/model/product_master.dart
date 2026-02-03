class ProductMaster {

  final int companyId;
  final int productId;
  final String partNumber;
  final String productName;
  final int basePackingId;
  final String isActive;
  final int categoryId;
  final String categoryName;
  final int packingId;
  final String packingName;
  final int packingOrder;
  final int packMultiplyQty;
  final String packingDescription;
  final double mrp;
  final double buyyingPrice;
  final double sellingPrice;
  final double wholeSalePrice;


  //final String uom;
  final int srt;
  final int quantity;
  final int foc;
  final double totalRate;
  final int siNo;

  ProductMaster({
    required this.companyId,
    required this.productId,
    required this.partNumber,
    required this.productName,
    required this.basePackingId,
    required this.isActive,
    required this.categoryId,
    required this.categoryName,
    required this.packingId,
    required this.packingName,
    required this.packingOrder,
    required this.packMultiplyQty,
    required this.packingDescription,
    required this.mrp,
    required this.buyyingPrice,
    required this.sellingPrice,
    required this.wholeSalePrice,


    //required this.uom,
    required this.srt,
    required this.quantity,
    required this.foc,
    required this.totalRate,
    required this.siNo,

  });

  factory ProductMaster.fromJson(Map<String, dynamic> json) {
    return ProductMaster(
      productId: json['productId'] ?? 0,
      partNumber: json['partNumber'] ?? '',
      productName: json['productName']?.toString() ?? '',
      basePackingId: json['basePackingId'] ?? 0,
      isActive: json['isActive'] ?? '',
      categoryId: json['categoryId'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      packingId: json['packingId'] ?? 0,
      packingName: json['packingName'] ?? '',
      packingOrder: json['packingOrder'] ?? 0,
      packMultiplyQty: json['packMultiplyQty'] ?? 0,
      packingDescription: json['packingDescription'] ?? '',
      mrp: (json['mrp'] ?? 0).toDouble(),
      buyyingPrice: (json['buyyingPrice'] ?? 0).toDouble(),
      sellingPrice: (json['sellingPrice'] ?? 0).toDouble(),
      wholeSalePrice: (json['wholeSalePrice'] ?? 0).toDouble(),
      companyId: json['companyId'] ?? 0,

      srt: (json['srt'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      foc: (json['foc'] as num?)?.toInt() ?? 0,
      totalRate: (json['totalRate'] ?? 0).toDouble(),
      siNo: json['siNo'] ?? 0,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'partNumber': partNumber,
      'productName': productName,
      'basePackingId': basePackingId,
      'isActive': isActive,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'packingId': packingId,
      'packingName': packingName,
      'packingOrder': packingOrder,
      'packMultiplyQty': packMultiplyQty,
      'packingDescription': packingDescription,
      'mrp': mrp,
      'buyyingPrice': buyyingPrice,
      'sellingPrice': sellingPrice,
      'wholeSalePrice': wholeSalePrice,
      'companyId': companyId,

      'srt': srt,
      'quantity': quantity,
      'foc': foc,
      'totalRate': totalRate,
      //'uom': uom,

    };
  }
}