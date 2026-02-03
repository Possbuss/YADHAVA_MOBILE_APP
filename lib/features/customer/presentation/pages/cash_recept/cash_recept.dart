// // import 'dart:ffi';
// //
// // import 'package:Yadhava/features/customer/presentation/pages/cash_recept/widgets/cassh_recept_serachbar.dart';
// // import 'package:Yadhava/features/customer/presentation/pages/cash_recept/widgets/header.dart';
// // import 'package:Yadhava/features/customer/presentation/pages/cash_recept/widgets/receipt_list.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:intl/intl.dart';
// //
// // import '../../../../auth/data/login_model.dart';
// // import '../../../../auth/domain/login_repo.dart';
// // import '../../../model/cash_receipt_model.dart';
// // import '../../bloc/cash_recipt_bloc/cash_receipt_bloc.dart';
// // import 'create_cashreceipt.dart';
// //
// // class CashRecept extends StatefulWidget {
// //   final int? clientId;
// //    CashRecept({super.key,  this.clientId});
// //
// //   @override
// //   State<CashRecept> createState() => _CashReceptState();
// // }
// //
// // class _CashReceptState extends State<CashRecept> {
// //
// //   GetLoginRepo loginRepo = GetLoginRepo();
// //
// //   @override
// //   void initState() {
// //     postData();
// //     // TODO: implement initState
// //     super.initState();
// //   }
// //
// //   Future<void> postData() async {
// //     LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
// //     DateTime endDate = DateTime.now();
// //     DateTime startDate = DateTime(endDate.year, endDate.month-1, endDate.day);
// //
// //     String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
// //     String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
// //
// //     final receiptData = {
// //       "customerId": widget.clientId,
// //       "companyId": storedResponse!.companyId,
// //       "startDate": formattedStartDate,
// //       "endDate": formattedEndDate
// //     };
// //     context.read<CashReceiptBloc>().add(CashReceiptGetEvent(receiptData));
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //
// //       floatingActionButton: FloatingActionButton(
// //         child: Icon(Icons.add),
// //           onPressed: (){
// //                Navigator.push(context, MaterialPageRoute(builder: (context)=>VoucherScreen(clientId: widget.clientId,)));
// //       }),
// //       body: BlocBuilder<CashReceiptBloc, CashReceiptState>(
// //         builder: (context, state) {
// //           if(state is CashReceiptLoading){
// //             return const Center(child: CircularProgressIndicator());
// //           }else if(state is CashReceiptError)
// //           {
// //             return Icon(Icons.error);
// //           }else if(state is CashReceiptLoaded) {
// //              List<CashReceiptModel> receipts=state.response;
// //
// //             return Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 SizedBox(height: 40),
// //                 Padding(
// //                   padding: EdgeInsets.all(16),
// //                   child: CashReciptSearchBar(),
// //                 ),
// //                 SizedBox(height: 10),
// //                 Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 16.0),
// //                   child: CashReceiptSectionHeader(title: "Cash Recept"),
// //                 ),
// //                 SizedBox(height: 10),
// //                 Expanded(
// //                   child: ReceiptList(receipts: receipts,),
// //                 ),
// //               ],
// //             );
// //
// //           }else{
// //            return Center(
// //               child: const SizedBox(
// //                 child: Text("Something Went Wrong"),
// //               ),
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
// import 'package:Yadhava/core/constants/color.dart';
// import 'package:Yadhava/features/customer/presentation/pages/cash_recept/widgets/cassh_recept_serachbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
//
// import '../../../../auth/data/login_model.dart';
// import '../../../../auth/domain/login_repo.dart';
// import '../../../model/cash_receipt_model.dart';
// import '../../bloc/cash_recipt_bloc/cash_receipt_bloc.dart';
//
// // Your custom widgets:
// import 'widgets/header.dart';
// import 'widgets/receipt_list.dart';
// import 'create_cashreceipt.dart';
//
// class CashRecept extends StatefulWidget {
//   final int? clientId;
//   const CashRecept({Key? key, this.clientId}) : super(key: key);
//
//   @override
//   State<CashRecept> createState() => _CashReceptState();
// }
//
// class _CashReceptState extends State<CashRecept> {
//   final GetLoginRepo loginRepo = GetLoginRepo();
//
//   @override
//   void initState() {
//     super.initState();
//     postData();
//   }
//
//   Future<void> postData() async {
//     LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
//
//     // Calculate date range
//     DateTime endDate = DateTime.now();
//     DateTime startDate = DateTime(endDate.year, endDate.month - 1, endDate.day);
//
//     String formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
//     String formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
//
//     // Create the payload for your bloc event
//     final receiptData = {
//       "customerId": widget.clientId,
//       "companyId": storedResponse?.companyId,
//       "startDate": formattedStartDate,
//       "endDate": formattedEndDate,
//     };
//
//     // Trigger your bloc to fetch data
//     context.read<CashReceiptBloc>().add(CashReceiptGetEvent(receiptData));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // FAB to create a new voucher
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => VoucherScreen(clientId: widget.clientId),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//
//       // Listen to bloc state changes
//       body: BlocBuilder<CashReceiptBloc, CashReceiptState>(
//         builder: (context, state) {
//           if (state is CashReceiptLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is CashReceiptError) {
//             return const Center(child: Icon(Icons.error, color: Colour.pWhite,));
//           } else if (state is CashReceiptLoaded) {
//             final List<CashReceiptModel> receipts = state.response;
//
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 50),
//                 // const Padding(
//                 //   padding: EdgeInsets.all(16),
//                 //   child: CashReciptSearchBar(),
//                 // ),
//                 const SizedBox(height: 10),
//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                   child: CashReceiptSectionHeader(title: "Cash Receipt"),
//                 ),
//                 // const SizedBox(height: 10),
//                 Expanded(
//                   child: ReceiptList(receipts: receipts, clientId: widget.clientId,),
//                 ),
//               ],
//             );
//           } else {
//             return const Center(
//               child: Text("Something Went Wrong"),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//
//
//
// }

