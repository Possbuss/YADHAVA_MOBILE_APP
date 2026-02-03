import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/color.dart';

class ItemCard extends StatelessWidget {
  final String name;
  final String code;
  final String quantity;
  final String srt;
  final String factor;
  final String unit;
  final String sellPrice;
  final String total;

  const ItemCard({super.key,
    required this.name,
    required this.code,
    required this.quantity,
    required this.srt,
    required this.factor,
    required this.unit,
    required this.sellPrice,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colour.lightblack,
        border: Border.all(
          color: Colour.blackgery,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Name",
                  style: TextStyle(color: Colour.mediumGray, fontSize: 12),
                ),
                Row(
                  children: [
                    const Text(
                      "Code: ",
                      style: TextStyle(color: Colour.mediumGray, fontSize: 12),
                    ),
                    Text(
                      "$code",
                      style: const TextStyle(color: Colour.SilverGrey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(color: Colour.SilverGrey, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colour.blackgery,
              height: 1.0,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      "Qty",
                      style: TextStyle(
                          color: Colour.mediumGray,
                          fontSize: 12), // Header color
                    ),
                    Text(
                      "$quantity",
                      style: const TextStyle(
                          color: Colour.SilverGrey,
                          fontSize: 12), // Value color
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Foc",
                      style: TextStyle(
                          color: Colour.mediumGray,
                          fontSize: 12), // Header color
                    ),
                    Text(
                      "$factor",
                      style: const TextStyle(
                          color: Colour.SilverGrey,
                          fontSize: 12), // Value color
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Srt",
                      style: TextStyle(
                          color: Colour.mediumGray,
                          fontSize: 12), // Header color
                    ),
                    Text(
                      "$srt",
                      style: const TextStyle(
                          color: Colour.SilverGrey,
                          fontSize: 12), // Value color
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Uom",
                      style: TextStyle(
                          color: Colour.mediumGray,
                          fontSize: 12), // Header color
                    ),
                    Text(
                      "$unit",
                      style: const TextStyle(
                          color: Colour.SilverGrey,
                          fontSize: 12), // Value color
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Sell",
                      style: TextStyle(
                          color: Colour.mediumGray,
                          fontSize: 12), // Header color
                    ),
                    Text(
                      "$sellPrice",
                      style: const TextStyle(
                          color: Colour.SilverGrey,
                          fontSize: 12), // Value color
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(
                          color: Colour.mediumGray,
                          fontSize: 12), // Header color
                    ),
                    Text(
                      "$total",
                      style: const TextStyle(
                          color: Colour.SilverGrey,
                          fontSize: 12), // Value color
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
