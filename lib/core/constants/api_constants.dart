class ApiConstants {
  ///login section
  static const String baseUrl = "http://10.0.2.2:5274/yadhava/api/";
  //static const String baseUrl = "http://www.posbuss.com:98/yadhava/api/";
  static const String companyGetAll = "Company/GetCompanyAll";
  static const String getRoute = "MobileAppLogin/GetMobileAppGetRoutes?";
  static const String getVehicle = "MobileAppLogin/GetMobileAppGetVehicles?";
  static const String login = "MobileAppLogin/MobileAppLogin";
  static const String logout = "MobileAppLogin/MobileAppLogout";
  static const String refreshToken = 'MobileAppLogin/RefreshToken';

  static const String secondBaseUrl = "http://localhost:5274/api/";

  static const String clientList = "Client/GetClientsMobileApp?";
  static const String clientListDateWise = "Client/GetClientsMobileAppDateWise";

  static const String updateClient = "Client/UpdateMobileAppClient";
  static const String addClient = "Client/CreateMobileAppClient";

  static const String mobileAppInvoices =
      "MobileAppSales/GetMobileAppSalesInvoiceAll?";

  static const String invoice =
      "MobileAppSales/GetMobileAppSalesRegisterDetails?";
  static const String lastInvoice =
      "MobileAppSales/GetMobileAppLastSalesInvoiceDetails?";

  static const String lastInvoiceAll =
      "MobileAppSales/GetMobileAppLastSalesInvoiceDetailsAll?";

  static const String stockSummeryStatus =
      "InventoryBalanceReport/GetStockSummeryVan?";
  static const String salesSummeryStatus =
      "MobileAppSales/GetMobileAppSalesSummeryDetails?";

  static const String creditSalesSummery =
      "MobileAppSales/GetMobileAppSalesSummeryDetails?";
  static const String cashSalesSummery =
      "MobileAppSales/GetMobileAppSalesSummeryDetails?";

  static const String totalSales = "MobileAppSales/GetMobileAppSalesDashBoard?";
  static const String salesInvoice =
      "InventorySalesInvoice/CreateMobileAppSalesInvoice";
  // static const String salesInvoiceGetByNo =
  //     "InventorySalesInvoice/GetMobileAppSalesInvoiceByNo?invoiceNo=YDHSI25000001&companyId=1";
  static const String deleteInvoice =
      "InventorySalceesInvoice/CreateMobileAppSalesInvoice";
  static const String deleteInvoiceByNo =
      "InventorySalesInvoice/DeleteByNo?InvoiceNo=YDHSI25000002&CompanyId=1";

  static const String detaileRoute =
      "MobileAppSales/GetMobileAppSalesRouteHistoryDetails?";
  static const String routeHistory =
      "MobileAppSales/GetMobileAppSalesRouteHistory?";
  static const String routeHistoryDetails =
      "MobileAppSales/GetMobileAppSalesRouteHistoryDetails?";
  static const String voucher =
      "AccountLedgerReport/GetAccountLedgerReportsMobileApp?";
  static const String order =
      "InventorySalesInvoice/GetMobileAppSalesInvoiceByNo?";
  static const String createVoucher = "MobileAppSales/CreateVoucher";
  static const String updatVoucher = "MobileAppSales/UpdateVoucher";
  static const String cashReceiptGet =
      "MobileAppSales/GetVoucherDetailsMobileApp";

  static const String productList = 'InventoryProduct/GetMobileAppProductList?';
  static const String createSalesInvoice =
      'InventorySalesInvoice/CreateMobileAppSalesInvoice';
  static const String updateSalesInvoice =
      'InventorySalesInvoice/UpdateMobileAppSalesInvoice';

  static const String cashCreditSalesSummeryGet =
      'InventorySalesInvoice/GetCashCreditSalesSummery?';

  static const String mobileCollectionCreditCashCustomer =
      'InventorySalesInvoice/GetMobileCollectionCreditCashCustomer?';

  static const String mobileAppSalesDashBoardHome =
      'MobileAppSales/GetMobileAppSalesDashBoardHome?';

  static const String getMobileActiveClients =
      'Client/GetMobileActiveClients?';

  static const String getMobileInActiveClients =
      'Client/GetMobileInActiveClients?';

}
// static const String secondBaseUrl = "http://localhost:5274/api/";
// static const String clientList = "Client/GetClientsMobileApp?CompanyId=1";
// static const String invoice =
//     "MobileAppSales/GetMobileAppSalesRegister?fromDate=2025-01-01&endDate=2025-01-31&partyId=0&vehicleId=0&companyId=1";
// static const String stockSummeryStatus =
//     "InventoryBalanceReport/GetStockSummeryVan?companyId=1&vehicleId=2";
// static const String totalSales =
//     "MobileAppSales/GetMobileAppSalesDashBoard?companyId=1&vehicleId=2&invoiceDate=2025-01-30";
// static const String addClient = "Client/CreateMobileAppClient";
// static const String updateClient = "Client/UpdateMobileAppClient";
// static const String salesInvoice =
//     "InventorySalesInvoice/CreateMobileAppSalesInvoice";
// static const String salesInvoiceGetByNo =
//     "InventorySalesInvoice/GetMobileAppSalesInvoiceByNo?invoiceNo=YDHSI25000001&companyId=1";
// static const String deleteInvoice =
//     "InventorySalesInvoice/DeleteById?InvoiceId=";
// static const String deleteInvoiceByNo =
//     "InventorySalesInvoice/DeleteByNo?InvoiceNo=YDHSI25000002&CompanyId=1";
// static const String detaileRoute =
//     "MobileAppSales/GetMobileAppSalesRouteHistoryDetails?";
//
// static const String routeHistory =
//     "MobileAppSales/GetMobileAppSalesRouteHistory?";
// static const String voucher =
//     "AccountLedgerReport/GetAccountLedgerReportsMobileApp?AccountId=25000028&FromDate=2025-01-01&EndDate=2025-01-31&CompanyId=1";
