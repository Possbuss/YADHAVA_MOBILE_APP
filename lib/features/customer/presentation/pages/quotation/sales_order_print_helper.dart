import 'dart:io';

import 'package:Yadhava/features/auth/data/login_model.dart';
import 'package:Yadhava/features/customer/data/sales_quotation_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SalesOrderPrintHelper {
  static Future<void> printSalesOrder({
    required SalesQuotation quotation,
    required LoginModel loginModel,
  }) async {
    final file = await _generateSalesOrderPdf(
      quotation: quotation,
      loginModel: loginModel,
    );
    await OpenFile.open(file.path);
  }

  static Future<File> _generateSalesOrderPdf({
    required SalesQuotation quotation,
    required LoginModel loginModel,
  }) async {
    final pdf = pw.Document();
    final Uint8List logoBytes = await rootBundle
        .load('assets/images/appLogo-removebg-preview.png')
        .then((value) => value.buffer.asUint8List());
    final pw.ImageProvider logoImage = pw.MemoryImage(logoBytes);
    final String documentNumber = quotation.quoteNo.isNotEmpty
        ? quotation.quoteNo
        : 'DRAFT-${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}';
    final String createdOn = DateFormat(
      'dd MMM yyyy hh:mm a',
    ).format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(18),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(10),
              border: pw.Border.all(color: PdfColors.grey400, width: 0.8),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 74,
                  height: 74,
                  margin: const pw.EdgeInsets.only(right: 16),
                  child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'SALES ORDER',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'Company ID: ${loginModel.companyId}',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      if (loginModel.vehicleName.isNotEmpty) ...[
                        pw.SizedBox(height: 3),
                        pw.Text(
                          'Vehicle: ${loginModel.vehicleName}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                      if (loginModel.routeName.isNotEmpty) ...[
                        pw.SizedBox(height: 3),
                        pw.Text(
                          'Route: ${loginModel.routeName}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                      pw.SizedBox(height: 3),
                      pw.Text(
                        'Salesman: ${quotation.salesManName}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  width: 180,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(color: PdfColors.grey400, width: 0.6),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildPdfInfoLine('Order No', documentNumber),
                      pw.SizedBox(height: 4),
                      _buildPdfInfoLine('Quote Date', quotation.quoteDate),
                      pw.SizedBox(height: 4),
                      _buildPdfInfoLine('Created On', createdOn),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 14),
          pw.Container(
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.grey400, width: 0.6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Customer Details',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                _buildPdfInfoLine('Customer', quotation.customerAccountName),
                if (quotation.mobile.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  _buildPdfInfoLine('Mobile', quotation.mobile),
                ],
                if (quotation.contactPersonDetails.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  _buildPdfInfoLine('Contact', quotation.contactPersonDetails),
                ],
                if (quotation.remarks.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 4),
                  _buildPdfInfoLine('Remarks', quotation.remarks),
                ],
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: const ['#', 'Product', 'Qty', 'Rate', 'Total'],
            data: quotation.inventorySalesQuotationDetails.map((item) {
              return [
                item.siNo.toString(),
                item.productName,
                item.quantity.toStringAsFixed(2),
                item.unitRate.toStringAsFixed(2),
                item.totalRate.toStringAsFixed(2),
              ];
            }).toList(),
            headerStyle: pw.TextStyle(
              color: PdfColors.white,
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.deepPurple,
            ),
            cellStyle: const pw.TextStyle(fontSize: 9),
            cellPadding: const pw.EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 7,
            ),
            headerAlignment: pw.Alignment.centerLeft,
            cellAlignments: {
              2: pw.Alignment.centerRight,
              3: pw.Alignment.centerRight,
              4: pw.Alignment.centerRight,
            },
            columnWidths: {
              0: const pw.FixedColumnWidth(28),
              1: const pw.FlexColumnWidth(4.2),
              2: const pw.FlexColumnWidth(1.2),
              3: const pw.FlexColumnWidth(1.4),
              4: const pw.FlexColumnWidth(1.5),
            },
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.4),
              ),
            ),
            border: pw.TableBorder.all(
              color: PdfColors.grey400,
              width: 0.5,
            ),
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(
                      color: PdfColors.grey400,
                      width: 0.6,
                    ),
                  ),
                  child: pw.Text(
                    'Generated from mobile app for order review and confirmation.',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey700,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(width: 16),
              pw.Container(
                width: 190,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColors.grey400, width: 0.6),
                ),
                child: pw.Column(
                  children: [
                    _buildPdfTotalLine(
                      'Total Items',
                      quotation.totalItems.toStringAsFixed(0),
                    ),
                    pw.SizedBox(height: 6),
                    _buildPdfTotalLine(
                      'Total Quantity',
                      quotation.totalQty.toStringAsFixed(2),
                    ),
                    pw.SizedBox(height: 6),
                    _buildPdfTotalLine(
                      'Net Total',
                      quotation.netTotal.toStringAsFixed(2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
        footer: (context) => pw.Container(
          margin: const pw.EdgeInsets.only(top: 10),
          padding: const pw.EdgeInsets.only(top: 6),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              top: pw.BorderSide(color: PdfColors.grey400, width: 0.6),
            ),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Sales Order: $documentNumber',
                style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700),
              ),
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700),
              ),
            ],
          ),
        ),
      ),
    );

    final outputDir = await getTemporaryDirectory();
    final safeName = documentNumber.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    final file = File('${outputDir.path}/sales_order_$safeName.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildPdfInfoLine(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 62,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            ': $value',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildPdfTotalLine(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }
}
