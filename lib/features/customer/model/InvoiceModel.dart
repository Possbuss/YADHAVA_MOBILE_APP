// // class InvoiceModel {
// //   final int invoiceId;
// //   final int branchId;
// //   final String branchName;
// //   final String invoiceNo;
// //   final String invoiceDate;
// //   final int salesManId;
// //   final String salesManName;
// //   final int customerAccountId;
// //   final String customerAccountName;
// //   final String invoiceType;
// //   final double netTotal;
// //   final MobileAppSalesInvoice? mobileAppSalesInvoice;
// //
// //   InvoiceModel({
// //     required this.invoiceId,
// //     required this.branchId,
// //     required this.branchName,
// //     required this.invoiceNo,
// //     required this.invoiceDate,
// //     required this.salesManId,
// //     required this.salesManName,
// //     required this.customerAccountId,
// //     required this.customerAccountName,
// //     required this.invoiceType,
// //     required this.netTotal,
// //     this.mobileAppSalesInvoice,
// //   });
// //
// //   factory InvoiceModel.fromJson(Map<String, dynamic> json) {
// //     return InvoiceModel(
// //       invoiceId: json['invoiceId'] ?? 0,
// //       branchId: json['branchId'] ?? 0,
// //       branchName: json['branchName'] ?? "Unknown",
// //       invoiceNo: json['invoiceNo'] ?? "N/A",
// //       invoiceDate: json['invoiceDate'] ?? "0000-00-00",
// //       salesManId: json['salesManId'] ?? 0,
// //       salesManName: json['salesManName'] ?? "No Name",
// //       customerAccountId: json['customerAccountId'] ?? 0,
// //       customerAccountName: json['customerAccountName'] ?? "Unknown",
// //       invoiceType: json['invoiceType'] ?? "Unknown",
// //       netTotal: (json['netTotal'] as num?)?.toDouble() ?? 0.0,
// //       mobileAppSalesInvoice: json['mobileAppSalesInvoice'] != null
// //           ? MobileAppSalesInvoice.fromJson(json['mobileAppSalesInvoice'])
// //           : null,
// //     );
// //   }
// //
// //   static List<InvoiceModel> fromJsonList(List<dynamic> jsonList) {
// //     return jsonList.map((json) => InvoiceModel.fromJson(json)).toList();
// //   }
// // }
// //
// // // class MobileAppSalesInvoice {
// // //   final int companyId;
// // //   final int invoiceId;
// // //   final int clientId;
// // //   final String clientName;
// // //   final int driverId;
// // //   final String driverName;
// // //   final String payType;
// // //   final String invoiceNo;
// // //   final String invoiceDate;
// // //   final int routeId;
// // //   final int vehicleId;
// // //   final String vehicleNo;
// // //   final double netTotal;
// // //   final List<MobileAppSalesInvoiceDetails> details;
// // //
// // //   MobileAppSalesInvoice({
// // //     required this.companyId,
// // //     required this.invoiceId,
// // //     required this.clientId,
// // //     required this.clientName,
// // //     required this.driverId,
// // //     required this.driverName,
// // //     required this.payType,
// // //     required this.invoiceNo,
// // //     required this.invoiceDate,
// // //     required this.routeId,
// // //     required this.vehicleId,
// // //     required this.vehicleNo,
// // //     required this.netTotal,
// // //     required this.details,
// // //   });
// // //
// // //   factory MobileAppSalesInvoice.fromJson(Map<String, dynamic> json) {
// // //     return MobileAppSalesInvoice(
// // //       companyId: json['companyId'] ?? 0,
// // //       invoiceId: json['invoiceId'] ?? 0,
// // //       clientId: json['clientId'] ?? 0,
// // //       clientName: json['clientName'] ?? "Unknown",
// // //       driverId: json['driverId'] ?? 0,
// // //       driverName: json['driverName'] ?? "No Name",
// // //       payType: json['payType'] ?? "Unknown",
// // //       invoiceNo: json['invoiceNo'] ?? "N/A",
// // //       invoiceDate: json['invoiceDate'] ?? "0000-00-00",
// // //       routeId: json['routeId'] ?? 0,
// // //       vehicleId: json['vehicleId'] ?? 0,
// // //       vehicleNo: json['vehicleNo'] ?? "Unknown",
// // //       netTotal: (json['netTotal'] as num?)?.toDouble() ?? 0.0,
// // //       details: (json['mobileAppSalesInvoiceDetails'] as List<dynamic>?)
// // //           ?.map((e) => MobileAppSalesInvoiceDetails.fromJson(e))
// // //           .toList() ??
// // //           [],
// // //     );
// // //   }
// // // }
// // class MobileAppSalesInvoice {
// //   final int companyId;
// //   final int invoiceId;
// //   final int clientId;
// //   final String clientName;
// //   final int driverId;
// //   final String driverName;
// //   final String payType;
// //   final String invoiceNo;
// //   final String invoiceDate;
// //   final int routeId;
// //   final int vehicleId;
// //   final String vehicleNo;
// //   final int total;
// //  final  int discountPercentage;
// //  final  int discountAmount;
// //  final  int transactionYear;
// //   dynamic latitude;
// //   dynamic longitude;
// //   final double netTotal;
// //   final List<MobileAppSalesInvoiceDetails> details;
// //
// //   MobileAppSalesInvoice( {
// //     required this.total,
// //     required this.discountPercentage,
// //     required this.discountAmount,
// //     required this.transactionYear,
// //     required this.companyId,
// //     required this.invoiceId,
// //     required this.clientId,
// //     required this.clientName,
// //     required this.driverId,
// //     required this.driverName,
// //     required this.payType,
// //     required this.invoiceNo,
// //     required this.invoiceDate,
// //     required this.routeId,
// //     required this.vehicleId,
// //     required this.vehicleNo,
// //     required this.netTotal,
// //     required this.details,
// //     dynamic latitude,
// //     dynamic longitude,
// //   });
// //
// //   factory MobileAppSalesInvoice.fromJson(Map<String, dynamic> json) {
// //     return MobileAppSalesInvoice(
// //       companyId: json['companyId'] ?? 0,
// //       invoiceId: json['invoiceId'] ?? 0,
// //       clientId: json['clientId'] ?? 0,
// //       clientName: json['clientName'] ?? "Unknown",
// //       driverId: json['driverId'] ?? 0,
// //       driverName: json['driverName'] ?? "No Name",
// //       payType: json['payType'] ?? "Unknown",
// //       invoiceNo: json['invoiceNo'] ?? "N/A",
// //       invoiceDate: json['invoiceDate'] ?? "0000-00-00",
// //       routeId: json['routeId'] ?? 0,
// //       vehicleId: json['vehicleId'] ?? 0,
// //       vehicleNo: json['vehicleNo'] ?? "Unknown",
// //     total: json["total"] ?? 0,
// //     discountPercentage: json["discountPercentage"] ?? 0,
// //     discountAmount: json["discountAmount"] ?? 0,
// //     transactionYear: json["transactionYear"] ?? 0000,
// //         latitude: json["latitude"],
// //     longitude: json["longitude"],
// //         netTotal: (json['netTotal'] as num?)?.toDouble() ?? 0.0,
// //       details: (json['mobileAppSalesInvoiceDetails'] as List<dynamic>?)
// //           ?.map((e) => MobileAppSalesInvoiceDetails.fromJson(e))
// //           .toList() ??[]
// //     );
// //   }
// //
// //   MobileAppSalesInvoice copyWith({
// //     int? companyId,
// //     int? invoiceId,
// //     int? clientId,
// //     String? clientName,
// //     int? driverId,
// //     String? driverName,
// //     String? payType,
// //     String? invoiceNo,
// //     String? invoiceDate,
// //     int? routeId,
// //     int? vehicleId,
// //     String? vehicleNo,
// //     double? netTotal,
// //     int? total,
// //     int? discountPercentage,
// //     int? discountAmount,
// //     int? transactionYear,
// //     dynamic latitude,
// //     dynamic longitude,
// //     List<MobileAppSalesInvoiceDetails>? details,
// //   }) {
// //     return MobileAppSalesInvoice(
// //       companyId: companyId ?? this.companyId,
// //       invoiceId: invoiceId ?? this.invoiceId,
// //       clientId: clientId ?? this.clientId,
// //       clientName: clientName ?? this.clientName,
// //       driverId: driverId ?? this.driverId,
// //       driverName: driverName ?? this.driverName,
// //       payType: payType ?? this.payType,
// //       invoiceNo: invoiceNo ?? this.invoiceNo,
// //       invoiceDate: invoiceDate ?? this.invoiceDate,
// //       routeId: routeId ?? this.routeId,
// //       vehicleId: vehicleId ?? this.vehicleId,
// //       vehicleNo: vehicleNo ?? this.vehicleNo,
// //       netTotal: netTotal ?? this.netTotal,
// //       details: details ?? this.details,
// //       total: total ?? this.total,
// //         discountPercentage: discountPercentage ?? this.discountPercentage,
// //         discountAmount: discountAmount ?? this.discountAmount,
// //         transactionYear: transactionYear ?? this.transactionYear,
// //         latitude: latitude ?? this.latitude,
// //         longitude: longitude ?? this.longitude,
// //     );
// //   }
// // }
// //
// // // class MobileAppSalesInvoiceDetails {
// // //   final int siNo;
// // //   final int productId;
// // //   final String partNumber;
// // //   final String productName;
// // //   final String packingDescription;
// // //   final int packingId;
// // //   final String packingName;
// // //   final double quantity;
// // //   final double foc;
// // //   final double totalQty;
// // //   final double unitRate;
// // //   final double totalRate;
// // //
// // //   MobileAppSalesInvoiceDetails({
// // //     required this.siNo,
// // //     required this.productId,
// // //     required this.partNumber,
// // //     required this.productName,
// // //     required this.packingDescription,
// // //     required this.packingId,
// // //     required this.packingName,
// // //     required this.quantity,
// // //     required this.foc,
// // //     required this.totalQty,
// // //     required this.unitRate,
// // //     required this.totalRate,
// // //   });
// // //
// // //   factory MobileAppSalesInvoiceDetails.fromJson(Map<String, dynamic> json) {
// // //     return MobileAppSalesInvoiceDetails(
// // //       siNo: json['siNo'] ?? 0,
// // //       productId: json['productId'] ?? 0,
// // //       partNumber: json['partNumber'] ?? "Unknown",
// // //       productName: json['productName'] ?? "Unknown",
// // //       packingDescription: json['packingDescription'] ?? "Unknown",
// // //       packingId: json['packingId'] ?? 0,
// // //       packingName: json['packingName'] ?? "Unknown",
// // //       quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
// // //       foc: (json['foc'] as num?)?.toDouble() ?? 0.0,
// // //       totalQty: (json['totalQty'] as num?)?.toDouble() ?? 0.0,
// // //       unitRate: (json['unitRate'] as num?)?.toDouble() ?? 0.0,
// // //       totalRate: (json['totalRate'] as num?)?.toDouble() ?? 0.0,
// // //     );
// // //   }
// // // }
// // class MobileAppSalesInvoiceDetails {
// //   final int siNo;
// //   final int productId;
// //   final String partNumber;
// //   final String productName;
// //   final String packingDescription;
// //   final int packingId;
// //   final String packingName;
// //   final double quantity;
// //   final double foc;
// //   final double totalQty;
// //   final double unitRate;
// //   final double totalRate;
// //   final double srtQty;
// //
// //
// //   MobileAppSalesInvoiceDetails({
// //     required this.siNo,
// //     required this.productId,
// //     required this.partNumber,
// //     required this.productName,
// //     required this.packingDescription,
// //     required this.packingId,
// //     required this.packingName,
// //     required this.quantity,
// //     required this.foc,
// //     required this.totalQty,
// //     required this.unitRate,
// //     required this.totalRate,
// //     required this.srtQty,
// //   });
// //
// //   factory MobileAppSalesInvoiceDetails.fromJson(Map<String, dynamic> json) {
// //     return MobileAppSalesInvoiceDetails(
// //       siNo: json['siNo'] ?? 0,
// //       productId: json['productId'] ?? 0,
// //       partNumber: json['partNumber'] ?? "Unknown",
// //       productName: json['productName'] ?? "Unknown",
// //       packingDescription: json['packingDescription'] ?? "Unknown",
// //       packingId: json['packingId'] ?? 0,
// //       packingName: json['packingName'] ?? "Unknown",
// //       quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
// //       srtQty: json["srtQty"] ?? 0,
// //
// //       foc: (json['foc'] as num?)?.toDouble() ?? 0.0,
// //       totalQty: (json['totalQty'] as num?)?.toDouble() ?? 0.0,
// //       unitRate: (json['unitRate'] as num?)?.toDouble() ?? 0.0,
// //       totalRate: (json['totalRate'] as num?)?.toDouble() ?? 0.0,
// //     );
// //   }
// //
// //   MobileAppSalesInvoiceDetails copyWith({
// //     int? siNo,
// //     int? productId,
// //     String? partNumber,
// //     String? productName,
// //     String? packingDescription,
// //     int? packingId,
// //     String? packingName,
// //     double? quantity,
// //     double? foc,
// //     double? totalQty,
// //     double? unitRate,
// //     double? totalRate,
// //     double? srtQty,
// //
// //   }) {
// //     return MobileAppSalesInvoiceDetails(
// //       siNo: siNo ?? this.siNo,
// //       productId: productId ?? this.productId,
// //       partNumber: partNumber ?? this.partNumber,
// //       productName: productName ?? this.productName,
// //       packingDescription: packingDescription ?? this.packingDescription,
// //       packingId: packingId ?? this.packingId,
// //       packingName: packingName ?? this.packingName,
// //       quantity: quantity ?? this.quantity,
// //       srtQty: srtQty ?? this.srtQty,
// //       foc: foc ?? this.foc,
// //       totalQty: totalQty ?? this.totalQty,
// //       unitRate: unitRate ?? this.unitRate,
// //       totalRate: totalRate ?? this.totalRate,
// //     );
// //   }
// // }
// // // }
// // // To parse this JSON data, do
// // //
// // //     final invoiceModel = invoiceModelFromJson(jsonString);
// // //
// // // import 'dart:convert';
// // //
// // // List<InvoiceModel> invoiceModelFromJson(String str) => List<InvoiceModel>.from(json.decode(str).map((x) => InvoiceModel.fromJson(x)));
// // //
// // // String invoiceModelToJson(List<InvoiceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
// // //
// // // class InvoiceModel {
// // //   int invoiceId;
// // //   int branchId;
// // //   String branchName;
// // //   String invoiceNo;
// // //   String invoiceDate;
// // //   int salesManId;
// // //   String salesManName;
// // //   int customerAccountId;
// // //   String customerAccountName;
// // //   String invoiceType;
// // //   int netTotal;
// // //   MobileAppSalesInvoice mobileAppSalesInvoice;
// // //
// // //   InvoiceModel({
// // //     required this.invoiceId,
// // //     required this.branchId,
// // //     required this.branchName,
// // //     required this.invoiceNo,
// // //     required this.invoiceDate,
// // //     required this.salesManId,
// // //     required this.salesManName,
// // //     required this.customerAccountId,
// // //     required this.customerAccountName,
// // //     required this.invoiceType,
// // //     required this.netTotal,
// // //     required this.mobileAppSalesInvoice,
// // //   });
// // //
// // //   InvoiceModel copyWith({
// // //     int? invoiceId,
// // //     int? branchId,
// // //     String? branchName,
// // //     String? invoiceNo,
// // //     String? invoiceDate,
// // //     int? salesManId,
// // //     String? salesManName,
// // //     int? customerAccountId,
// // //     String? customerAccountName,
// // //     String? invoiceType,
// // //     int? netTotal,
// // //     MobileAppSalesInvoice? mobileAppSalesInvoice,
// // //   }) =>
// // //       InvoiceModel(
// // //         invoiceId: invoiceId ?? this.invoiceId,
// // //         branchId: branchId ?? this.branchId,
// // //         branchName: branchName ?? this.branchName,
// // //         invoiceNo: invoiceNo ?? this.invoiceNo,
// // //         invoiceDate: invoiceDate ?? this.invoiceDate,
// // //         salesManId: salesManId ?? this.salesManId,
// // //         salesManName: salesManName ?? this.salesManName,
// // //         customerAccountId: customerAccountId ?? this.customerAccountId,
// // //         customerAccountName: customerAccountName ?? this.customerAccountName,
// // //         invoiceType: invoiceType ?? this.invoiceType,
// // //         netTotal: netTotal ?? this.netTotal,
// // //         mobileAppSalesInvoice: mobileAppSalesInvoice ?? this.mobileAppSalesInvoice,
// // //       );
// // //
// // //   factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
// // //     invoiceId: json["invoiceId"],
// // //     branchId: json["branchId"],
// // //     branchName: json["branchName"],
// // //     invoiceNo: json["invoiceNo"],
// // //     invoiceDate: json["invoiceDate"],
// // //     salesManId: json["salesManId"],
// // //     salesManName: json["salesManName"],
// // //     customerAccountId: json["customerAccountId"],
// // //     customerAccountName: json["customerAccountName"],
// // //     invoiceType: json["invoiceType"],
// // //     netTotal: json["netTotal"],
// // //     mobileAppSalesInvoice: MobileAppSalesInvoice.fromJson(json["mobileAppSalesInvoice"]),
// // //   );
// // //
// // //   Map<String, dynamic> toJson() => {
// // //     "invoiceId": invoiceId,
// // //     "branchId": branchId,
// // //     "branchName": branchName,
// // //     "invoiceNo": invoiceNo,
// // //     "invoiceDate": invoiceDate,
// // //     "salesManId": salesManId,
// // //     "salesManName": salesManName,
// // //     "customerAccountId": customerAccountId,
// // //     "customerAccountName": customerAccountName,
// // //     "invoiceType": invoiceType,
// // //     "netTotal": netTotal,
// // //     "mobileAppSalesInvoice": mobileAppSalesInvoice.toJson(),
// // //   };
// // // }
// // //
// // // class MobileAppSalesInvoice {
// // //   int companyId;
// // //   int invoiceId;
// // //   int clientId;
// // //   String clientName;
// // //   int driverId;
// // //   String driverName;
// // //   String payType;
// // //   String invoiceNo;
// // //   String invoiceDate;
// // //   int routeId;
// // //   int vehicleId;
// // //   String vehicleNo;
// // //   int total;
// // //   int discountPercentage;
// // //   int discountAmount;
// // //   int netTotal;
// // //   int transactionYear;
// // //   dynamic latitude;
// // //   dynamic longitude;
// // //   List<MobileAppSalesInvoiceDetail> mobileAppSalesInvoiceDetails;
// // //
// // //   MobileAppSalesInvoice({
// // //     required this.companyId,
// // //     required this.invoiceId,
// // //     required this.clientId,
// // //     required this.clientName,
// // //     required this.driverId,
// // //     required this.driverName,
// // //     required this.payType,
// // //     required this.invoiceNo,
// // //     required this.invoiceDate,
// // //     required this.routeId,
// // //     required this.vehicleId,
// // //     required this.vehicleNo,
// // //     required this.total,
// // //     required this.discountPercentage,
// // //     required this.discountAmount,
// // //     required this.netTotal,
// // //     required this.transactionYear,
// // //     required this.latitude,
// // //     required this.longitude,
// // //     required this.mobileAppSalesInvoiceDetails,
// // //   });
// // //
// // //   MobileAppSalesInvoice copyWith({
// // //     int? companyId,
// // //     int? invoiceId,
// // //     int? clientId,
// // //     String? clientName,
// // //     int? driverId,
// // //     String? driverName,
// // //     String? payType,
// // //     String? invoiceNo,
// // //     String? invoiceDate,
// // //     int? routeId,
// // //     int? vehicleId,
// // //     String? vehicleNo,
// // //     int? total,
// // //     int? discountPercentage,
// // //     int? discountAmount,
// // //     int? netTotal,
// // //     int? transactionYear,
// // //     dynamic latitude,
// // //     dynamic longitude,
// // //     List<MobileAppSalesInvoiceDetail>? mobileAppSalesInvoiceDetails,
// // //   }) =>
// // //       MobileAppSalesInvoice(
// // //         companyId: companyId ?? this.companyId,
// // //         invoiceId: invoiceId ?? this.invoiceId,
// // //         clientId: clientId ?? this.clientId,
// // //         clientName: clientName ?? this.clientName,
// // //         driverId: driverId ?? this.driverId,
// // //         driverName: driverName ?? this.driverName,
// // //         payType: payType ?? this.payType,
// // //         invoiceNo: invoiceNo ?? this.invoiceNo,
// // //         invoiceDate: invoiceDate ?? this.invoiceDate,
// // //         routeId: routeId ?? this.routeId,
// // //         vehicleId: vehicleId ?? this.vehicleId,
// // //         vehicleNo: vehicleNo ?? this.vehicleNo,
// // //         total: total ?? this.total,
// // //         discountPercentage: discountPercentage ?? this.discountPercentage,
// // //         discountAmount: discountAmount ?? this.discountAmount,
// // //         netTotal: netTotal ?? this.netTotal,
// // //         transactionYear: transactionYear ?? this.transactionYear,
// // //         latitude: latitude ?? this.latitude,
// // //         longitude: longitude ?? this.longitude,
// // //         mobileAppSalesInvoiceDetails: mobileAppSalesInvoiceDetails ?? this.mobileAppSalesInvoiceDetails,
// // //       );
// // //
// // //   factory MobileAppSalesInvoice.fromJson(Map<String, dynamic> json) => MobileAppSalesInvoice(
// // //     companyId: json["companyId"],
// // //     invoiceId: json["invoiceId"],
// // //     clientId: json["clientId"],
// // //     clientName: json["clientName"],
// // //     driverId: json["driverId"],
// // //     driverName: json["driverName"],
// // //     payType: json["payType"],
// // //     invoiceNo: json["invoiceNo"],
// // //     invoiceDate: json["invoiceDate"],
// // //     routeId: json["routeId"],
// // //     vehicleId: json["vehicleId"],
// // //     vehicleNo: json["vehicleNo"],
// // //     total: json["total"],
// // //     discountPercentage: json["discountPercentage"],
// // //     discountAmount: json["discountAmount"],
// // //     netTotal: json["netTotal"],
// // //     transactionYear: json["transactionYear"],
// // //     latitude: json["latitude"],
// // //     longitude: json["longitude"],
// // //     mobileAppSalesInvoiceDetails: List<MobileAppSalesInvoiceDetail>.from(json["mobileAppSalesInvoiceDetails"].map((x) => MobileAppSalesInvoiceDetail.fromJson(x))),
// // //   );
// // //
// // //   Map<String, dynamic> toJson() => {
// // //     "companyId": companyId,
// // //     "invoiceId": invoiceId,
// // //     "clientId": clientId,
// // //     "clientName": clientName,
// // //     "driverId": driverId,
// // //     "driverName": driverName,
// // //     "payType": payType,
// // //     "invoiceNo": invoiceNo,
// // //     "invoiceDate": invoiceDate,
// // //     "routeId": routeId,
// // //     "vehicleId": vehicleId,
// // //     "vehicleNo": vehicleNo,
// // //     "total": total,
// // //     "discountPercentage": discountPercentage,
// // //     "discountAmount": discountAmount,
// // //     "netTotal": netTotal,
// // //     "transactionYear": transactionYear,
// // //     "latitude": latitude,
// // //     "longitude": longitude,
// // //     "mobileAppSalesInvoiceDetails": List<dynamic>.from(mobileAppSalesInvoiceDetails.map((x) => x.toJson())),
// // //   };
// // // }
// // //
// // // class MobileAppSalesInvoiceDetail {
// // //   int siNo;
// // //   int productId;
// // //   String partNumber;
// // //   String productName;
// // //   String packingDescription;
// // //   int packingId;
// // //   String packingName;
// // //   int quantity;
// // //   int foc;
// // //   int totalQty;
// // //   int srtQty;
// // //   int unitRate;
// // //   int totalRate;
// // //
// // //   MobileAppSalesInvoiceDetail({
// // //     required this.siNo,
// // //     required this.productId,
// // //     required this.partNumber,
// // //     required this.productName,
// // //     required this.packingDescription,
// // //     required this.packingId,
// // //     required this.packingName,
// // //     required this.quantity,
// // //     required this.foc,
// // //     required this.totalQty,
// // //     required this.srtQty,
// // //     required this.unitRate,
// // //     required this.totalRate,
// // //   });
// // //
// // //   MobileAppSalesInvoiceDetail copyWith({
// // //     int? siNo,
// // //     int? productId,
// // //     String? partNumber,
// // //     String? productName,
// // //     String? packingDescription,
// // //     int? packingId,
// // //     String? packingName,
// // //     int? quantity,
// // //     int? foc,
// // //     int? totalQty,
// // //     int? srtQty,
// // //     int? unitRate,
// // //     int? totalRate,
// // //   }) =>
// // //       MobileAppSalesInvoiceDetail(
// // //         siNo: siNo ?? this.siNo,
// // //         productId: productId ?? this.productId,
// // //         partNumber: partNumber ?? this.partNumber,
// // //         productName: productName ?? this.productName,
// // //         packingDescription: packingDescription ?? this.packingDescription,
// // //         packingId: packingId ?? this.packingId,
// // //         packingName: packingName ?? this.packingName,
// // //         quantity: quantity ?? this.quantity,
// // //         foc: foc ?? this.foc,
// // //         totalQty: totalQty ?? this.totalQty,
// // //         srtQty: srtQty ?? this.srtQty,
// // //         unitRate: unitRate ?? this.unitRate,
// // //         totalRate: totalRate ?? this.totalRate,
// // //       );
// // //
// // //   factory MobileAppSalesInvoiceDetail.fromJson(Map<String, dynamic> json) => MobileAppSalesInvoiceDetail(
// // //     siNo: json["siNo"],
// // //     productId: json["productId"],
// // //     partNumber: json["partNumber"],
// // //     productName: json["productName"],
// // //     packingDescription: json["packingDescription"],
// // //     packingId: json["packingId"],
// // //     packingName: json["packingName"],
// // //     quantity: json["quantity"],
// // //     foc: json["foc"],
// // //     totalQty: json["totalQty"],
// // //     srtQty: json["srtQty"],
// // //     unitRate: json["unitRate"],
// // //     totalRate: json["totalRate"],
// // //   );
// // //
// // //   Map<String, dynamic> toJson() => {
// // //     "siNo": siNo,
// // //     "productId": productId,
// // //     "partNumber": partNumber,
// // //     "productName": productName,
// // //     "packingDescription": packingDescription,
// // //     "packingId": packingId,
// // //     "packingName": packingName,
// // //     "quantity": quantity,
// // //     "foc": foc,
// // //     "totalQty": totalQty,
// // //     "srtQty": srtQty,
// // //     "unitRate": unitRate,
// // //     "totalRate": totalRate,
// // //   };
// // // }
//
//
// import 'dart:convert';
//
// /// Converts a JSON string into a list of [InvoiceModel].
// List<InvoiceModel> invoiceModelFromJson(String str) =>
//     List<InvoiceModel>.from(json.decode(str).map((x) => InvoiceModel.fromJson(x)));
//
// /// Converts a list of [InvoiceModel] back into a JSON string.
// String invoiceModelToJson(List<InvoiceModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class InvoiceModel {
//   final int invoiceId;
//   final int branchId;
//   final String branchName;
//   final String invoiceNo;
//   final String invoiceDate;
//   final int salesManId;
//   final String salesManName;
//   final int customerAccountId;
//   final String customerAccountName;
//   final String invoiceType;
//   final double netTotal;
//   final MobileAppSalesInvoice mobileAppSalesInvoice;
//
//   InvoiceModel({
//     required this.invoiceId,
//     required this.branchId,
//     required this.branchName,
//     required this.invoiceNo,
//     required this.invoiceDate,
//     required this.salesManId,
//     required this.salesManName,
//     required this.customerAccountId,
//     required this.customerAccountName,
//     required this.invoiceType,
//     required this.netTotal,
//     required this.mobileAppSalesInvoice,
//   });
//
//   /// Parse from JSON
//   factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
//     invoiceId: json["invoiceId"] ?? 0,
//     branchId: json["branchId"] ?? 0,
//     branchName: json["branchName"] ?? "",
//     invoiceNo: json["invoiceNo"] ?? "",
//     invoiceDate: json["invoiceDate"] ?? "",
//     salesManId: json["salesManId"] ?? 0,
//     salesManName: json["salesManName"] ?? "",
//     customerAccountId: json["customerAccountId"] ?? 0,
//     customerAccountName: json["customerAccountName"] ?? "",
//     invoiceType: json["invoiceType"] ?? "",
//     netTotal: (json["netTotal"] as num?)?.toDouble() ?? 0.0,
//     mobileAppSalesInvoice: json["mobileAppSalesInvoice"] != null
//         ? MobileAppSalesInvoice.fromJson(json["mobileAppSalesInvoice"])
//         : MobileAppSalesInvoice(
//       companyId: 0,
//       invoiceId: 0,
//       clientId: 0,
//       clientName: "",
//       driverId: 0,
//       driverName: "",
//       payType: "",
//       invoiceNo: "",
//       invoiceDate: "",
//       routeId: 0,
//       vehicleId: 0,
//       vehicleNo: "",
//       total: 0,
//       discountPercentage: 0,
//       discountAmount: 0,
//       netTotal: 0.0,
//       transactionYear: 0,
//       latitude: 0.0,
//       longitude: 0.0,
//       mobileAppSalesInvoiceDetails: [],
//     ),
//   );
//
//   /// Convert to JSON
//   Map<String, dynamic> toJson() => {
//     "invoiceId": invoiceId,
//     "branchId": branchId,
//     "branchName": branchName,
//     "invoiceNo": invoiceNo,
//     "invoiceDate": invoiceDate,
//     "salesManId": salesManId,
//     "salesManName": salesManName,
//     "customerAccountId": customerAccountId,
//     "customerAccountName": customerAccountName,
//     "invoiceType": invoiceType,
//     "netTotal": netTotal,
//     "mobileAppSalesInvoice": mobileAppSalesInvoice.toJson(),
//   };
//
//   /// copyWith method for immutability
//   InvoiceModel copyWith({
//     int? invoiceId,
//     int? branchId,
//     String? branchName,
//     String? invoiceNo,
//     String? invoiceDate,
//     int? salesManId,
//     String? salesManName,
//     int? customerAccountId,
//     String? customerAccountName,
//     String? invoiceType,
//     double? netTotal,
//     MobileAppSalesInvoice? mobileAppSalesInvoice,
//   }) {
//     return InvoiceModel(
//       invoiceId: invoiceId ?? this.invoiceId,
//       branchId: branchId ?? this.branchId,
//       branchName: branchName ?? this.branchName,
//       invoiceNo: invoiceNo ?? this.invoiceNo,
//       invoiceDate: invoiceDate ?? this.invoiceDate,
//       salesManId: salesManId ?? this.salesManId,
//       salesManName: salesManName ?? this.salesManName,
//       customerAccountId: customerAccountId ?? this.customerAccountId,
//       customerAccountName: customerAccountName ?? this.customerAccountName,
//       invoiceType: invoiceType ?? this.invoiceType,
//       netTotal: netTotal ?? this.netTotal,
//       mobileAppSalesInvoice:
//       mobileAppSalesInvoice ?? this.mobileAppSalesInvoice,
//     );
//   }
// }
//
// class MobileAppSalesInvoice {
//   final int companyId;
//   final int invoiceId;
//   final int clientId;
//   final String clientName;
//   final int driverId;
//   final String driverName;
//   final String payType;
//   final String invoiceNo;
//   final String invoiceDate;
//   final int routeId;
//   final int vehicleId;
//   final String vehicleNo;
//   final int total;
//   final int discountPercentage;
//   final int discountAmount;
//   final double netTotal;
//   final int transactionYear;
//   final double latitude;
//   final double longitude;
//   final List<MobileAppSalesInvoiceDetail> mobileAppSalesInvoiceDetails;
//
//   MobileAppSalesInvoice({
//     required this.companyId,
//     required this.invoiceId,
//     required this.clientId,
//     required this.clientName,
//     required this.driverId,
//     required this.driverName,
//     required this.payType,
//     required this.invoiceNo,
//     required this.invoiceDate,
//     required this.routeId,
//     required this.vehicleId,
//     required this.vehicleNo,
//     required this.total,
//     required this.discountPercentage,
//     required this.discountAmount,
//     required this.netTotal,
//     required this.transactionYear,
//     required this.latitude,
//     required this.longitude,
//     required this.mobileAppSalesInvoiceDetails,
//   });
//
//   /// Parse from JSON
//   factory MobileAppSalesInvoice.fromJson(Map<String, dynamic> json) =>
//       MobileAppSalesInvoice(
//         companyId: json["companyId"] ?? 0,
//         invoiceId: json["invoiceId"] ?? 0,
//         clientId: json["clientId"] ?? 0,
//         clientName: json["clientName"] ?? "",
//         driverId: json["driverId"] ?? 0,
//         driverName: json["driverName"] ?? "",
//         payType: json["payType"] ?? "",
//         invoiceNo: json["invoiceNo"] ?? "",
//         invoiceDate: json["invoiceDate"] ?? "",
//         routeId: json["routeId"] ?? 0,
//         vehicleId: json["vehicleId"] ?? 0,
//         vehicleNo: json["vehicleNo"] ?? "",
//         total: json["total"] ?? 0,
//         discountPercentage: json["discountPercentage"] ?? 0,
//         discountAmount: json["discountAmount"] ?? 0,
//         netTotal: (json["netTotal"] as num?)?.toDouble() ?? 0.0,
//         transactionYear: json["transactionYear"] ?? 0,
//         latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
//         longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
//         mobileAppSalesInvoiceDetails:
//         (json["mobileAppSalesInvoiceDetails"] as List<dynamic>?)
//             ?.map((x) => MobileAppSalesInvoiceDetail.fromJson(x))
//             .toList() ??
//             [],
//       );
//
//   /// Convert to JSON
//   Map<String, dynamic> toJson() => {
//     "companyId": companyId,
//     "invoiceId": invoiceId,
//     "clientId": clientId,
//     "clientName": clientName,
//     "driverId": driverId,
//     "driverName": driverName,
//     "payType": payType,
//     "invoiceNo": invoiceNo,
//     "invoiceDate": invoiceDate,
//     "routeId": routeId,
//     "vehicleId": vehicleId,
//     "vehicleNo": vehicleNo,
//     "total": total,
//     "discountPercentage": discountPercentage,
//     "discountAmount": discountAmount,
//     "netTotal": netTotal,
//     "transactionYear": transactionYear,
//     "latitude": latitude,
//     "longitude": longitude,
//     "mobileAppSalesInvoiceDetails":
//     mobileAppSalesInvoiceDetails.map((x) => x.toJson()).toList(),
//   };
//
//   /// copyWith method
//   MobileAppSalesInvoice copyWith({
//     int? companyId,
//     int? invoiceId,
//     int? clientId,
//     String? clientName,
//     int? driverId,
//     String? driverName,
//     String? payType,
//     String? invoiceNo,
//     String? invoiceDate,
//     int? routeId,
//     int? vehicleId,
//     String? vehicleNo,
//     int? total,
//     int? discountPercentage,
//     int? discountAmount,
//     double? netTotal,
//     int? transactionYear,
//     double? latitude,
//     double? longitude,
//     List<MobileAppSalesInvoiceDetail>? mobileAppSalesInvoiceDetails,
//   }) {
//     return MobileAppSalesInvoice(
//       companyId: companyId ?? this.companyId,
//       invoiceId: invoiceId ?? this.invoiceId,
//       clientId: clientId ?? this.clientId,
//       clientName: clientName ?? this.clientName,
//       driverId: driverId ?? this.driverId,
//       driverName: driverName ?? this.driverName,
//       payType: payType ?? this.payType,
//       invoiceNo: invoiceNo ?? this.invoiceNo,
//       invoiceDate: invoiceDate ?? this.invoiceDate,
//       routeId: routeId ?? this.routeId,
//       vehicleId: vehicleId ?? this.vehicleId,
//       vehicleNo: vehicleNo ?? this.vehicleNo,
//       total: total ?? this.total,
//       discountPercentage: discountPercentage ?? this.discountPercentage,
//       discountAmount: discountAmount ?? this.discountAmount,
//       netTotal: netTotal ?? this.netTotal,
//       transactionYear: transactionYear ?? this.transactionYear,
//       latitude: latitude ?? this.latitude,
//       longitude: longitude ?? this.longitude,
//       mobileAppSalesInvoiceDetails:
//       mobileAppSalesInvoiceDetails ?? this.mobileAppSalesInvoiceDetails,
//     );
//   }
// }
//
// class MobileAppSalesInvoiceDetail {
//   final int siNo;
//   final int productId;
//   final String partNumber;
//   final String productName;
//   final String packingDescription;
//   final int packingId;
//   final String packingName;
//   final int quantity;
//   final int foc;
//   final int totalQty;
//   final int srtQty;
//   final int unitRate;
//   final int totalRate;
//
//   MobileAppSalesInvoiceDetail({
//     required this.siNo,
//     required this.productId,
//     required this.partNumber,
//     required this.productName,
//     required this.packingDescription,
//     required this.packingId,
//     required this.packingName,
//     required this.quantity,
//     required this.foc,
//     required this.totalQty,
//     required this.srtQty,
//     required this.unitRate,
//     required this.totalRate,
//   });
//
//   /// Parse from JSON
//   factory MobileAppSalesInvoiceDetail.fromJson(Map<String, dynamic> json) =>
//       MobileAppSalesInvoiceDetail(
//         siNo: json["siNo"] ?? 0,
//         productId: json["productId"] ?? 0,
//         partNumber: json["partNumber"] ?? "",
//         productName: json["productName"] ?? "",
//         packingDescription: json["packingDescription"] ?? "",
//         packingId: json["packingId"] ?? 0,
//         packingName: json["packingName"] ?? "",
//         quantity: json["quantity"] ?? 0,
//         foc: json["foc"] ?? 0,
//         totalQty: json["totalQty"] ?? 0,
//         srtQty: json["srtQty"] ?? 0,
//         unitRate: json["unitRate"] ?? 0,
//         totalRate: json["totalRate"] ?? 0,
//       );
//
//   /// Convert to JSON
//   Map<String, dynamic> toJson() => {
//     "siNo": siNo,
//     "productId": productId,
//     "partNumber": partNumber,
//     "productName": productName,
//     "packingDescription": packingDescription,
//     "packingId": packingId,
//     "packingName": packingName,
//     "quantity": quantity,
//     "foc": foc,
//     "totalQty": totalQty,
//     "srtQty": srtQty,
//     "unitRate": unitRate,
//     "totalRate": totalRate,
//   };
//
//   /// copyWith method
//   MobileAppSalesInvoiceDetail copyWith({
//     int? siNo,
//     int? productId,
//     String? partNumber,
//     String? productName,
//     String? packingDescription,
//     int? packingId,
//     String? packingName,
//     int? quantity,
//     int? foc,
//     int? totalQty,
//     int? srtQty,
//     int? unitRate,
//     int? totalRate,
//   }) {
//     return MobileAppSalesInvoiceDetail(
//       siNo: siNo ?? this.siNo,
//       productId: productId ?? this.productId,
//       partNumber: partNumber ?? this.partNumber,
//       productName: productName ?? this.productName,
//       packingDescription: packingDescription ?? this.packingDescription,
//       packingId: packingId ?? this.packingId,
//       packingName: packingName ?? this.packingName,
//       quantity: quantity ?? this.quantity,
//       foc: foc ?? this.foc,
//       totalQty: totalQty ?? this.totalQty,
//       srtQty: srtQty ?? this.srtQty,
//       unitRate: unitRate ?? this.unitRate,
//       totalRate: totalRate ?? this.totalRate,
//     );
//   }
// }
//
//
// //
// // import 'dart:convert';
// //
// // List<InvoiceModel> invoiceModelFromJson(String str) => List<InvoiceModel>.from(json.decode(str).map((x) => InvoiceModel.fromJson(x)));
// //
// // String invoiceModelToJson(List<InvoiceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
// //
// // class InvoiceModel {
// //   int invoiceId;
// //   int branchId;
// //   String branchName;
// //   String invoiceNo;
// //   String invoiceDate;
// //   int salesManId;
// //   String salesManName;
// //   int customerAccountId;
// //   String customerAccountName;
// //   String invoiceType;
// //   double netTotal;
// //   MobileAppSalesInvoice mobileAppSalesInvoice;
// //
// //   InvoiceModel({
// //     required this.invoiceId,
// //     required this.branchId,
// //     required this.branchName,
// //     required this.invoiceNo,
// //     required this.invoiceDate,
// //     required this.salesManId,
// //     required this.salesManName,
// //     required this.customerAccountId,
// //     required this.customerAccountName,
// //     required this.invoiceType,
// //     required this.netTotal,
// //     required this.mobileAppSalesInvoice,
// //   });
// //
// //   InvoiceModel copyWith({
// //     int? invoiceId,
// //     int? branchId,
// //     String? branchName,
// //     String? invoiceNo,
// //     String? invoiceDate,
// //     int? salesManId,
// //     String? salesManName,
// //     int? customerAccountId,
// //     String? customerAccountName,
// //     String? invoiceType,
// //     double? netTotal,
// //     MobileAppSalesInvoice? mobileAppSalesInvoice,
// //   }) =>
// //       InvoiceModel(
// //         invoiceId: invoiceId ?? this.invoiceId,
// //         branchId: branchId ?? this.branchId,
// //         branchName: branchName ?? this.branchName,
// //         invoiceNo: invoiceNo ?? this.invoiceNo,
// //         invoiceDate: invoiceDate ?? this.invoiceDate,
// //         salesManId: salesManId ?? this.salesManId,
// //         salesManName: salesManName ?? this.salesManName,
// //         customerAccountId: customerAccountId ?? this.customerAccountId,
// //         customerAccountName: customerAccountName ?? this.customerAccountName,
// //         invoiceType: invoiceType ?? this.invoiceType,
// //         netTotal: netTotal ?? this.netTotal,
// //         mobileAppSalesInvoice: mobileAppSalesInvoice ?? this.mobileAppSalesInvoice,
// //       );
// //
// //   factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
// //     invoiceId: json["invoiceId"],
// //     branchId: json["branchId"],
// //     branchName: json["branchName"],
// //     invoiceNo: json["invoiceNo"],
// //     invoiceDate: json["invoiceDate"],
// //     salesManId: json["salesManId"],
// //     salesManName: json["salesManName"],
// //     customerAccountId: json["customerAccountId"],
// //     customerAccountName: json["customerAccountName"],
// //     invoiceType: json["invoiceType"],
// //     netTotal: json["netTotal"],
// //     mobileAppSalesInvoice: MobileAppSalesInvoice.fromJson(json["mobileAppSalesInvoice"]),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "invoiceId": invoiceId,
// //     "branchId": branchId,
// //     "branchName": branchName,
// //     "invoiceNo": invoiceNo,
// //     "invoiceDate": invoiceDate,
// //     "salesManId": salesManId,
// //     "salesManName": salesManName,
// //     "customerAccountId": customerAccountId,
// //     "customerAccountName": customerAccountName,
// //     "invoiceType": invoiceType,
// //     "netTotal": netTotal,
// //     "mobileAppSalesInvoice": mobileAppSalesInvoice.toJson(),
// //   };
// // }
// //
// // class MobileAppSalesInvoice {
// //   final int companyId;
// //   final int invoiceId;
// //   final int clientId;
// //   final String clientName;
// //   final int driverId;
// //   final String driverName;
// //   final String payType;
// //   final String invoiceNo;
// //   final String invoiceDate;
// //   final int routeId;
// //   final int vehicleId;
// //   final String vehicleNo;
// //   final int total;
// //   final int discountPercentage;
// //   final int discountAmount;
// //   final double netTotal;
// //   final int transactionYear;
// //   final double latitude;
// //   final double longitude;
// //   List<MobileAppSalesInvoiceDetail> mobileAppSalesInvoiceDetails;
// //
// //   MobileAppSalesInvoice({
// //     required this.companyId,
// //     required this.invoiceId,
// //     required this.clientId,
// //     required this.clientName,
// //     required this.driverId,
// //     required this.driverName,
// //     required this.payType,
// //     required this.invoiceNo,
// //     required this.invoiceDate,
// //     required this.routeId,
// //     required this.vehicleId,
// //     required this.vehicleNo,
// //     required this.total,
// //     required this.discountPercentage,
// //     required this.discountAmount,
// //     required this.netTotal,
// //     required this.transactionYear,
// //     required this.latitude,
// //     required this.longitude,
// //     required this.mobileAppSalesInvoiceDetails,
// //   });
// //
// //   MobileAppSalesInvoice copyWith({
// //     int? companyId,
// //     int? invoiceId,
// //     int? clientId,
// //     String? clientName,
// //     int? driverId,
// //     String? driverName,
// //     String? payType,
// //     String? invoiceNo,
// //     String? invoiceDate,
// //     int? routeId,
// //     int? vehicleId,
// //     String? vehicleNo,
// //     int? total,
// //     int? discountPercentage,
// //     int? discountAmount,
// //     double? netTotal,
// //     int? transactionYear,
// //     dynamic latitude,
// //     dynamic longitude,
// //     List<MobileAppSalesInvoiceDetail>? mobileAppSalesInvoiceDetails,
// //   }) =>
// //       MobileAppSalesInvoice(
// //         companyId: companyId ?? this.companyId,
// //         invoiceId: invoiceId ?? this.invoiceId,
// //         clientId: clientId ?? this.clientId,
// //         clientName: clientName ?? this.clientName,
// //         driverId: driverId ?? this.driverId,
// //         driverName: driverName ?? this.driverName,
// //         payType: payType ?? this.payType,
// //         invoiceNo: invoiceNo ?? this.invoiceNo,
// //         invoiceDate: invoiceDate ?? this.invoiceDate,
// //         routeId: routeId ?? this.routeId,
// //         vehicleId: vehicleId ?? this.vehicleId,
// //         vehicleNo: vehicleNo ?? this.vehicleNo,
// //         total: total ?? this.total,
// //         discountPercentage: discountPercentage ?? this.discountPercentage,
// //         discountAmount: discountAmount ?? this.discountAmount,
// //         netTotal: netTotal ?? this.netTotal,
// //         transactionYear: transactionYear ?? this.transactionYear,
// //         latitude: latitude ?? this.latitude,
// //         longitude: longitude ?? this.longitude,
// //         mobileAppSalesInvoiceDetails: mobileAppSalesInvoiceDetails ?? this.mobileAppSalesInvoiceDetails,
// //       );
// //
// //   factory MobileAppSalesInvoice.fromJson(Map<String, dynamic> json) => MobileAppSalesInvoice(
// //     companyId: json["companyId"],
// //     invoiceId: json["invoiceId"],
// //     clientId: json["clientId"],
// //     clientName: json["clientName"],
// //     driverId: json["driverId"],
// //     driverName: json["driverName"],
// //     payType: json["payType"],
// //     invoiceNo: json["invoiceNo"],
// //     invoiceDate: json["invoiceDate"],
// //     routeId: json["routeId"],
// //     vehicleId: json["vehicleId"],
// //     vehicleNo: json["vehicleNo"],
// //     total: json["total"],
// //     discountPercentage: json["discountPercentage"],
// //     discountAmount: json["discountAmount"],
// //     netTotal: json["netTotal"],
// //     transactionYear: json["transactionYear"],
// //     latitude: json["latitude"],
// //     longitude: json["longitude"],
// //     mobileAppSalesInvoiceDetails: List<MobileAppSalesInvoiceDetail>.from(json["mobileAppSalesInvoiceDetails"].map((x) => MobileAppSalesInvoiceDetail.fromJson(x))),
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "companyId": companyId,
// //     "invoiceId": invoiceId,
// //     "clientId": clientId,
// //     "clientName": clientName,
// //     "driverId": driverId,
// //     "driverName": driverName,
// //     "payType": payType,
// //     "invoiceNo": invoiceNo,
// //     "invoiceDate": invoiceDate,
// //     "routeId": routeId,
// //     "vehicleId": vehicleId,
// //     "vehicleNo": vehicleNo,
// //     "total": total,
// //     "discountPercentage": discountPercentage,
// //     "discountAmount": discountAmount,
// //     "netTotal": netTotal,
// //     "transactionYear": transactionYear,
// //     "latitude": latitude,
// //     "longitude": longitude,
// //     "mobileAppSalesInvoiceDetails": List<dynamic>.from(mobileAppSalesInvoiceDetails.map((x) => x.toJson())),
// //   };
// // }
// //
// // class MobileAppSalesInvoiceDetail {
// //   int siNo;
// //   int productId;
// //   String partNumber;
// //   String productName;
// //   String packingDescription;
// //   int packingId;
// //   String packingName;
// //   int quantity;
// //   int foc;
// //   int totalQty;
// //   int srtQty;
// //   int unitRate;
// //   int totalRate;
// //
// //   MobileAppSalesInvoiceDetail({
// //     required this.siNo,
// //     required this.productId,
// //     required this.partNumber,
// //     required this.productName,
// //     required this.packingDescription,
// //     required this.packingId,
// //     required this.packingName,
// //     required this.quantity,
// //     required this.foc,
// //     required this.totalQty,
// //     required this.srtQty,
// //     required this.unitRate,
// //     required this.totalRate,
// //   });
// //
// //   MobileAppSalesInvoiceDetail copyWith({
// //     int? siNo,
// //     int? productId,
// //     String? partNumber,
// //     String? productName,
// //     String? packingDescription,
// //     int? packingId,
// //     String? packingName,
// //     int? quantity,
// //     int? foc,
// //     int? totalQty,
// //     int? srtQty,
// //     int? unitRate,
// //     int? totalRate,
// //   }) =>
// //       MobileAppSalesInvoiceDetail(
// //         siNo: siNo ?? this.siNo,
// //         productId: productId ?? this.productId,
// //         partNumber: partNumber ?? this.partNumber,
// //         productName: productName ?? this.productName,
// //         packingDescription: packingDescription ?? this.packingDescription,
// //         packingId: packingId ?? this.packingId,
// //         packingName: packingName ?? this.packingName,
// //         quantity: quantity ?? this.quantity,
// //         foc: foc ?? this.foc,
// //         totalQty: totalQty ?? this.totalQty,
// //         srtQty: srtQty ?? this.srtQty,
// //         unitRate: unitRate ?? this.unitRate,
// //         totalRate: totalRate ?? this.totalRate,
// //       );
// //
// //   factory MobileAppSalesInvoiceDetail.fromJson(Map<String, dynamic> json) => MobileAppSalesInvoiceDetail(
// //     siNo: json["siNo"],
// //     productId: json["productId"],
// //     partNumber: json["partNumber"],
// //     productName: json["productName"],
// //     packingDescription: json["packingDescription"],
// //     packingId: json["packingId"],
// //     packingName: json["packingName"],
// //     quantity: json["quantity"],
// //     foc: json["foc"],
// //     totalQty: json["totalQty"],
// //     srtQty: json["srtQty"],
// //     unitRate: json["unitRate"],
// //     totalRate: json["totalRate"],
// //   );
// //
// //   Map<String, dynamic> toJson() => {
// //     "siNo": siNo,
// //     "productId": productId,
// //     "partNumber": partNumber,
// //     "productName": productName,
// //     "packingDescription": packingDescription,
// //     "packingId": packingId,
// //     "packingName": packingName,
// //     "quantity": quantity,
// //     "foc": foc,
// //     "totalQty": totalQty,
// //     "srtQty": srtQty,
// //     "unitRate": unitRate,
// //     "totalRate": totalRate,
// //   };
// // }


