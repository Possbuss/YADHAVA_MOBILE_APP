import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/color.dart';
import '../../../data/client_model.dart';
import '../../pages/customer_details/detail_page.dart';

Widget buildFloatingActionButton({
  required BuildContext context,
  required ClientModel client,
  required int companyId,
  required String endDate,
  required String fromDate,
  required int vehicleId,
  required VoidCallback onTap,
  required VoidCallback onThen,
}) {
  return FloatingActionButton(
    child: const Icon(Icons.add, color: Colour.pDeepLightBlue),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerDetails(
            client: client,
            companyId: companyId,
            endDate: endDate,
            fromDate: fromDate,
            vehicleId: vehicleId,
            onOrderSaved: onTap,
          ),
        ),
      ).then((_) => onThen());
    },
  );
}

