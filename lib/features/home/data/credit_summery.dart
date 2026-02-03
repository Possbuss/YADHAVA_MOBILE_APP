class CreditSummery {
  final String customerAccountName;
  final double amount;

  CreditSummery({required this.customerAccountName, required this.amount});

  factory CreditSummery.fromJson(Map<String, dynamic> json) {
    return CreditSummery(
      customerAccountName: json['customerAccountName'] ?? '',
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
