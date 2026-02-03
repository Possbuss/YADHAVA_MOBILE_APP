class Voucher {
  String voucherNo;
  String voucherDate;
  int voucherTypeNameId;
  String? voucherTypeName;
  int accountId;
  String accountName;
  String narration;
  String entryType;
  double lcDebit;
  double lcCredit;
  String dr;
  String cr;
  double runningBalance;
  int companyId;

  Voucher({
    required this.voucherNo,
    required this.voucherDate,
    required this.voucherTypeNameId,
    this.voucherTypeName,
    required this.accountId,
    required this.accountName,
    required this.narration,
    required this.entryType,
    required this.lcDebit,
    required this.lcCredit,
    required this.dr,
    required this.cr,
    required this.runningBalance,
    required this.companyId,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    return Voucher(
      voucherNo: json["voucherNo"],
      voucherDate: json["voucherDate"],
      voucherTypeNameId: json["voucherTypeNameId"],
      voucherTypeName: json["voucherTypeName"],
      accountId: json["accountId"],
      accountName: json["accountName"],
      narration: json["narration"],
      entryType: json["entryType"],
      lcDebit: (json["lcDebit"] ?? 0).toDouble(),
      lcCredit: (json["lcCredit"] ?? 0).toDouble(),
      dr: json["dr"],
      cr: json["cr"],
      runningBalance: (json["runningBalance"] ?? 0).toDouble(),
      companyId: json["companyId"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "voucherNo": voucherNo,
      "voucherDate": voucherDate,
      "voucherTypeNameId": voucherTypeNameId,
      "voucherTypeName": voucherTypeName,
      "accountId": accountId,
      "accountName": accountName,
      "narration": narration,
      "entryType": entryType,
      "lcDebit": lcDebit,
      "lcCredit": lcCredit,
      "dr": dr,
      "cr": cr,
      "runningBalance": runningBalance,
      "companyId": companyId,
    };
  }

  static List<Voucher> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Voucher.fromJson(json)).toList();
  }
}