import 'package:flutter/material.dart';

import '../pages/customer_details/widget/custom_button.dart';

class DeleteConfirmationPopup {
  static Future<bool?> show(BuildContext context, String invoiceNo) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Delete Invoice",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Are you sure you want to delete this invoice?",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Invoice No: $invoiceNo",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            CustomButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                B_text: "Yes"),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                B_text: "No"),
          ],
        );
      },
    );
  }
}
