import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/order_model.dart';
import 'package:Yadhava/features/home/data/cash_credit_details.dart';
import 'package:Yadhava/features/home/data/cash_summery.dart';
import 'package:Yadhava/features/home/data/credit_summery.dart';
import 'package:Yadhava/features/home/data/sales_summery.dart';
import 'package:Yadhava/features/home/data/stockStsModel.dart';
import 'package:Yadhava/features/home/data/totalSales_model.dart';
import 'package:Yadhava/features/route/presentation/pages/route_details/route_details.dart';

class MobileAppSalesDashBoardHome {
  final List<SalesTransactions>? mobileAppSalesDashBoard;
  final List<ProductStock>? mobileAppStockBalanceVans;
  final List<SalesSummery>? mobileAppSales;
  final List<CreditSummery>? mobileAppSalesCredit;
  final List<CashSummery>? mobileAppSalesCash;
  final List<CashCreditDetailsModel>?
      salesInvoiceCollectionCreditCashCustomerImports;

  MobileAppSalesDashBoardHome({
    this.mobileAppSalesDashBoard,
    this.mobileAppStockBalanceVans,
    this.mobileAppSales,
    this.mobileAppSalesCredit,
    this.mobileAppSalesCash,
    this.salesInvoiceCollectionCreditCashCustomerImports,
  });

  factory MobileAppSalesDashBoardHome.fromJson(Map<String, dynamic> json) {
    return MobileAppSalesDashBoardHome(
      mobileAppSalesDashBoard: (json['mobileAppSalesDashBoard'] as List?)
          ?.map((e) => SalesTransactions.fromJson(e))
          .toList(),
      mobileAppStockBalanceVans: (json['mobileAppStockBalanceVans'] as List?)
          ?.map((e) => ProductStock.fromJson(e))
          .toList(),
      mobileAppSales: (json['mobileAppSales'] as List?)
          ?.map((e) => SalesSummery.fromJson(e))
          .toList(),
      mobileAppSalesCredit: (json['mobileAppSalesCredit'] as List?)
          ?.map((e) => CreditSummery.fromJson(e))
          .toList(),
      mobileAppSalesCash: (json['mobileAppSalesCash'] as List?)
          ?.map((e) => CashSummery.fromJson(e))
          .toList(),
      salesInvoiceCollectionCreditCashCustomerImports:
          (json['salesInvoiceCollectionCreditCashCustomerImports'] as List?)
              ?.map((e) => CashCreditDetailsModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mobileAppSalesDashBoard':
          mobileAppSalesDashBoard?.map((e) => e.toJson()).toList(),
      'mobileAppStockBalanceVans':
          mobileAppStockBalanceVans?.map((e) => e.toJson()).toList(),
      'mobileAppSales': mobileAppSales?.map((e) => e.toJson()).toList(),
      'mobileAppSalesCredit':
          mobileAppSalesCredit?.map((e) => e.toJson()).toList(),
      'mobileAppSalesCash': mobileAppSalesCash?.map((e) => e.toJson()).toList(),
      'salesInvoiceCollectionCreditCashCustomerImports':
          salesInvoiceCollectionCreditCashCustomerImports
              ?.map((e) => e.toJson())
              .toList(),
    };
  }
}
