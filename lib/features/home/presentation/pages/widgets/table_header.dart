import 'package:flutter/material.dart';

import '../../../../../core/constants/color.dart';

class StockTableHeader extends StatelessWidget {
  const StockTableHeader({super.key});

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
          Text('Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text('Quantity', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text('Srt', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text('Price', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}