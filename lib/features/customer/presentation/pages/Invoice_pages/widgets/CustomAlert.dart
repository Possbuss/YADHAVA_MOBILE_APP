import 'package:flutter/material.dart';

void showCustomAlert({
  required BuildContext context,
  required String button1Text,
  required VoidCallback onButton1Press,
  required String button2Text,
  required VoidCallback onButton2Press,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Custom Alert"),
        content: const Text("Are you sure you want to proceed?"),
        actions: [
          TextButton(
            onPressed: onButton1Press,
            child: Text(button1Text),
          ),
          ElevatedButton(
            onPressed: onButton2Press,
            child: Text(button2Text),
          ),
        ],
      );
    },
  );
}
