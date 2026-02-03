class CashCreditDetailsModel {
  final int customerId;
  final String customerName;
  final double debit;
  final double credit;

  CashCreditDetailsModel(
      {required this.customerId,
      required this.customerName,
      required this.debit,
      required this.credit});

  factory CashCreditDetailsModel.fromJson(Map<String, dynamic> json) {
    return CashCreditDetailsModel(
      customerId: _toInt(json['customerId']),
      customerName: json['customerName'] ?? '',
      debit: (json['debit'] ?? 0).toDouble(),
      credit: (json['credit'] ?? 0).toDouble(),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'debit': debit,
      'credit': credit,
    };
  }
}
