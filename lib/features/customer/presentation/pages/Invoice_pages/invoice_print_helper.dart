import 'dart:io';

import 'package:Yadhava/features/customer/model/mobile_app_sales_Invoice_all.dart';
import 'package:Yadhava/features/splash/data/getall_company_model.dart';
import 'package:Yadhava/features/splash/domain/repository.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoicePrintHelper {
  static Future<void> printInvoice(MobileAppSalesInvoiceMaster invoice) async {
    final file = await _generateInvoicePdf(invoice);
    await OpenFile.open(file.path);
  }

  static bool _isTaxInvoice(String invoiceType) {
    final String normalized = invoiceType
        .trim()
        .toUpperCase()
        .replaceAll(' ', '_')
        .replaceAll('-', '_');
    return normalized == 'TAX_INVOICE';
  }

  static double _displayTaxPercentage(MobileAppSalesInvoiceMasterDt item) {
    final double combinedLocalTax = item.sgstPercentage + item.cgstPercentage;
    if (combinedLocalTax > 0) {
      return combinedLocalTax;
    }
    return item.gstPercentage;
  }

  static Future<File> _generateInvoicePdf(
    MobileAppSalesInvoiceMaster invoice,
  ) async {
    final pdf = pw.Document();
    final List<GetAllCompanyModel> companyList =
        await GetCompanyListRepo().getStoredCompanyDetails();
    final Uint8List logoBytes = await rootBundle
        .load('assets/images/appLogo-removebg-preview.png')
        .then((value) => value.buffer.asUint8List());
    final pw.ImageProvider logoImage = pw.MemoryImage(logoBytes);
    final bool isTaxInvoice = _isTaxInvoice(invoice.invoiceType);

    final tableData = invoice.details.map((e) {
      final List<String> row = [
        e.productName,
        e.partNumber,
        e.quantity.toStringAsFixed(2),
        e.foc.toStringAsFixed(2),
        e.srtQty.toStringAsFixed(2),
        e.packingName,
        e.unitRate.toStringAsFixed(2),
        e.totalRate.toStringAsFixed(2),
      ];
      if (isTaxInvoice) {
        row.add(_displayTaxPercentage(e).toStringAsFixed(2));
        row.add(e.sgstAmount.toStringAsFixed(2));
        row.add(e.cgstAmount.toStringAsFixed(2));
        row.add(e.netAmount.toStringAsFixed(2));
      }
      return row;
    }).toList();

    final company = companyList.isNotEmpty ? companyList.first : null;
    final bool showPaidAmount =
        invoice.payType.toUpperCase() != 'CREDIT' && invoice.paidAmount > 0;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.SizedBox(
            height: 130,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.SizedBox(height: 5),
                    pw.Text(
                      isTaxInvoice ? 'TAX INVOICE' : 'INVOICE',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(
                      height: 80,
                      width: 100,
                      child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                    ),
                    pw.SizedBox(height: 5),
                  ],
                ),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Customer Name: ${invoice.clientName}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Driver: ${invoice.salesManName}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Vehicle No: ${invoice.branchName}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Invoice No: ${invoice.invoiceNo}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Invoice Date: ${invoice.invoiceDate}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Payment Type: ${invoice.payType}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    if (isTaxInvoice) ...[
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Invoice Type: Tax Invoice',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          pw.Divider(height: 3, color: PdfColors.grey300),
          pw.SizedBox(height: 10),
          if (company != null)
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Account Holder: ${company.bankAccountName}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Account Number: ${company.bankAccountNumber}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'IFSC Code: ${company.bankIfscCode}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'Branch: ${company.bankBranch}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          if (company != null) pw.SizedBox(height: 8),
          if (company != null) pw.Divider(color: PdfColors.grey300),
          pw.TableHelper.fromTextArray(
            headers: [
              'Product',
              'Code',
              'Qty',
              'FOC',
              'SRT',
              'UOM',
              'Unit Rate',
              'Total',
              if (isTaxInvoice) 'GST %',
              if (isTaxInvoice) 'SGST',
              if (isTaxInvoice) 'CGST',
              if (isTaxInvoice) 'Net',
            ],
            data: tableData,
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
              color: PdfColors.white,
            ),
            headerDecoration: const pw.BoxDecoration(
              color: PdfColors.deepPurple,
            ),
            cellStyle: const pw.TextStyle(fontSize: 10),
            cellAlignment: pw.Alignment.centerLeft,
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1),
              4: const pw.FlexColumnWidth(1),
              5: const pw.FlexColumnWidth(1),
              6: const pw.FlexColumnWidth(2),
              7: const pw.FlexColumnWidth(2),
              if (isTaxInvoice) 8: const pw.FlexColumnWidth(1.2),
              if (isTaxInvoice) 9: const pw.FlexColumnWidth(1.6),
              if (isTaxInvoice) 10: const pw.FlexColumnWidth(1.6),
              if (isTaxInvoice) 11: const pw.FlexColumnWidth(1.8),
            },
            border: pw.TableBorder.all(
              width: 0.5,
              color: PdfColors.grey300,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _summaryLine('Total', invoice.totalAmount.toStringAsFixed(2)),
                if (invoice.totalDiscountVal > 0) ...[
                  pw.SizedBox(height: 5),
                  _summaryLine(
                    'Discount',
                    invoice.totalDiscountVal.toStringAsFixed(2),
                  ),
                ],
                if (isTaxInvoice) ...[
                  pw.SizedBox(height: 5),
                  _summaryLine(
                    'Taxable',
                    invoice.totalTaxableAmount.toStringAsFixed(2),
                  ),
                  pw.SizedBox(height: 5),
                  _summaryLine(
                    'SGST',
                    invoice.totalSgstAmount.toStringAsFixed(2),
                  ),
                  pw.SizedBox(height: 5),
                  _summaryLine(
                    'CGST',
                    invoice.totalCgstAmount.toStringAsFixed(2),
                  ),
                ],
                if (invoice.roundOf != 0) ...[
                  pw.SizedBox(height: 5),
                  _summaryLine('Round Off', invoice.roundOf.toStringAsFixed(2)),
                ],
                pw.SizedBox(height: 5),
                _summaryLine('Net Total', invoice.netTotal.toStringAsFixed(2)),
                if (showPaidAmount) ...[
                  pw.SizedBox(height: 5),
                  _summaryLine(
                    'Paid Amount',
                    invoice.paidAmount.toStringAsFixed(2),
                  ),
                ],
              ],
            ),
          ),
          pw.SizedBox(height: 40),
          pw.Center(
            child: pw.Text(
              'Thank you for your business!',
              style: pw.TextStyle(
                fontSize: 14,
                fontStyle: pw.FontStyle.italic,
                color: PdfColors.grey600,
              ),
            ),
          ),
        ],
      ),
    );

    final outputDir = await getTemporaryDirectory();
    final file = File('${outputDir.path}/invoice_${invoice.invoiceNo}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _summaryLine(String label, String value) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.SizedBox(
          width: 100,
          child: pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(
          width: 3,
          child: pw.Text(
            ':',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Text('  $value'),
      ],
    );
  }
}
