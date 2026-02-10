//import 'dart:ffi';

import 'package:Yadhava/features/auth/data/login_model.dart';
import 'package:Yadhava/features/auth/domain/login_repo.dart';
import 'package:Yadhava/features/home/presentation/bloc/cash_credit_summery/cash_credit_summery_bloc.dart';
import 'package:Yadhava/features/home/presentation/bloc/cash_summery/cash_summery_bloc.dart';
import 'package:Yadhava/features/home/presentation/bloc/credit_summery/credit_summery_bloc.dart';
import 'package:Yadhava/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:Yadhava/features/home/presentation/bloc/sales_summery/sales_summery_bloc.dart';
import 'package:Yadhava/features/home/presentation/bloc/stockList_bloc/stock_list_bloc.dart';
import 'package:Yadhava/features/home/presentation/bloc/totalSales_bloc/bloc/total_sales_bloc.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/cashCreditTableRow.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/HomeAppbar.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/cashCreditTableHeader.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/cashTableHeader.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/cashTableRow.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/creditTableHearder.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/creditTableRow.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/salesContainer.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/sales_header.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/sales_row.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/table_header.dart';
import 'package:Yadhava/features/home/presentation/pages/widgets/table_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/textthemes.dart';
import '../../../customer/presentation/bloc/inovice_bloc/invoice_bloc.dart';
import '../../../customer/presentation/bloc/last_invoice_bloc/lastinvoice_bloc.dart';
import '../../../customer/presentation/pages/customer_details/bloc/add_item_bloc.dart';
import '../../../customer/presentation/pages/customer_view/active_client_view.dart';
import '../../../customer/presentation/pages/customer_view/inactive_client_view.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  int vehicleId = 0;
  int companyId = 0;
  int driverId = 0;
  int routeId = 0;

  GetLoginRepo loginRepo = GetLoginRepo();
  @override
  initState() {
    super.initState();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd").format(now).toUpperCase();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      if(await getLoginResponse()){

        context.read<HomeBloc>().add(HomeGetEvent(formattedDate));
        context.read<LastInvoiceBloc>().add(FetchLastInvoice(0));
        context.read<AddItemBloc>().add(FetchProductMaster());

        context
            .read<InvoiceBloc>()
            .add(FetchInvoiceAllEvent(companyId: companyId, routeId: routeId));


        context.read<LastInvoiceBloc>()
        .add(SyncLastInvoices(0));
      }


    });
    // getLoginResponse();
    // context.read<TotalSalesBloc>().add(const TotalSalesGetEvent());
    //  context.read<StockListBloc>().add(const StockListGetEvent());
  }

  Future<bool> getLoginResponse() async {
    LoginModel? response = await loginRepo.getUserLoginResponse();
    print(response!.userName);
    setState(() {
      userName = response.userName;
      vehicleId = response.vehicleId;
      driverId = response.driverId;
      companyId = response.companyId;
      routeId = response.routeId;
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: HomeAppBar(
          userName: userName,
        ),

        drawer: Drawer(
          backgroundColor: Colour.pContainerBlack,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🧑 User Header
                UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: Colour.pContainerBlack),
                  accountName: Text(
                    userName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  accountEmail: const Text(
                    "Welcome back!",
                    style: TextStyle(color: Colors.white70),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 35, color: Colors.blueAccent),
                  ),
                ),

                // 📊 Customer Summary
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Customer Summary",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: const Text("Active Customers",
                      style: TextStyle(color: Colors.white)),
                  trailing: const Text(
                    '100',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context); // close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActiveClientListScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel, color: Colors.orange),
                  title: const Text("Inactive Customers",
                      style: TextStyle(color: Colors.white)),
                  trailing: const Text(
                    '200',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context); // close drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InActiveClientListScreen(),
                      ),
                    );
                  },
                ),

                const Divider(color: Colors.white54),

                // 🔄 Sync Clients Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // TODO: implement your sync logic
                      // await syncClients();
                      ScaffoldMessenger.of(context).showSnackBar(

                        const SnackBar(content: Text('Syncing clients...')),
                      );
                    },
                    icon: const Icon(Icons.sync, size: 22),
                    label: const Text(
                      "Sync Clients",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Colors.blueAccent.withOpacity(0.4),
                    ),
                  ),
                ),


                const Spacer(), // ✅ Pushes logout to the bottom

                // 🚪 Logout
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: handle logout
                  },
                ),
              ],
            ),
          ),
        ),


        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              const SalesContainer(),
              // Text(
              //   'Stock Status',
              //   style: AppTextThemes.h4,
              // ),
              // const StockTableHeader(),
              // const StockRow()
              // const SizedBox(height: 8),

              TabBar(
                  indicatorColor: Colors.transparent,
                  labelStyle: AppTextThemes.h7,
                  isScrollable: true,
                  tabs: [

                    Tab(
                      text: "Collection Details",
                    ),
                    Tab(
                      text: "Stock Details",
                    ),
                    Tab(
                      text: "Sales Summary",
                    ),
                    Tab(
                      text: "Credit Summary",
                    ),
                    Tab(
                      text: "Cash/Bank Summary",
                    ),
                  ]),

              Expanded(
                child: TabBarView(
                  children: [
                    cashCreditSummery(),
                    stockDetails(),
                    salesSummery(),
                    creditSummery(),
                    cashSummery(),
                  ],
                ),
              ),
              // const StockStatusContainer(),
              // const StockStatusContainerBlue(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget stockDetails() {
  return Column(
    children: [const StockTableHeader(), const StockRow()],
  );
}

Widget salesSummery() {
  return Column(
    children: [const SalesTableHeader(), const SalesRow()],
  );
}

Widget creditSummery() {
  print('CREDIT');
  return Column(
    children: [const CreditTableHeader(), const creditTableRow()],
  );
}

Widget cashSummery() {
  return Column(
    children: [const CashTableHeader(), const cashTableRow()],
  );
}

Widget cashCreditSummery() {
  return Column(
    children: [const cashCreditTableheader(), const cashCreditTableRow()],
  );
}
