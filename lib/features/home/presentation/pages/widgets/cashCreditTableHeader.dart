import 'package:flutter/material.dart';

import '../../../../../core/constants/color.dart';

class cashCreditTableheader extends StatelessWidget {
  const cashCreditTableheader({super.key});

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
          Text('Customer Name',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text('Debit',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text('Credit',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
