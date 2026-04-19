// // To parse this JSON data, do
// //
// //     final getAllCompanyModel = getAllCompanyModelFromJson(jsonString);
//
// import 'dart:convert';
//
// List<GetAllCompanyModel> getAllCompanyModelFromJson(String str) => List<GetAllCompanyModel>.from(json.decode(str).map((x) => GetAllCompanyModel.fromJson(x)));
//
// String getAllCompanyModelToJson(List<GetAllCompanyModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class GetAllCompanyModel {
//   int companyId;
//   String companyName;
//   String taxRegistrationNo;
//   String address;
//   String street;
//   String city;
//   String country;
//   String stateProvince;
//   String pincode;
//   String phone;
//   String mobile;
//   String fax;
//   String zoneNumber;
//   String crNo;
//   String buildingNumber;
//   String isActive;
//   String emailid;
//   String companyCode;
//   String companyLogo;
//   String companyType;
//   String fssai;
//   String bankAccountName;
//   String bankAccountNumber;
//   String bankIfscCode;
//   String bankBranch;
//   String isTaxEnabled;
//   String dbBackupPath;
//   dynamic transactionYear;
//
//   GetAllCompanyModel({
//     required this.companyId,
//     required this.companyName,
//     required this.taxRegistrationNo,
//     required this.address,
//     required this.street,
//     required this.city,
//     required this.country,
//     required this.stateProvince,
//     required this.pincode,
//     required this.phone,
//     required this.mobile,
//     required this.fax,
//     required this.zoneNumber,
//     required this.crNo,
//     required this.buildingNumber,
//     required this.isActive,
//     required this.emailid,
//     required this.companyCode,
//     required this.companyLogo,
//     required this.companyType,
//     required this.fssai,
//     required this.bankAccountName,
//     required this.bankAccountNumber,
//     required this.bankIfscCode,
//     required this.bankBranch,
//     required this.isTaxEnabled,
//     required this.dbBackupPath,
//     required this.transactionYear,
//   });
//
//   GetAllCompanyModel copyWith({
//     int? companyId,
//     String? companyName,
//     String? taxRegistrationNo,
//     String? address,
//     String? street,
//     String? city,
//     String? country,
//     String? stateProvince,
//     String? pincode,
//     String? phone,
//     String? mobile,
//     String? fax,
//     String? zoneNumber,
//     String? crNo,
//     String? buildingNumber,
//     String? isActive,
//     String? emailid,
//     String? companyCode,
//     String? companyLogo,
//     String? companyType,
//     String? fssai,
//     String? bankAccountName,
//     String? bankAccountNumber,
//     String? bankIfscCode,
//     String? bankBranch,
//     String? isTaxEnabled,
//     String? dbBackupPath,
//     dynamic transactionYear,
//   }) =>
//       GetAllCompanyModel(
//         companyId: companyId ?? this.companyId,
//         companyName: companyName ?? this.companyName,
//         taxRegistrationNo: taxRegistrationNo ?? this.taxRegistrationNo,
//         address: address ?? this.address,
//         street: street ?? this.street,
//         city: city ?? this.city,
//         country: country ?? this.country,
//         stateProvince: stateProvince ?? this.stateProvince,
//         pincode: pincode ?? this.pincode,
//         phone: phone ?? this.phone,
//         mobile: mobile ?? this.mobile,
//         fax: fax ?? this.fax,
//         zoneNumber: zoneNumber ?? this.zoneNumber,
//         crNo: crNo ?? this.crNo,
//         buildingNumber: buildingNumber ?? this.buildingNumber,
//         isActive: isActive ?? this.isActive,
//         emailid: emailid ?? this.emailid,
//         companyCode: companyCode ?? this.companyCode,
//         companyLogo: companyLogo ?? this.companyLogo,
//         companyType: companyType ?? this.companyType,
//         fssai: fssai ?? this.fssai,
//         bankAccountName: bankAccountName ?? this.bankAccountName,
//         bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
//         bankIfscCode: bankIfscCode ?? this.bankIfscCode,
//         bankBranch: bankBranch ?? this.bankBranch,
//         isTaxEnabled: isTaxEnabled ?? this.isTaxEnabled,
//         dbBackupPath: dbBackupPath ?? this.dbBackupPath,
//         transactionYear: transactionYear ?? this.transactionYear,
//       );
//
//   factory GetAllCompanyModel.fromJson(Map<String, dynamic> json) => GetAllCompanyModel(
//     companyId: json["companyId"],
//     companyName: json["companyName"],
//     taxRegistrationNo: json["taxRegistrationNo"],
//     address: json["address"],
//     street: json["street"],
//     city: json["city"],
//     country: json["country"],
//     stateProvince: json["stateProvince"],
//     pincode: json["pincode"],
//     phone: json["phone"],
//     mobile: json["mobile"],
//     fax: json["fax"],
//     zoneNumber: json["zoneNumber"],
//     crNo: json["crNo"],
//     buildingNumber: json["buildingNumber"],
//     isActive: json["isActive"],
//     emailid: json["emailid"],
//     companyCode: json["companyCode"],
//     companyLogo: json["companyLogo"],
//     companyType: json["companyType"],
//     fssai: json["fssai"],
//     bankAccountName: json["bankAccountName"],
//     bankAccountNumber: json["bankAccountNumber"],
//     bankIfscCode: json["bankIfscCode"],
//     bankBranch: json["bankBranch"],
//     isTaxEnabled: json["isTaxEnabled"],
//     dbBackupPath: json["dbBackupPath"],
//     transactionYear: json["transactionYear"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "companyId": companyId,
//     "companyName": companyName,
//     "taxRegistrationNo": taxRegistrationNo,
//     "address": address,
//     "street": street,
//     "city": city,
//     "country": country,
//     "stateProvince": stateProvince,
//     "pincode": pincode,
//     "phone": phone,
//     "mobile": mobile,
//     "fax": fax,
//     "zoneNumber": zoneNumber,
//     "crNo": crNo,
//     "buildingNumber": buildingNumber,
//     "isActive": isActive,
//     "emailid": emailid,
//     "companyCode": companyCode,
//     "companyLogo": companyLogo,
//     "companyType": companyType,
//     "fssai": fssai,
//     "bankAccountName": bankAccountName,
//     "bankAccountNumber": bankAccountNumber,
//     "bankIfscCode": bankIfscCode,
//     "bankBranch": bankBranch,
//     "isTaxEnabled": isTaxEnabled,
//     "dbBackupPath": dbBackupPath,
//     "transactionYear": transactionYear,
//   };
// }

