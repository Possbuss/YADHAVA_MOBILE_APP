class CashSummery {
  final String customerAccountName;
  final String payType;
  final double amount;

  CashSummery(
      {required this.customerAccountName,
      required this.payType,
      required this.amount});

  factory CashSummery.fromJson(Map<String, dynamic> json) {
    return CashSummery(
      customerAccountName: json['customerAccountName'] ?? '',
      payType: json['payType'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerAccountName': customerAccountName,
      'amount': amount,
    };
  }
}
