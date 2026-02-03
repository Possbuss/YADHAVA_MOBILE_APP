import 'package:Yadhava/features/customer/domain/last_invoice_repo.dart';
import 'package:Yadhava/features/customer/presentation/bloc/last_invoice_bloc/lastinvoice_bloc.dart';
import 'package:Yadhava/features/home/domain/cashcreditsummeryRepo.dart';
import 'package:Yadhava/features/home/domain/homerepo.dart';
import 'package:Yadhava/features/home/presentation/bloc/cash_credit_summery/cash_credit_summery_bloc.dart';
import 'package:Yadhava/features/home/presentation/bloc/cash_summery/cash_summery_bloc.dart';
import 'package:Yadhava/features/home/presentation/bloc/credit_summery/credit_summery_bloc.dart';
import 'package:Yadhava/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:Yadhava/features/home/presentation/bloc/sales_summery/sales_summery_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/color.dart';
import 'features/auth/domain/login_repo.dart';
import 'features/auth/domain/route_repository.dart';
import 'features/auth/domain/vehicle_repository.dart';
import 'features/auth/presentation/bloc/login_bloc/login_bloc.dart';
import 'features/auth/presentation/bloc/route_bloc/route_bloc.dart';
import 'features/auth/presentation/bloc/vehicle_bloc/vehicle_bloc.dart';
import 'features/customer/domain/cash_receipt_repo.dart';
import 'features/customer/domain/client_repo.dart';
import 'features/customer/domain/client_update_repo.dart';
import 'features/customer/domain/create_client.dart';
import 'features/customer/domain/inventory_update_repo.dart';
import 'features/customer/domain/invoice_repo.dart';
import 'features/customer/domain/order_repo.dart';
import 'features/customer/presentation/bloc/cash_recipt_bloc/cash_receipt_bloc.dart';
import 'features/customer/presentation/bloc/client_bloc/client_list_bloc.dart';
import 'features/customer/presentation/bloc/client_create/client_create_bloc.dart';
import 'features/customer/presentation/bloc/client_update/client_update_bloc.dart';
import 'features/customer/presentation/bloc/create_voucher/create_voucher_bloc.dart';
import 'features/customer/presentation/bloc/inovice_bloc/invoice_bloc.dart';
import 'features/customer/presentation/bloc/update_cashreciept_bloc/create_voucher_bloc.dart';
import 'features/customer/presentation/bloc/update_invoice/update_invoice_bloc.dart';
import 'features/customer/presentation/pages/customer_details/bloc/add_item_bloc.dart';
import 'features/home/domain/productStockRepo.dart';
import 'features/home/domain/salessummeryrepo.dart';
import 'features/home/domain/totalSalesRepo.dart';
import 'features/home/presentation/bloc/stockList_bloc/stock_list_bloc.dart';
import 'features/home/presentation/bloc/totalSales_bloc/bloc/total_sales_bloc.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/route/presentation/bloc/route_detailed_bloc/route_detail_bloc.dart';
import 'features/route/presentation/pages/route.dart';
import 'features/route/repository/route_history_repo.dart';
import 'features/splash/domain/repository.dart';
import 'features/splash/presentation/bloc/splash_bloc.dart';
import 'features/splash/presentation/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => VoucherBloc(CashReceiptRepo())),
        BlocProvider(
            create: (BuildContext context) =>
                CashReceiptBloc(CashReceiptRepo())),
        BlocProvider(
            create: (context) =>
                UpdateInvoiceBloc(invoiceRepository: InvoiceRepository())),
        BlocProvider(
            create: (context) => SalesSummeryBloc(SalesSummaryRepository())),
        BlocProvider(create: (context) => HomeBloc(HomeRepository())),
        BlocProvider(
            create: (context) =>
                CashSummeryBloc(CashCreditSummaryRepository())),
        BlocProvider(
            create: (context) =>
                CreditummeryBloc(CashCreditSummaryRepository())),
        BlocProvider(
            create: (context) =>
                CashCreditSummeryBloc(CashCreditSummaryRepository())),
        BlocProvider<SplashBloc>(
          lazy: true,
          create: (BuildContext context) => SplashBloc(GetCompanyListRepo()),
        ),
        BlocProvider<LastInvoiceBloc>(
          lazy: true,
          create: (BuildContext context) =>
              LastInvoiceBloc(LastInvoiceRepository()),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(GetLoginRepo()),
        ),
        BlocProvider<VoucherUpdateBloc>(
          create: (BuildContext context) =>
              VoucherUpdateBloc(CashReceiptRepo()),
        ),
        BlocProvider<VehicleBloc>(
          lazy: true,
          create: (BuildContext context) => VehicleBloc(VehicleRepository()),
        ),
        BlocProvider<RouteBloc>(
          create: (BuildContext context) => RouteBloc(GetRouteRepo()),
        ),
        BlocProvider<ClientListBloc>(
          create: (BuildContext context) => ClientListBloc(GetClientListRepo()),
        ),
        BlocProvider<ClientCreateBloc>(
          create: (BuildContext context) =>
              ClientCreateBloc(CreateClientListRepo()),
        ),
        BlocProvider<ClientUpdateBloc>(
          create: (BuildContext context) =>
              ClientUpdateBloc(UpdateClientListRepo()),
        ),
        BlocProvider<InvoiceBloc>(
            create: (BuildContext context) => InvoiceBloc(InvoiceRepo())),
        BlocProvider<RouteDetailsBloc>(
            create: (BuildContext context) => RouteDetailsBloc(
                  RouteRepo(),
                )),
        BlocProvider<StockListBloc>(
          lazy: true,
          create: (BuildContext context) => StockListBloc(ProductStockRepo()),
        ),
        BlocProvider<AddItemBloc>(
          create: (BuildContext context) => AddItemBloc(OrderRepo()),
        ),
        BlocProvider<TotalSalesBloc>(
          create: (BuildContext context) => TotalSalesBloc(Totalsalesrepo()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Yadhava',
            theme: ThemeData(
              scaffoldBackgroundColor: Colour.pBackgroundBlack,
              appBarTheme: const AppBarTheme(
                color: Colour.pBackgroundBlack,
                foregroundColor: Colour.pWhite,
                centerTitle: false,
                iconTheme: IconThemeData(color: Colour.pGray, weight: 2.0),
              ),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!,
              );
            },
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/home': (context) => const HomeScreen(),
              // '/invoice': (context) => const InvoicePage(),
              '/routePage': (context) => const RoutePage(),
            },
          );
        },
      ),
    );
  }
}
