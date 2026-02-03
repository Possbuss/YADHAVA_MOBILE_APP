import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../../core/constants/color.dart';

class QRCodePopup extends StatelessWidget {
  final String upiId;

  const QRCodePopup({super.key, required this.upiId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colour.lightblack,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        "UPI QR Code",
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QrImageView(
            data: upiId,
            version: QrVersions.auto,
            size: 200.0,
            backgroundColor: Colors.white,
          ),
          const SizedBox(height: 10),
          Text(
            "UPI Id:$upiId",
            style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
