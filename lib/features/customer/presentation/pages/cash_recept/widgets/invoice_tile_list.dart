import 'package:flutter/material.dart';
import '../../../../../../core/constants/color.dart';
import '../../../../../../core/util/format_rupees.dart';

class InvoiceListTile extends StatelessWidget {
  final String customerName;
  final String branchName;
  final String salesManName;
  final String invoiceNo;
  final String invoiceDate;
  final double netTotal;
  final VoidCallback? onPrint;

  const InvoiceListTile({
    super.key,
    required this.customerName,
    required this.branchName,
    required this.salesManName,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.netTotal,
    this.onPrint,
  });

  @override
  Widget build(BuildContext context) {

    final bool isInvoiceMissing = invoiceNo.trim().isEmpty;

    return Card(
      color: isInvoiceMissing ? Colour.lightOrange : Colour.lightblack,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colour.blackgery, width: 1),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: isInvoiceMissing
                  ? Colors.redAccent.withValues(alpha: 0.85)
                  : const Color(0xFF50C255),
              child: Text(
                customerName.isNotEmpty ? customerName[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branchName.trim().isNotEmpty ? branchName : customerName,
                    style: isInvoiceMissing
                        ? const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                        : const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Invoice No: $invoiceNo",
                    style: isInvoiceMissing
                        ? const TextStyle(color: Colors.red, fontSize: 13)
                        : const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Invoice Date: $invoiceDate",
                    style: isInvoiceMissing
                        ? const TextStyle(color: Colors.red, fontSize: 13)
                        : const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  if (salesManName.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      "Salesman: $salesManName",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    formatRupees(netTotal),
                    style: isInvoiceMissing
                        ? const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )
                        : const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onPrint,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: onPrint == null
                            ? Colors.white.withValues(alpha: 0.03)
                            : Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.print_outlined,
                        size: 20,
                        color: onPrint == null ? Colors.white24 : Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
