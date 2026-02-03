import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/util/format_rupees.dart';

class InvoiceCard extends StatelessWidget {
  final String branchName;
  final String salesManName;
  final String invoiceType;
  final String invoiceNo;
  final String invoiceDate;
  final double netTotal;
  // final VoidCallback onDelete; // Callback for delete action

  const InvoiceCard({
    super.key,
    required this.branchName,
    required this.salesManName,
    required this.invoiceType,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.netTotal,
    // required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colour.lightblack,
            border: Border.all(
              color: Colour.blackgery,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Branch Name:",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          branchName,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Salesman Name:",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          salesManName,
                          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Invoice Type:",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          invoiceType,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Invoice No:",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          invoiceNo,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Invoice Date:",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          invoiceDate,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Net Total:",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          formatRupees(netTotal),
                          style: const TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Positioned(
        //   right: 10,
        //   top: 10,
        //   child: IconButton(
        //     icon: const Icon(
        //       Icons.delete,
        //       color: Colors.red,
        //     ),
        //     onPressed: onDelete,
        //   ),
        // ),
      ],
    );
  }
}