import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/features/customer/presentation/pages/cash_recept/widgets/cassh_recept_serachbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../auth/data/login_model.dart';
import '../../../../auth/domain/login_repo.dart';
import '../../../model/cash_receipt_model.dart';
import '../../bloc/cash_recipt_bloc/cash_receipt_bloc.dart';

// Your custom widgets:
import 'widgets/header.dart';
import 'widgets/receipt_list.dart';
import 'create_cashreceipt.dart';

class CashRecept extends StatefulWidget {
  final int? clientId;
  const CashRecept({Key? key, this.clientId}) : super(key: key);

  @override
  State<CashRecept> createState() => _CashReceptState();
}

class _CashReceptState extends State<CashRecept> {
  final GetLoginRepo loginRepo = GetLoginRepo();

  @override
  void initState() {
    super.initState();
    postData();
  }

  Future<void> postData() async {
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
      "forceRefresh": false
    };

    // Trigger your bloc to fetch data
    context.read<CashReceiptBloc>().add(CashReceiptGetEvent(receiptData,widget.clientId ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VoucherScreen(clientId: widget.clientId),
            ),
          );

          // Refresh the list when returning from VoucherScreen
          if (result == true) {
            postData();
          }
        },
        child: const Icon(Icons.add),
      ),

      // BlocBuilder for state management
      body: BlocBuilder<CashReceiptBloc, CashReceiptState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: postData, // Refresh action
            child: state is CashReceiptLoading
                ? const Center(child: CircularProgressIndicator())
                : state is CashReceiptError
                    ? const Center(
                        child: Icon(Icons.error, color: Colour.pWhite))
                    : state is CashReceiptLoaded
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: CashReceiptSectionHeader(
                                    title: "Cash Receipt"),
                              ),
                              Expanded(
                                child: ReceiptList(
                                    receipts: state.response,
                                    clientId: widget.clientId,
                                onVoucherUpdated: () => postData(),),
                              ),
                            ],
                          )
                        : const Center(child: Text("Something Went Wrong")),
          );
        },
      ),
    );
  }
}
