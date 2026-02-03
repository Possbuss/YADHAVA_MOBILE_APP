class SalesTransactions {
  final int branchId;
  final String branchName;
  final int routeId;
  final String routeName;
  final double amount;
  final String payType;

  SalesTransactions({
    required this.branchId,
    required this.branchName,
    required this.routeId,
    required this.routeName,
    required this.amount,
    required this.payType,
  });

  factory SalesTransactions.fromJson(Map<String, dynamic> json) {
    return SalesTransactions(
      branchId: json['branchId'],
      branchName: json['branchName'],
      routeId: json['routeId'],
      routeName: json['routeName'],
      amount: (json['amount'] as num).toDouble(),
      payType: json['payType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'routeId': routeId,
      'routeName': routeName,
      'amount': amount,
      'payType': payType,
    };
  }
}
