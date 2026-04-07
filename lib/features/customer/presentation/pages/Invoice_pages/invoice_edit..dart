import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget editInvoice(BuildContext context, {String? customerName}){
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevents it from taking full height
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Edit Invoice",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (customerName != null && customerName.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              customerName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              labelText: "Invoice Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add save logic here
                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}