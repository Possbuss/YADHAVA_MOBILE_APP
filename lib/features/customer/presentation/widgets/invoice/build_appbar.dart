import 'package:flutter/material.dart';

import '../../../../../core/constants/color.dart';

AppBar buildAppBar(context) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colour.pDeepLightBlue,
    title: const Text(
      "Invoices",
      style: TextStyle(
        color: Colour.SilverGrey,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    leading: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Icon(Icons.arrow_back_ios, color: Colors.grey),
    ),
  );
}