class InvoiceModel {
  final int companyId;
  final int invoiceId;
  final int branchId;
  final String branchName;
  final String invoiceNo;
  final String invoiceDate;
  final int salesManId;
  final String salesManName;
  final int clientId;
  final String clientName;
  final String invoiceType;
  final double netTotal;
  final MobileAppSalesInvoice? mobileAppSalesInvoice;

  InvoiceModel({
    required this.companyId,
    required this.invoiceId,
    required this.branchId,
    required this.branchName,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.salesManId,
    required this.salesManName,
    required this.clientId,
    required this.clientName,
    required this.invoiceType,
    required this.netTotal,
    this.mobileAppSalesInvoice,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      companyId: json['companyId'] ?? 0,
      invoiceId: json['invoiceId'] ?? 0,
      branchId: json['branchId'] ?? 0,
      branchName: json['branchName'] ?? "Unknown",
      invoiceNo: json['invoiceNo'] ?? "N/A",
      invoiceDate: json['invoiceDate'] ?? "0000-00-00",
      salesManId: json['salesManId'] ?? 0,
      salesManName: json['salesManName'] ?? "No Name",
      clientId: json['customerAccountId'] ?? 0,
      clientName: json['customerAccountName'] ?? "Unknown",
      invoiceType: json['invoiceType'] ?? "Unknown",
      netTotal: (json['netTotal'] as num?)?.toDouble() ?? 0.0,
      mobileAppSalesInvoice: json['mobileAppSalesInvoice'] != null
          ? MobileAppSalesInvoice.fromJson(json['mobileAppSalesInvoice'])
          : null,
    );
  }