// To parse this JSON data, do
//
//     final getAllCompanyModel = getAllCompanyModelFromJson(jsonString);

import 'dart:convert';

List<GetAllCompanyModel> getAllCompanyModelFromJson(String str) => List<GetAllCompanyModel>.from(json.decode(str).map((x) => GetAllCompanyModel.fromJson(x)));

String getAllCompanyModelToJson(List<GetAllCompanyModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllCompanyModel {
  int companyId;
  String companyName;
  String taxRegistrationNo;
  String address;
  String street;
  String city;
  String country;
  String stateProvince;
  String pincode;
  String phone;
  String mobile;
  String fax;
  String zoneNumber;
  String crNo;
  String buildingNumber;
  String isActive;
  String emailid;
  String companyCode;
  String companyLogo;
  String companyType;
  String fssai;
  String bankAccountName;
  String bankAccountNumber;
  String bankIfscCode;
  String bankBranch;
  String isTaxEnabled;
  String dbBackupPath;
  //dynamic transactionYear;
  String upiId;

  GetAllCompanyModel({
    required this.companyId,
    required this.companyName,
    required this.taxRegistrationNo,
    required this.address,
    required this.street,
    required this.city,
    required this.country,
    required this.stateProvince,
    required this.pincode,
    required this.phone,
    required this.mobile,
    required this.fax,
    required this.zoneNumber,
    required this.crNo,
    required this.buildingNumber,
    required this.isActive,
    required this.emailid,
    required this.companyCode,
    required this.companyLogo,
    required this.companyType,
    required this.fssai,
    required this.bankAccountName,
    required this.bankAccountNumber,
    required this.bankIfscCode,
    required this.bankBranch,
    required this.isTaxEnabled,
    required this.dbBackupPath,
    //required this.transactionYear,
    required this.upiId,
  });

  factory GetAllCompanyModel.fromJson(Map<String, dynamic> json) => GetAllCompanyModel(
    companyId: json["companyId"],
    companyName: json["companyName"],
    taxRegistrationNo: json["taxRegistrationNo"],
    address: json["address"],
    street: json["street"],
    city: json["city"],
    country: json["country"],
    stateProvince: json["stateProvince"],
    pincode: json["pincode"],
    phone: json["phone"],
    mobile: json["mobile"],
    fax: json["fax"],
    zoneNumber: json["zoneNumber"],
    crNo: json["crNo"],
    buildingNumber: json["buildingNumber"],
    isActive: json["isActive"],
    emailid: json["emailid"],
    companyCode: json["companyCode"],
    companyLogo: json["companyLogo"],
    companyType: json["companyType"],
    fssai: json["fssai"],
    bankAccountName: json["bankAccountName"],
    bankAccountNumber: json["bankAccountNumber"],
    bankIfscCode: json["bankIfscCode"],
    bankBranch: json["bankBranch"],
    isTaxEnabled: json["isTaxEnabled"],
    dbBackupPath: json["dbBackupPath"],
    //transactionYear: json["transactionYear"],
    upiId: json["upiId"],
  );

  Map<String, dynamic> toJson() => {
    "companyId": companyId,
    "companyName": companyName,
    "taxRegistrationNo": taxRegistrationNo,
    "address": address,
    "street": street,
    "city": city,
    "country": country,
    "stateProvince": stateProvince,
    "pincode": pincode,
    "phone": phone,
    "mobile": mobile,
    "fax": fax,
    "zoneNumber": zoneNumber,
    "crNo": crNo,
    "buildingNumber": buildingNumber,
    "isActive": isActive,
    "emailid": emailid,
    "companyCode": companyCode,
    "companyLogo": companyLogo,
    "companyType": companyType,
    "fssai": fssai,
    "bankAccountName": bankAccountName,
    "bankAccountNumber": bankAccountNumber,
    "bankIfscCode": bankIfscCode,
    "bankBranch": bankBranch,
    "isTaxEnabled": isTaxEnabled,
    "dbBackupPath": dbBackupPath,
    //"transactionYear": transactionYear,
    "upiId": upiId,
  };
}
