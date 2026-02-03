// class ProductItem {
//   final String productName;
//   final String fac;
//   final String srt;
//   final int quantity;
//   final String uom;
//   final String sell;
//   final double totalRate;
//   final int productId;
//   final int partNumber;
//   final String packingDescription;
//   final String packingName;
//   final int packingId;
//
//   ProductItem( {
//     required this.srt,
//     required this.productName,
//     required this.fac,
//     required this.quantity,
//     required this.uom,
//     required this.sell,
//     required this.totalRate,
//     required this.productId,
//     required this.partNumber,
//     required this.packingDescription,
//     required this.packingName,
//     required this.packingId,
//   });
//
//
// }
class ProductItem {
  final int srt;
  final int quantity;
  final String uom;
  final String sell;
  final double totalRate;
  final int productId;
  final String partNumber;
  final String productName;
  final String packingDescription;
  final String packingName;
  final int packingId;
  final int fac;

  ProductItem({
    required this.srt,
    required this.productName,
    required this.fac,
    required this.quantity,
    required this.uom,
    required this.sell,
    required this.totalRate,
    required this.productId,
    required this.partNumber,
    required this.packingDescription,
    required this.packingName,
    required this.packingId,
  });

  factory ProductItem.fromMap(Map<String, dynamic> map) {
    return ProductItem(
      srt: (map['srt'] as num?)?.toInt() ?? 0,
      productName: map['productName'] ?? '',
      fac: (map['fac'] as num?)?.toInt() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      uom: map['uom'] ?? '',
      sell: map['sell'] ?? '0',
      totalRate: (map['totalRate'] ?? 0).toDouble(),
      productId: map['productId'] ?? 0,
      partNumber: map['partNumber'] ?? '',
      packingDescription: map['packingDescription'] ?? '',
      packingName: map['packingName'] ?? '',
      packingId: map['packingId'] ?? 0,
    );
  }
}