  static List<InvoiceModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => InvoiceModel.fromJson(json)).toList();
  }
}

// class MobileAppSalesInvoice {
//   final int companyId;
//   final int invoiceId;
//   final int clientId;
//   final String clientName;
//   final int driverId;
//   final String driverName;
//   final String payType;
//   final String invoiceNo;
//   final String invoiceDate;
//   final int routeId;
//   final int vehicleId;
//   final String vehicleNo;
//   final double netTotal;
//   final List<MobileAppSalesInvoiceDetails> details;
//
//   MobileAppSalesInvoice({
//     required this.companyId,
//     required this.invoiceId,
//     required this.clientId,
//     required this.clientName,
//     required this.driverId,
//     required this.driverName,
//     required this.payType,
//     required this.invoiceNo,
//     required this.invoiceDate,
//     required this.routeId,
//     required this.vehicleId,
//     required this.vehicleNo,
//     required this.netTotal,
//     required this.details,
//   });
//
//   factory MobileAppSalesInvoice.fromJson(Map<String, dynamic> json) {
//     return MobileAppSalesInvoice(
//       companyId: json['companyId'] ?? 0,
//       invoiceId: json['invoiceId'] ?? 0,
//       clientId: json['clientId'] ?? 0,
//       clientName: json['clientName'] ?? "Unknown",
//       driverId: json['driverId'] ?? 0,
//       driverName: json['driverName'] ?? "No Name",
//       payType: json['payType'] ?? "Unknown",
//       invoiceNo: json['invoiceNo'] ?? "N/A",
//       invoiceDate: json['invoiceDate'] ?? "0000-00-00",
//       routeId: json['routeId'] ?? 0,
//       vehicleId: json['vehicleId'] ?? 0,
//       vehicleNo: json['vehicleNo'] ?? "Unknown",
//       netTotal: (json['netTotal'] as num?)?.toDouble() ?? 0.0,
//       details: (json['mobileAppSalesInvoiceDetails'] as List<dynamic>?)
//           ?.map((e) => MobileAppSalesInvoiceDetails.fromJson(e))
//           .toList() ??
//           [],
//     );
//   }
// }
class MobileAppSalesInvoice {
  final int companyId;
  final int invoiceId;
  final int clientId;
  final String clientName;
  final int driverId;
  final String driverName;
  final String payType;
  final String invoiceNo;
  final String invoiceDate;
  final int routeId;
  final int vehicleId;
  final String vehicleNo;
  final double netTotal;
  final double total;
  final double discountAmount;
  final double discountPercentage;
  final double paidAmount;
  final List<MobileAppSalesInvoiceDetails> details;

