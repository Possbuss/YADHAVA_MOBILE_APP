import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/color.dart';

class BalanceSection extends StatelessWidget {
  final String balance;
  final String orderNo;
  final String date;

  const BalanceSection({super.key,
    required this.balance,
    required this.orderNo,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colour.pDeepLightBlue,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           const Text(
            "Balance",
            style: TextStyle(color: Colour.pWhite, fontSize: 14,fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 4),
          Text(
            balance,
            style: const TextStyle(
                color: Colour.pWhite, fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "Order No : $orderNo",
            style: const TextStyle(
                color: Colour.SilverGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
          Text(
              "Date:  $date",
            style: const TextStyle(
                color: Colour.SilverGrey,
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
