// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:posbuss_milk/features/customer/presentation/pages/cash_recept/widgets/custom_dropdown.dart';
// import 'package:posbuss_milk/features/customer/presentation/pages/cash_recept/widgets/custom_textformfield.dart';
// import 'package:posbuss_milk/features/customer/presentation/pages/customer_details/widget/custom_button.dart';
// import '../../../../auth/data/login_model.dart';
// import '../../../../auth/domain/login_repo.dart';
// import '../../bloc/create_voucher/create_voucher_bloc.dart';
// import '../../bloc/create_voucher/create_voucher_event.dart';
// import '../../bloc/create_voucher/create_voucher_state.dart';
// import '../customer_details/widget/custom_feild.dart';
//
// class VoucherScreen extends StatefulWidget {
//   final int? clientId;
//
//   const VoucherScreen({super.key, this.clientId});
//
//   @override
//   _VoucherScreenState createState() => _VoucherScreenState();
// }
//
// class _VoucherScreenState extends State<VoucherScreen> {
//   String selectedPayMode = "Select Payment Mode";
//   String selectedVoucherType = "Select Voucher Type";
//   List<String> selectedPayModeList = ["CASH", "BANK"];
//   List<String> selectedVoucherTypeList = ["PAYMENT", "RECEIPT"];
//
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController transactionYearController = TextEditingController();
//   final TextEditingController paidAmountController = TextEditingController();
//   final TextEditingController voucherDateController = TextEditingController();
//   final TextEditingController payModeController = TextEditingController();
//   GetLoginRepo loginRepo = GetLoginRepo();
//
//   @override
//   void dispose() {
//     transactionYearController.dispose();
//     paidAmountController.dispose();
//     voucherDateController.dispose();
//     payModeController.dispose();
//     super.dispose();
//   }
//
//   void onDropdownChangedPayMode(String value) {
//     setState(() {
//       selectedPayMode = value;
//     });
//   }
//
//   void onDropdownChangedVoucherType(String value) {
//     setState(() {
//       selectedVoucherType = value;
//     });
//   }
//
//   void _submitVoucher() async {
//     LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
//     DateTime startDate = DateTime.now();
//     String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
//
//     if (_formKey.currentState!.validate()) {
//       final Map<String, dynamic> voucherData = {
//         "companyId": storedResponse!.companyId,
//         "customerId": widget.clientId,
//         "voucherNo": "",
//         "voucherDate": formattedStartDate,
//         "payMode": selectedPayMode,
//         "voucherType": selectedVoucherType,
//         "paidAmount": double.parse(paidAmountController.text),
//         "transactionYear": DateFormat('yyyy').format(DateTime.now()),
//         "userId": storedResponse.userId
//       };
//
//       context.read<VoucherBloc>().add(CreateVoucherEvent(voucherData));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Create Voucher")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: BlocConsumer<VoucherBloc, VoucherState>(
//           listener: (context, state) {
//             if (state is VoucherSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text("Voucher Created: ${state.voucherId}")),
//               );
//             } else if (state is VoucherFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.error)),
//               );
//             }
//           },
//           builder: (context, state) {
//             return Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     ReusableVoucherTextField(
//                         label: 'Paid Amount',
//                         hintText: "Enter Paid Amount", controller: paidAmountController),
//                     const SizedBox(height: 8,),
//
//                     ReusableVoucherTextField(
//                       onTap: () async {
//                         DateTime? pickedDate = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime(2000),
//                           lastDate: DateTime(2100),
//                         );
//                         if (pickedDate != null) {
//                           voucherDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
//                         }
//                       },
//                       label: "Voucher Date",
//                       hintText: "Voucher Date",
//                       controller: voucherDateController,
//                     ),
//                     const SizedBox(height: 8,),
//                     VoucherCustomDropDown(
//                         items: selectedPayModeList,
//                         selectedValue: selectedPayMode,
//                         onChanged: onDropdownChangedPayMode, label: 'Payment Mode',
//                     ),
//                     const SizedBox(height: 8,),
//
//                     VoucherCustomDropDown(
//                         items: selectedVoucherTypeList,
//                         selectedValue: selectedVoucherType,
//                         onChanged: onDropdownChangedVoucherType, label: 'Voucher Type',
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     state is VoucherLoading
//                         ? const CircularProgressIndicator()
//                         : CustomButton(onPressed: _submitVoucher, B_text: "Create Voucher")
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:Yadhava/features/customer/presentation/bloc/cash_recipt_bloc/cash_receipt_bloc.dart';
import 'package:Yadhava/features/customer/presentation/bloc/client_bloc/client_list_bloc.dart';
import 'package:Yadhava/features/customer/presentation/bloc/client_create/client_create_bloc.dart';
import 'package:Yadhava/features/customer/presentation/pages/cash_recept/widgets/custom_dropdown.dart';
import 'package:Yadhava/features/customer/presentation/pages/cash_recept/widgets/qr_popup.dart';
import 'package:Yadhava/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:Yadhava/features/splash/data/getall_company_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../auth/data/login_model.dart';
import '../../../../auth/domain/login_repo.dart';
import '../../../../splash/domain/repository.dart';
import '../../../model/cash_receipt_model.dart';
import '../../bloc/create_voucher/create_voucher_bloc.dart';
import '../../bloc/create_voucher/create_voucher_event.dart';
import '../../bloc/create_voucher/create_voucher_state.dart';
import '../customer_details/widget/custom_button.dart';
import '../customer_details/widget/custom_feild.dart';

