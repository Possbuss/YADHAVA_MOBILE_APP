import 'package:flutter/material.dart';

import '../../../../../core/constants/color.dart';

class SalesTableHeader extends StatelessWidget {
  const SalesTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colour.lightblack,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Invoice No', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text('Total', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text('Net Total', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}