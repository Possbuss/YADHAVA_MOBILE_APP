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
      branchId: _toInt(json['branchId']),
      branchName: (json['branchName'] ?? '').toString(),
      routeId: _toInt(json['routeId']),
      routeName: (json['routeName'] ?? '').toString(),
      amount: _toDouble(json['amount']),
      payType: (json['payType'] ?? '').toString(),
    );
  }

  static int _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

  static double _toDouble(dynamic value) => value is num
      ? value.toDouble()
      : double.tryParse(value?.toString() ?? '') ?? 0;

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
