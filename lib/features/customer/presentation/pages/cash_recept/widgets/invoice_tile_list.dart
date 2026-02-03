import 'package:flutter/material.dart';
import '../../../../../../core/constants/color.dart';
import '../../../../../../core/util/format_rupees.dart';

class InvoiceListTile extends StatelessWidget {
  final String branchName;
  final String salesManName;
  final String invoiceNo;
  final String invoiceDate;
  final double netTotal;

  const InvoiceListTile({
    super.key,
    required this.branchName,
    required this.salesManName,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.netTotal,
  });

  @override
  Widget build(BuildContext context) {

    final bool isInvoiceMissing = invoiceNo.trim().isEmpty;

    return Card(
      color: isInvoiceMissing ? Colour.lightOrange : Colour.lightblack,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colour.blackgery, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: Colors.green, // You can set dynamic colors
          child: Text(
            salesManName.isNotEmpty ? salesManName[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          "$salesManName - $branchName",
          style: isInvoiceMissing ? TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold) : TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "Invoice No: $invoiceNo\nInvoice Date: $invoiceDate",
          style: isInvoiceMissing ? TextStyle(color: Colors.red, fontSize: 13) : TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing: Text(
          formatRupees(netTotal),
          style: isInvoiceMissing ? TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold) : TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