class VoucherScreen extends StatefulWidget {
  final int? clientId;

  const VoucherScreen({super.key, this.clientId});

  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  String selectedPayMode = "Select Payment Mode";
  String selectedVoucherType = "Select Voucher Type";
  List<String> selectedPayModeList = ["CASH", "BANK"];
  List<String> selectedVoucherTypeList = ["PAYMENT", "RECEIPT"];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController transactionYearController =
      TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();
  final TextEditingController voucherDateController = TextEditingController();
  final TextEditingController payModeController = TextEditingController();
  GetLoginRepo loginRepo = GetLoginRepo();
  final GetCompanyListRepo companyListRepo = GetCompanyListRepo();

  late String endDate;
  late String UPIId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFirstCompanyId();
    endDate = _getEndDate();
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

  Future<void> getFirstCompanyId() async {
    List<GetAllCompanyModel> companies =
        await companyListRepo.getStoredCompanyDetails();
    UPIId = (companies.isNotEmpty ? companies.first.upiId : null)!;
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

  // void _submitVoucher() async {
  //   print('clicked');
  //   LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
  //   DateTime startDate = DateTime.now();
  //   String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
  //   if (selectedPayMode.isNotEmpty && selectedVoucherType.isNotEmpty) {
  //     if (_formKey.currentState!.validate()) {
  //       final Map<String, dynamic> voucherData = {
  //         "companyId": storedResponse!.companyId,
  //         "customerId": widget.clientId,
  //         "voucherNo": "",
  //         "voucherDate": voucherDateController.text,
  //         "payMode": selectedPayMode,
  //         "voucherType": selectedVoucherType,
  //         "paidAmount": double.parse(paidAmountController.text),
  //         "transactionYear": DateFormat('yyyy').format(DateTime.now()),
  //         "userId": storedResponse.userId,
  //         "vehicleId": storedResponse.vehicleId,
  //         "routeId": storedResponse.routeId,
  //         "driverId": storedResponse.employeeId
  //       };
  //
  //       context.read<VoucherBloc>().add(CreateVoucherEvent(voucherData));
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Voucher"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => QRCodePopup(upiId: UPIId),
              );
            },
            icon: const Icon(Icons.qr_code, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<VoucherBloc, VoucherState>(
          listener: (context, state) {
            if (state is VoucherSuccess) {



              //_getReceipttData();

              final id = state.voucherId;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Success"),
                    content:
                        Text("Voucher Created  Successfully!\nVoucher No: $id"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          Navigator.of(context)
                              .pop(true); // Navigate back if needed
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  );
                },
              );
            } else if (state is VoucherFailure) {
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required";
                          }
                        },
                        keyboardType: TextInputType.number,
                        label: 'Paid Amount',
                        hintText: "Enter Paid Amount",
                        controller: paidAmountController),
                    const SizedBox(
                      height: 8,
                    ),
                    ReusableVoucherTextField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "required";
                        }
                      },
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
                        if (selectedPayMode.isEmpty ||
                            selectedPayMode == "Select Payment Mode") {
                          return "Please select a payment mode";
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
                        if (selectedVoucherType.isEmpty ||
                            selectedVoucherType == 'Select Voucher Type') {
                          return 'required';
                        }
                        return null;
                      },
                      items: selectedVoucherTypeList,
                      selectedValue: selectedVoucherType,
                      onChanged: onDropdownChangedVoucherType,
                      label: 'Voucher Type',
                    ),
                    const SizedBox(height: 20),
                    state is VoucherLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                print("ccccccccccccccccccccc");
                                print("validated");
                                LoginModel? storedResponse =
                                    await loginRepo.getUserLoginResponse();
                                DateTime startDate = DateTime.now();
                                String formattedStartDate =
                                    DateFormat('yyyy-MM-dd').format(startDate);
                                if (selectedPayMode.isNotEmpty &&
                                    selectedVoucherType.isNotEmpty) {


                                  final CashReceiptModel voucherData =
                                  CashReceiptModel(
                                      companyId: storedResponse!.companyId,
                                      customerId: widget.clientId ?? 0,
                                      customerName: "",
                                      voucherNo: "",
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


                                  context
                                      .read<VoucherBloc>()
                                      .add(CreateVoucherEvent(voucherData));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Enter paid amount')));
                              }
                            },
                            B_text: "Create Voucher")
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
