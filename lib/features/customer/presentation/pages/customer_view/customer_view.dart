import 'package:Yadhava/features/customer/presentation/pages/customer_view/widget/coustomer_list.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_view/widget/heading.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_view/widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../auth/data/login_model.dart';
import '../../../../auth/domain/login_repo.dart';
import '../../bloc/client_bloc/client_list_bloc.dart';
import '../../bloc/last_invoice_bloc/lastinvoice_bloc.dart';
import 'customer_create/customer_create.dart';

class CustomerView extends StatefulWidget {
  const CustomerView({super.key});

  @override
  State<CustomerView> createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  late String fromDate;
  late String endDate;
  int vehicleId = 0;
  int companyId = 0;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();

    fromDate = _getFromDate(30);
    endDate = _getEndDate();
    _fetchData();

  }

  Future<void> _fetchData() async {

    final GetLoginRepo userRepo = GetLoginRepo();
    LoginModel? responseModel = await userRepo.getUserLoginResponse();
    if (!mounted) return;
    if (responseModel != null) {
      setState(() {
        vehicleId = responseModel.vehicleId;
        companyId = responseModel.companyId;
      });

      /// Fetch updated customer list
      context.read<ClientListBloc>().add(ClientListGetEvent());

      //context.read<LastInvoiceBloc>().add(LastInvoiceEvent());
    } else {
      print("❌ Failed to fetch user data.");
    }
  }

  String _getEndDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String _getFromDate(int daysAgo) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: daysAgo)));
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomerSearchBar(
                controller: searchController,
                onChanged: (value) {
                  context
                      .read<ClientListBloc>()
                      .add(ClientListSearchEvent(value));
                },
              ),
              allCustomers(),

              ///heading text
              CustomerCardList(
                  companyId: companyId,
                  vehicleId: vehicleId,
                  fromDate: fromDate,
                  toDate: endDate)
              // customerCardList(context, companyId,vehicleId,fromDate,endDate), /// client list
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: FloatingActionButton(
            elevation: 5,
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xff703BF7),
            onPressed: () async {
              final result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomerCreate())
              );

              if (!mounted) return; // ✅ guard context use
              if (result == true) {
                context.read<ClientListBloc>().add(ClientListGetEvent());
              }

            },
            child: const Icon(
              Icons.add,
            )),
      ),
    );
  }
}