  MobileAppSalesInvoice({
    required this.paidAmount,
    required this.companyId,
    required this.invoiceId,
    required this.clientId,
    required this.clientName,
    required this.driverId,
    required this.driverName,
    required this.payType,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.routeId,
    required this.vehicleId,
    required this.vehicleNo,
    required this.netTotal,
    required this.total,
    required this.details,
    required this.discountAmount,
    required this.discountPercentage,
  });

  factory MobileAppSalesInvoice.fromJson(Map<String, dynamic> json) {
    return MobileAppSalesInvoice(
      companyId: json['companyId'] ?? 0,
      invoiceId: json['invoiceId'] ?? 0,
      clientId: json['clientId'] ?? 0,
      clientName: json['clientName'] ?? "Unknown",
      driverId: json['driverId'] ?? 0,
      driverName: json['driverName'] ?? "No Name",
      payType: json['payType'] ?? "Unknown",
      invoiceNo: json['invoiceNo'] ?? "N/A",
      invoiceDate: json['invoiceDate'] ?? "0000-00-00",
      routeId: json['routeId'] ?? 0,
      vehicleId: json['vehicleId'] ?? 0,
      vehicleNo: json['vehicleNo'] ?? "Unknown",
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
      netTotal: (json['netTotal'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      details: (json['mobileAppSalesInvoiceDetails'] as List<dynamic>?)
          ?.map((e) => MobileAppSalesInvoiceDetails.fromJson(e))
          .toList() ??
          [],
    );
  }


  MobileAppSalesInvoice copyWith({
    int? companyId,
    int? invoiceId,
    int? clientId,
    String? clientName,
    int? driverId,
    String? driverName,
    String? payType,
    String? invoiceNo,
    String? invoiceDate,
    int? routeId,
    int? vehicleId,
    String? vehicleNo,
    double? netTotal,
    double? total,
    double? discountAmount,
    double? discountPercentage,
    double? paidAmount,
    List<MobileAppSalesInvoiceDetails>? details,
  }) {
    return MobileAppSalesInvoice(
      paidAmount: paidAmount??this.paidAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      companyId: companyId ?? this.companyId,
      invoiceId: invoiceId ?? this.invoiceId,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      payType: payType ?? this.payType,
      invoiceNo: invoiceNo ?? this.invoiceNo,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      routeId: routeId ?? this.routeId,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      netTotal: netTotal ?? this.netTotal,
      total: total ?? this.total,
      details: details ?? this.details,
    );
  }
}

// class MobileAppSalesInvoiceDetails {
//   final int siNo;
//   final int productId;
//   final String partNumber;
//   final String productName;
//   final String packingDescription;
//   final int packingId;
//   final String packingName;
//   final double quantity;
//   final double foc;
//   final double totalQty;
//   final double unitRate;
//   final double totalRate;
//
//   MobileAppSalesInvoiceDetails({
//     required this.siNo,
//     required this.productId,
//     required this.partNumber,
//     required this.productName,
//     required this.packingDescription,
//     required this.packingId,
//     required this.packingName,
//     required this.quantity,
//     required this.foc,
//     required this.totalQty,
//     required this.unitRate,
//     required this.totalRate,
//   });
//
//   factory MobileAppSalesInvoiceDetails.fromJson(Map<String, dynamic> json) {
//     return MobileAppSalesInvoiceDetails(
//       siNo: json['siNo'] ?? 0,
//       productId: json['productId'] ?? 0,
//       partNumber: json['partNumber'] ?? "Unknown",
//       productName: json['productName'] ?? "Unknown",
//       packingDescription: json['packingDescription'] ?? "Unknown",
//       packingId: json['packingId'] ?? 0,
//       packingName: json['packingName'] ?? "Unknown",
//       quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
//       foc: (json['foc'] as num?)?.toDouble() ?? 0.0,
//       totalQty: (json['totalQty'] as num?)?.toDouble() ?? 0.0,
//       unitRate: (json['unitRate'] as num?)?.toDouble() ?? 0.0,
//       totalRate: (json['totalRate'] as num?)?.toDouble() ?? 0.0,
//     );
//   }
// }
class MobileAppSalesInvoiceDetails {
  final int siNo;
  final int productId;
  final String partNumber;
  final String productName;
  final String packingDescription;
  final int packingId;
  final String packingName;
  final double quantity;
  final double foc;
  final double srtQty;
  final double totalQty;
  final double unitRate;
  final double totalRate;
  final int clientId;
  final int companyId;

  MobileAppSalesInvoiceDetails( {
    required this.siNo,
    required this.productId,
    required this.partNumber,
    required this.productName,
    required this.packingDescription,
    required this.packingId,
    required this.packingName,
    required this.quantity,
    required this.foc,
    required this.totalQty,
    required this.unitRate,
    required this.totalRate,
    required this.srtQty,
    required this.clientId,
    required this.companyId,
  });

  factory MobileAppSalesInvoiceDetails.fromJson(Map<String, dynamic> json) {
    return MobileAppSalesInvoiceDetails(
      siNo: json['siNo'] ?? 0,
      productId: json['productId'] ?? 0,
      companyId: json['companyId'] ?? 0,
      clientId: json['clientId'] ?? 0,
      partNumber: json['partNumber'] ?? "Unknown",
      productName: json['productName'] ?? "Unknown",
      packingDescription: json['packingDescription'] ?? "Unknown",
      packingId: json['packingId'] ?? 0,
      packingName: json['packingName'] ?? "Unknown",
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      foc: (json['foc'] as num?)?.toDouble() ?? 0.0,
      totalQty: (json['totalQty'] as num?)?.toDouble() ?? 0.0,
      unitRate: (json['unitRate'] as num?)?.toDouble() ?? 0.0,
      totalRate: (json['totalRate'] as num?)?.toDouble() ?? 0.0,
      srtQty: (json['srtQty'] as num?)?.toDouble()??0.0,
    );
  }

  MobileAppSalesInvoiceDetails copyWith({
    int? siNo,
    int? productId,
    String? partNumber,
    String? productName,
    String? packingDescription,
    int? packingId,
    String? packingName,
    double? quantity,
    double? foc,
    double? totalQty,
    double? unitRate,
    double? totalRate,
    double? srtQty
  }) {
    return MobileAppSalesInvoiceDetails(
      siNo: siNo ?? this.siNo,
      productId: productId ?? this.productId,
      partNumber: partNumber ?? this.partNumber,
      productName: productName ?? this.productName,
      packingDescription: packingDescription ?? this.packingDescription,
      packingId: packingId ?? this.packingId,
      packingName: packingName ?? this.packingName,
      quantity: quantity ?? this.quantity,
      foc: foc ?? this.foc,
      totalQty: totalQty ?? this.totalQty,
      unitRate: unitRate ?? this.unitRate,
      totalRate: totalRate ?? this.totalRate,
      srtQty: srtQty ?? this.srtQty,
      companyId: companyId,
      clientId: clientId
    );
  }
}
