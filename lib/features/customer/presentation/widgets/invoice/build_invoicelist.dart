import 'package:Yadhava/features/customer/model/mobile_app_sales_Invoice_all.dart';
import 'package:Yadhava/features/customer/presentation/pages/cash_recept/widgets/invoice_tile_list.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/color.dart';
import '../../../model/InvoiceModel.dart';
import '../../pages/Invoice_pages/invoice_details.dart';

Widget buildInvoiceList({
  required List<MobileAppSalesInvoiceMaster> invoices,
  required GlobalKey<RefreshIndicatorState> refreshIndicatorKey,
  required VoidCallback onRefresh,
  required BuildContext context,
  required String fromDate,
  required String endDate,
  required int partyId,
  required int vehicleId,
  required int companyId,
}) {
  if (invoices.isEmpty) {
    return const Center(
      child: Text(
        "No invoices found.",
        style: TextStyle(color: Colour.pWhite, fontSize: 16),
      ),
    );
  }

  return RefreshIndicator(
    key: refreshIndicatorKey,
    onRefresh: () async => onRefresh(),
    child: ListView.builder(
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return GestureDetector(
          onTap: () async {

            if (invoice.invoiceNo.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Invoice Not Synced"),
                  duration: Duration(seconds: 2),
                ),
              );
              return; // prevent navigation
            }


            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InvoiceDetailsPage(
                  invoiceModel: invoice!,
                  fromDate: fromDate,
                  endDate: endDate,
                  partyId: partyId,
                  vehicleId: vehicleId,
                  companyId: companyId,
                ),
              ),
            );

            if (result == true) {
              // Refresh invoices when returning from InvoiceDetailsPage with success
              onRefresh();
            }
          },
          child: InvoiceListTile(
            branchName: invoice.branchName,
            salesManName: invoice.salesManName,
            // invoiceType: invoice.invoiceType,
            invoiceNo: invoice.invoiceNo,
            invoiceDate: invoice.invoiceDate,
            netTotal: invoice.netTotal,
          ),
        );
      },
    ),
  );
}
