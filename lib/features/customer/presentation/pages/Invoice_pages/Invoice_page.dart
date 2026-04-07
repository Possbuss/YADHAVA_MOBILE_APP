import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/color.dart';
import '../../../../auth/data/login_model.dart';
import '../../../../auth/domain/login_repo.dart';
import '../../../../home/presentation/pages/home_page.dart';
import '../../../data/client_model.dart';
import '../../bloc/inovice_bloc/invoice_bloc.dart';
//import '../../widgets/invoice/build_appbar.dart';
import '../../widgets/invoice/build_invoicelist.dart';
import '../../widgets/invoice/build_screen.dart';
// import '../cash_recept/cash_recept.dart';
// import '../customer_details/bloc/add_item_bloc.dart';
// import '../customer_details/detail_page.dart';
// import '../new_invoice/invoice_list.dart';

class InvoicePage extends StatefulWidget {
  final int? partyId;
  final ClientModel client;

  const InvoicePage({
    super.key,
    this.partyId,
    required this.client,
  });

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isExpanded = false;
  late String fromDate;
  late String endDate;
  int vehicleId = 0;
  int companyId = 0;
  bool isDataFetched = false;
  String invoiceid = "";

  @override
  void initState() {
    super.initState();
    fromDate = _getFromDate(5);
    endDate = _getEndDate();

    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchData(); // Reload invoices every time dependencies change
  }

  Future<void> _fetchData() async {
    final GetLoginRepo userRepo = GetLoginRepo();
    LoginModel? responseModel = await userRepo.getUserLoginResponse();

    if (responseModel != null) {
      setState(() {
        vehicleId = responseModel.vehicleId;
        companyId = responseModel.companyId;
        isDataFetched = true;
      });

      _fetchInvoices();
    } else {
      print("❌ Failed to fetch user data.");
    }
  }

  void _fetchInvoices() async {

    GetLoginRepo loginRepo = GetLoginRepo();
    LoginModel? loginModel = await loginRepo.getUserLoginResponse();
    if (loginModel == null) {
      throw Exception("User login response is null");
    }

    context.read<InvoiceBloc>().add(
        FetchInvoiceEvent(
            vehicleId: loginModel.vehicleId,
            salesmanId: loginModel.driverId,
            companyId: loginModel.companyId,
            clientId: widget.client.id ?? 0,
            routeId: loginModel.routeId
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataFetched) return buildLoadingScreen(context);

    final String customerName = widget.client.contactPersonName?.trim().isNotEmpty ==
            true
        ? widget.client.contactPersonName!.trim()
        : (widget.client.name?.trim().isNotEmpty == true
            ? widget.client.name!.trim()
            : 'Customer Invoices');

    return BlocListener<InvoiceBloc, InvoiceState>(
      // listener: (context, state) {
      //   if (state is InvoiceLoaded) {
      //     setState(() {});
      //   }
      // },
      listener: (context, state) {
        if (state is InvoiceLoaded) {
          refreshIndicatorKey.currentState?.show(); // Force RefreshIndicator
        }
      },
      child: Scaffold(
        backgroundColor: Colour.pBackgroundBlack,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colour.pDeepLightBlue,
          elevation: 0,
          toolbarHeight: 76,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
          ),
          title: const Text(
            "Invoices",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          index: 1,
                        ))),
            child: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colour.pDeepLightBlue.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colour.pDeepLightBlue.withValues(alpha: 0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    customerName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<InvoiceBloc, InvoiceState>(
                builder: (context, state) {
                  if (state is InvoiceLoading) return _buildLoadingIndicator();
                  if (state is InvoiceLoaded) {
                    return buildInvoiceList(
                        invoices: state.invoices,
                        refreshIndicatorKey: refreshIndicatorKey,
                        onRefresh: _fetchInvoices,
                        context: context,
                        fromDate: fromDate,
                        endDate: endDate,
                        partyId: widget.partyId ?? 0,
                        vehicleId: vehicleId,
                        companyId: companyId);
                  }
                  if (state is InvoiceError) {
                    Future.delayed(const Duration(seconds: 2), () {
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(index: 1),
                        ),
                      );
                    });
                    return _buildErrorMessage("Something Went Wrong");
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() =>
      const Center(child: CircularProgressIndicator());

  Widget _buildErrorMessage(String message) {
    return Center(
      child: Text(
        "Error: $message",
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    );
  }

  String _getEndDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String _getFromDate(int daysAgo) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: daysAgo)));
  }
}
