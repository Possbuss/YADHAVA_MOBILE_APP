// import 'package:Yadhava/features/customer/presentation/pages/cash_recept/widgets/VoucherList.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../model/cash_receipt_model.dart';
//
//
//
// class ReceiptList extends StatelessWidget {
//   final List<CashReceiptModel> receipts;
//
//   const ReceiptList({super.key, required this.receipts});
//
//   Widget build(BuildContext context) {
//     return receipts.isEmpty
//         ? const Center(child: Text("No Receipts Available"))
//         : Column(
//       children: [
//          Expanded(
//            child: ListView.builder(
//              itemCount: receipts.length,
//              itemBuilder: (context,index){
//                final receipt=receipts[index];
//                return VoucherListTile(
//                    title: receipt.customerName,
//                    subtitle: receipt.payMode,
//                    invoiceNo: receipt.voucherNo,
//                    invoiceDate: receipt.voucherDate,
//                    paidAmount: receipt.paidAmount
//                );
//              },
//
//            ),
//          )
//       ]
//
//     );
//
//   }
// }

import 'package:Yadhava/core/constants/color.dart';
import 'package:flutter/material.dart';
import '../../../../model/cash_receipt_model.dart';
import '../update_voucher.dart';
import 'VoucherList.dart';

class ReceiptList extends StatelessWidget {
  final int? clientId;
  final List<CashReceiptModel> receipts;
  final VoidCallback? onVoucherUpdated; // ✅ add this


  const ReceiptList({Key? key,
    required this.clientId,
    required this.receipts,
  this.onVoucherUpdated,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if (receipts.isEmpty) {
      return const Center(
        child: Text(
          "No Receipts Available",
          style: TextStyle(color: Colour.mediumGray2),
        ),
      );
    }

    return ListView.builder(
      itemCount: receipts.length,
      itemBuilder: (context, index) {
        final receipt = receipts[index];
        return InkWell(
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateVoucherScreen(
                  date: receipt.voucherDate,
                  paidAmount: receipt.paidAmount,
                  payMode: receipt.payMode,
                  voucherNo: receipt.voucherNo,
                  voucherType: receipt.voucherType,
                  clientId: clientId,

                ),
              ),
            );

            // ✅ Trigger refresh if update was successful
            if (result == true && onVoucherUpdated != null) {
              onVoucherUpdated!();
            }
          },
          child: VoucherListTile(
            voucherType: receipt.voucherType,
            title: receipt.customerName,
            subtitle: receipt.voucherNo,
            invoiceNo: receipt.payMode,
            invoiceDate: receipt.voucherDate,
            paidAmount: receipt.paidAmount,
          ),
        );
      },
    );
  }

}
