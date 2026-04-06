import 'dart:io';

import 'package:Yadhava/core/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../../../core/constants/color.dart';
import '../../../../domain/voucher_repo.dart';
import '../../../../model/statementModel.dart';

class CustomerStatement extends StatefulWidget {
  final dynamic acId;
  final String fromdate;
  final String enddate;
  final dynamic companyId;
  final String clientName;

  const CustomerStatement({
    super.key,
    this.acId,
    required this.fromdate,
    required this.enddate,
    this.companyId,
    required this.clientName,
  });

  @override
  State<CustomerStatement> createState() => _CustomerStatementState();
}

class _CustomerStatementState extends State<CustomerStatement> {
  final VoucherRepo _voucherRepo = VoucherRepo();
  List<Voucher> _vouchers = [];
  double totalDebit = 0;
  double totalCredit = 0;

  @override
  void initState() {
    super.initState();
    fetchVouchers();
  }

  Future<void> fetchVouchers() async {
    try {
      List<Voucher> vouchers = await _voucherRepo.getInvoices(
          widget.acId, widget.fromdate, widget.enddate, widget.companyId);
      setState(() {
        _vouchers = List.from(vouchers);
      });

      totalDebit = 0;
      totalCredit = 0;

      for (var voucher in _vouchers) {
        totalDebit += voucher.lcDebit;
        totalCredit += voucher.lcCredit;
      }
    } catch (e) {
      debugPrint("Error fetching vouchers: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppbar(
        title: "Payment details",
        leadingontap: () {
          Navigator.pop(context);
        },
        leading: const Icon(
          Icons.arrow_back_ios_new,
          color: Colour.pWhite,
        ),
        action: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: IconButton(
                onPressed: () async {
                  try {
                    final pdfFile = await _generateTablePdf(widget.clientName);
                    await openPdf(pdfFile);
                  } catch (e) {
                    if (!context.mounted) {
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error generating or opening PDF: $e"),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.download_outlined,
                  color: Colour.pWhite,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      body: _vouchers.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: screenWidth,
                      height: screenHeight * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      " Ledger : ${widget.clientName}",
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 34, 101, 224),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "From Date #: ${widget.fromdate}",
                                              style: const TextStyle(
                                                color: Colour.pBackgroundBlack,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 10,
                                              ),
                                            ),
                                            Text(
                                              "To Date #:${widget.enddate}",
                                              style: const TextStyle(
                                                color: Colour.pBackgroundBlack,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _buildTableHeader(),
                            Column(
                              children: _vouchers
                                  .where(
                                      (v) => v.lcDebit != 0 || v.lcCredit != 0)
                                  .map((v) => _buildTableRow(
                                        index:
                                            (_vouchers.indexOf(v)).toString(),
                                        date: v.voucherDate,
                                        particular: v.accountName,
                                        vouchertype: v.voucherTypeName ?? "",
                                        voucherno: v.voucherNo,
                                        debit: v.lcDebit.toString(),
                                        credit: v.lcCredit.toString(),
                                      ))
                                  .toList(), // Ensure it is a List<Widget>
                            ),

                            // for (int i = 0; i < _vouchers.length; i++)
                            //   _buildTableRow(
                            //     index: (i + 1).toString(),
                            //     date: _vouchers[i].voucherDate ?? "",
                            //     particular: _vouchers[i].accountName ?? "",
                            //     vouchertype: _vouchers[i].voucherTypeName ?? "",
                            //     voucherno: _vouchers[i].voucherNo ?? "",
                            //     debit: _vouchers[i].lcDebit.toString() ?? "0",
                            //     credit: _vouchers[i].lcCredit.toString() ?? "0",
                            //   ),
                            const SizedBox(height: 10),
                            const Divider(
                              thickness: 0.7,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // const SizedBox(),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.86,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Text(
                                          "Transaction Totals: ",
                                          style: TextStyle(
                                            color: Colour.pBackgroundBlack,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          "Debit Total: ${totalDebit.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colour.pBackgroundBlack,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          "Credit Total: ${totalCredit.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colour.pBackgroundBlack,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.86,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Closing Balance As On ${widget.enddate} ",
                                          style: const TextStyle(
                                            color: Colour.pBackgroundBlack,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          "Total Amount: ${(totalDebit - totalCredit).toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colour.pBackgroundBlack,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 1, 65, 104),
        border: Border.all(color: Colour.pContainerBlack),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          _buildHeaderCell("#", flex: 1),
          _buildHeaderCell("Voucher\nDate", flex: 2),
          _buildHeaderCell("Particulars", flex: 3),
          _buildHeaderCell("Voucher\nType", flex: 2),
          _buildHeaderCell("VoucherNo", flex: 2),
          _buildHeaderCell("Debit", flex: 2),
          _buildHeaderCell("Credit", flex: 2),
        ],
      ),
    );
  }

  static Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          color: Colour.pContainerBlack,
          fontWeight: FontWeight.bold,
          fontSize: 8,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableRow({
    required String index,
    required String date,
    required String particular,
    required String vouchertype,
    required String voucherno,
    required String debit,
    required String credit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: Row(
        children: [
          _buildCell(index, flex: 1),
          _buildCell(date, flex: 2),
          _buildCell(particular, flex: 3),
          _buildCell(vouchertype, flex: 2),
          _buildCell(voucherno, flex: 2),
          _buildCell(debit, flex: 2),
          _buildCell(credit, flex: 2),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(fontSize: 8),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<File> _generateTablePdf(String clientName) async {
    final pdf = pw.Document();
    final List<Voucher> printableVouchers =
        _vouchers.where((v) => v.lcDebit != 0 || v.lcCredit != 0).toList();
    final String generatedOn =
        DateFormat('dd-MMM-yyyy hh:mm a').format(DateTime.now());
    final String closingBalance = (totalDebit - totalCredit).toStringAsFixed(2);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.fromLTRB(24, 24, 24, 20),
        header: (context) => _buildPdfReportHeader(
          clientName: clientName,
          generatedOn: generatedOn,
          entryCount: printableVouchers.length,
          closingBalance: closingBalance,
        ),
        footer: (context) => _buildPdfReportFooter(context),
        build: (context) => [
          pw.Table(
            border: pw.TableBorder(
              top: const pw.BorderSide(color: PdfColors.grey600, width: 0.7),
              bottom: const pw.BorderSide(color: PdfColors.grey600, width: 0.7),
              left: const pw.BorderSide(color: PdfColors.grey500, width: 0.5),
              right: const pw.BorderSide(color: PdfColors.grey500, width: 0.5),
              horizontalInside:
                  const pw.BorderSide(color: PdfColors.grey300, width: 0.35),
              verticalInside:
                  const pw.BorderSide(color: PdfColors.grey300, width: 0.35),
            ),
            columnWidths: <int, pw.TableColumnWidth>{
              0: const pw.FlexColumnWidth(0.7),
              1: const pw.FlexColumnWidth(1.45),
              2: const pw.FlexColumnWidth(2.6),
              3: const pw.FlexColumnWidth(1.95),
              4: const pw.FlexColumnWidth(1.7),
              5: const pw.FlexColumnWidth(1.25),
              6: const pw.FlexColumnWidth(1.25),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#E5E7EB'),
                ),
                children: [
                  _buildPdfHeaderBox('#'),
                  _buildPdfHeaderBox('Voucher Date'),
                  _buildPdfHeaderBox('Particulars'),
                  _buildPdfHeaderBox('Voucher Type'),
                  _buildPdfHeaderBox('Voucher No'),
                  _buildPdfHeaderBox('Debit'),
                  _buildPdfHeaderBox('Credit'),
                ],
              ),
              ...List<pw.TableRow>.generate(
                printableVouchers.length,
                (index) {
                  final voucher = printableVouchers[index];
                  final bool alternate = index.isOdd;
                  return pw.TableRow(
                    decoration: pw.BoxDecoration(
                      color: alternate
                          ? PdfColor.fromHex('#FAFAFA')
                          : PdfColors.white,
                    ),
                    children: [
                      _buildPdfBodyBox(
                        '${index + 1}',
                        align: pw.TextAlign.center,
                      ),
                      _buildPdfBodyBox(_formatVoucherDate(voucher.voucherDate)),
                      _buildPdfBodyBox(voucher.accountName),
                      _buildPdfBodyBox(voucher.voucherTypeName ?? '-'),
                      _buildPdfBodyBox(voucher.voucherNo),
                      _buildPdfBodyBox(
                        _formatAmount(voucher.lcDebit),
                        align: pw.TextAlign.right,
                      ),
                      _buildPdfBodyBox(
                        _formatAmount(voucher.lcCredit),
                        align: pw.TextAlign.right,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F9FAFB'),
                    borderRadius: pw.BorderRadius.circular(8),
                    border: pw.Border.all(
                      color: PdfColors.grey400,
                      width: 0.6,
                    ),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Statement Notes',
                        style: pw.TextStyle(
                          fontSize: 10.5,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'This statement summarizes all debit and credit entries posted to the selected client ledger within the specified period.',
                        style: pw.TextStyle(
                          fontSize: 8.5,
                          color: PdfColors.grey700,
                          lineSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  children: [
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#F3F4F6'),
                        borderRadius: pw.BorderRadius.circular(8),
                        border: pw.Border.all(
                          color: PdfColors.grey500,
                          width: 0.6,
                        ),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Transaction Totals',
                            style: pw.TextStyle(
                              fontSize: 10.5,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          _buildPdfTotalLine(
                            'Debit Total',
                            totalDebit.toStringAsFixed(2),
                          ),
                          pw.SizedBox(height: 4),
                          _buildPdfTotalLine(
                            'Credit Total',
                            totalCredit.toStringAsFixed(2),
                          ),
                        ],
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#111827'),
                        borderRadius: pw.BorderRadius.circular(8),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Closing Balance As On ${widget.enddate}',
                            style: pw.TextStyle(
                              fontSize: 9.5,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Text(
                            closingBalance,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    // Save the PDF
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd_HHmm').format(now);
    return savePdfs(
        name: "Statement_${widget.clientName}_$formattedDate", pdf: pdf);
  }

  pw.Widget _buildPdfHeaderBox(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 8.8,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _buildPdfBodyBox(
    String text, {
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      child: pw.Text(
        text,
        textAlign: align,
        style: const pw.TextStyle(fontSize: 8.4, lineSpacing: 1.8),
      ),
    );
  }

  pw.Widget _buildPdfReportHeader({
    required String clientName,
    required String generatedOn,
    required int entryCount,
    required String closingBalance,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#F3F4F6'),
              borderRadius: pw.BorderRadius.circular(8),
              border: pw.Border.all(color: PdfColors.grey400, width: 0.8),
            ),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 3,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'ACCOUNT STATEMENT',
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Client Ledger Report',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.grey700,
                        ),
                      ),
                      pw.SizedBox(height: 12),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          borderRadius: pw.BorderRadius.circular(6),
                          border: pw.Border.all(
                            color: PdfColors.grey400,
                            width: 0.6,
                          ),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Ledger Name',
                              style: pw.TextStyle(
                                fontSize: 8,
                                color: PdfColors.grey700,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            pw.Text(
                              clientName,
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 16),
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    children: [
                      pw.Row(
                        children: [
                          pw.Expanded(
                            child: _buildPdfSummaryCard(
                              title: 'From Date',
                              value: widget.fromdate,
                            ),
                          ),
                          pw.SizedBox(width: 8),
                          pw.Expanded(
                            child: _buildPdfSummaryCard(
                              title: 'To Date',
                              value: widget.enddate,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 8),
                      _buildPdfSummaryCard(
                        title: 'Generated On',
                        value: generatedOn,
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            padding:
                const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#FAFAFA'),
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: PdfColors.grey400, width: 0.6),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildPdfMiniStat(
                  label: 'Entries',
                  value: entryCount.toString(),
                ),
                _buildPdfMiniStat(
                  label: 'Debit Total',
                  value: totalDebit.toStringAsFixed(2),
                ),
                _buildPdfMiniStat(
                  label: 'Credit Total',
                  value: totalCredit.toStringAsFixed(2),
                ),
                _buildPdfMiniStat(
                  label: 'Closing Balance',
                  value: closingBalance,
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            height: 2,
            color: PdfColor.fromHex('#1F2937'),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfReportFooter(pw.Context context) {
    return pw.Container(
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
            'Statement Period: ${widget.fromdate} to ${widget.enddate}',
            style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfSummaryCard({
    required String title,
    required String value,
    bool fullWidth = false,
  }) {
    return pw.Container(
      width: fullWidth ? double.infinity : null,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey400, width: 0.6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 9.5,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfMiniStat({
    required String label,
    required String value,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 7.5,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 9.5,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPdfTotalLine(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 9.5,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatVoucherDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }

    try {
      final DateTime date = DateTime.parse(value);
      return DateFormat('dd-MMM-yyyy').format(date);
    } catch (_) {
      return value;
    }
  }

  String _formatAmount(double? value) {
    if (value == null || value == 0) {
      return '0.00';
    }
    return value.toStringAsFixed(2);
  }

  Future<File> savePdfs({
    required String name,
    required pw.Document pdf,
  }) async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      throw Exception("Failed to get storage directory.");
    }

    final file = File("${directory.path}/$name.pdf");
    await file.writeAsBytes(await pdf.save());
    debugPrint("PDF saved at: ${file.path}");
    return file;
  }

  Future<void> openPdf(File file) async {
    if (!file.existsSync()) {
      debugPrint("File does not exist at path: ${file.path}");
      return;
    }

    try {
      final result = await OpenFile.open(file.path);
      if (result.type != ResultType.done) {
        debugPrint("Error opening PDF: ${result.message}");
      }
    } catch (e) {
      debugPrint("Exception while opening PDF: $e");
    }
  }
}
