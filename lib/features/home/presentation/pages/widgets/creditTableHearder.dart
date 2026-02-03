import 'package:flutter/material.dart';

import '../../../../../core/constants/color.dart';

class CreditTableHeader extends StatelessWidget {
  const CreditTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colour.lightblack,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Credit Customer',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text('Amount',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
