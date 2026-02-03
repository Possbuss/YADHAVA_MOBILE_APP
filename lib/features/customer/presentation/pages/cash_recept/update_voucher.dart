import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/features/customer/presentation/bloc/cash_recipt_bloc/cash_receipt_bloc.dart';
import 'package:Yadhava/features/customer/presentation/bloc/client_bloc/client_list_bloc.dart';
import 'package:Yadhava/features/customer/presentation/pages/cash_recept/widgets/custom_dropdown.dart';
import 'package:Yadhava/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../auth/data/login_model.dart';
import '../../../../auth/domain/login_repo.dart';
import '../../../model/cash_receipt_model.dart';
import '../../bloc/create_voucher/create_voucher_bloc.dart';
import '../../bloc/create_voucher/create_voucher_event.dart';
import '../../bloc/create_voucher/create_voucher_state.dart';
import '../../bloc/update_cashreciept_bloc/create_voucher_bloc.dart';
import '../../bloc/update_cashreciept_bloc/create_voucher_event.dart';
import '../../bloc/update_cashreciept_bloc/create_voucher_state.dart';
import '../customer_details/widget/custom_button.dart';
import '../customer_details/widget/custom_feild.dart';

class UpdateVoucherScreen extends StatefulWidget {
  final String payMode;
  final String voucherType;
  final double paidAmount;
  final int? clientId;
  final String date;
  final String voucherNo;

  const UpdateVoucherScreen(
      {super.key,
      this.clientId,
      required this.date,
      required this.voucherNo,
      required this.payMode,
      required this.voucherType,
      required this.paidAmount});

  @override
  _UpdateVoucherScreenState createState() => _UpdateVoucherScreenState();
}

class _UpdateVoucherScreenState extends State<UpdateVoucherScreen> {
  late String selectedPayMode;
  late String selectedVoucherType;
  List<String> selectedPayModeList = ["CASH", "BANK"];
  List<String> selectedVoucherTypeList = ["PAYMENT", "RECEIPT"];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController transactionYearController =
      TextEditingController();
  late TextEditingController paidAmountController;
  late TextEditingController voucherDateController;
  final TextEditingController payModeController = TextEditingController();
  late String endDate;
  GetLoginRepo loginRepo = GetLoginRepo();

  @override
  void initState() {
    paidAmountController =
        TextEditingController(text: widget.paidAmount.toString());
    voucherDateController = TextEditingController(text: widget.date.toString());
    selectedPayMode = widget.payMode;
    selectedVoucherType = widget.voucherType;
    endDate = _getEndDate();
    // TODO: implement initState
    super.initState();
  }

  String _getEndDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    transactionYearController.dispose();
    paidAmountController.dispose();
    voucherDateController.dispose();
    payModeController.dispose();
    super.dispose();
  }

  void onDropdownChangedPayMode(String value) {
    setState(() {
      selectedPayMode = value;
    });
  }

  void onDropdownChangedVoucherType(String value) {
    setState(() {
      selectedVoucherType = value;
    });
  }

  void _submitVoucher() async {
    LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
    DateTime startDate = DateTime.now();
    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);

    if (_formKey.currentState!.validate()) {
      final CashReceiptModel voucherData =
      CashReceiptModel(
          companyId: storedResponse!.companyId,
          customerId: widget.clientId ?? 0,
          customerName: "",
          voucherNo: widget.voucherNo,
          voucherDate: voucherDateController.text,
          payMode: selectedPayMode,
          voucherType: selectedVoucherType,
          paidAmount: double.parse(paidAmountController.text),
          transactionYear: DateFormat('yyyy').format(DateTime.now()),
          userId: storedResponse.userId,
          vehicleId: storedResponse.vehicleId,
          routeId: storedResponse.routeId,
          driverId: storedResponse.employeeId
      );



      //final Map<String, dynamic> voucherData = {
      //  "companyId": storedResponse!.companyId,
      //  "customerId": widget.clientId,
      //  "voucherNo": widget.voucherNo,
      //  "voucherDate": formattedStartDate,
      //  "payMode": selectedPayMode,
      //  "voucherType": selectedVoucherType,
      //  "paidAmount": double.parse(paidAmountController.text),
      //  "transactionYear": DateFormat('yyyy').format(DateTime.now()),
      //  "userId": storedResponse.userId,
      //  "vehicleId": storedResponse.vehicleId,
      //  "routeId": storedResponse.routeId,
      //  "driverId": storedResponse.employeeId
      //};

      context.read<VoucherUpdateBloc>().add(UpdateVoucherEvent(voucherData));
      //Navigator.pop(context);
    }
  }

  Future<void> _getReceipttData() async {
    LoginModel? storedResponse = await loginRepo.getUserLoginResponse();

    // Calculate date range
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(endDate.year, endDate.month - 1, endDate.day);

    String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

    // Create the payload for your bloc event
    final receiptData = {
      "customerId": widget.clientId,
      "companyId": storedResponse?.companyId,
      "startDate": formattedStartDate,
      "endDate": formattedEndDate,
      "forceRefresh": true
    };

    // Trigger your bloc to fetch data
    context.read<CashReceiptBloc>().add(CashReceiptGetEvent(receiptData,widget.clientId ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.voucherNo),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colour.pWhite),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<VoucherUpdateBloc, VoucherUpdateState>(
          listener: (context, state) {
            if (state is VoucherUpdateSuccess) {
              Navigator.of(context).pop(true);


              //context.read<ClientListBloc>().add(const ClientListGetEvent());
              //context.read<HomeBloc>().add(HomeGetEvent(endDate, forceRefresh: true));
              //_getReceipttData();

              final id = state.voucherId;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Success"),
                    content:
                        Text("Voucher Updated  Successfully!\nVoucher No: $id"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          //Navigator.of(context).pop(true);

                          // Use a post-frame callback to safely pop the screen after the dialog
                          Future.delayed(Duration(milliseconds: 100), () {
                            Navigator.of(context).pop(true); // ✅ Return true to trigger refresh
                          });
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            } else if (state is UpdateVoucherFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Something Went Wrong")),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ReusableVoucherTextField(
                        keyboardType: TextInputType.number,
                        label: 'Paid Amount',
                        hintText: "Enter Paid Amount",
                        controller: paidAmountController),
                    const SizedBox(
                      height: 8,
                    ),
                    ReusableVoucherTextField(
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          voucherDateController.text =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                        }
                      },
                      label: "Voucher Date",
                      hintText: "Voucher Date",
                      controller: voucherDateController,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    VoucherCustomDropDown(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "required";
                        }
                        return null;
                      },
                      items: selectedPayModeList,
                      selectedValue: selectedPayMode,
                      onChanged: onDropdownChangedPayMode,
                      label: 'Payment Mode',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    VoucherCustomDropDown(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "required";
                        }
                        return null;
                      },
                      items: selectedVoucherTypeList,
                      selectedValue: selectedVoucherType,
                      onChanged: onDropdownChangedVoucherType,
                      label: 'Voucher Type',
                    ),
                    const SizedBox(height: 20),
                    state is VoucherUpdateLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            onPressed: _submitVoucher, B_text: "Update Voucher")
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
