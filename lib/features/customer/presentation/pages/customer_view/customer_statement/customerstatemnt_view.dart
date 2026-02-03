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
import 'package:flutter/services.dart';
import 'dart:io';


class CustomerStatement extends StatefulWidget {
  final acId;
  final String fromdate;
  final String enddate;
  final companyId;
  final String client_name;

  const CustomerStatement({
    super.key,
    this.acId,
    required this.fromdate,
    required this.enddate,
    this.companyId,
    required this.client_name,
  });

  @override
  _CustomerStatementState createState() => _CustomerStatementState();
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
      print(vouchers.length);
      setState(() {
        _vouchers = List.from(vouchers);
      });
      print(_vouchers.length);

      totalDebit = 0;
      totalCredit = 0;

      for (var voucher in _vouchers) {
        totalDebit += voucher.lcDebit ?? 0;
        totalCredit += voucher.lcCredit ?? 0;
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
                    final pdfFile =
                        await _generateTablePdf(widget.client_name, context);
                    await openPdf(pdfFile);
                  } catch (e) {
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
                                      " Ledger : ${widget.client_name}",
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
                                  .where((v) => (v.lcDebit ?? 0) != 0 || (v.lcCredit ?? 0) != 0)
                                  .map((v) => _buildTableRow(
                                index: (_vouchers.indexOf(v) ).toString(),
                                date: v.voucherDate ?? "",
                                particular: v.accountName ?? "",
                                vouchertype: v.voucherTypeName ?? "",
                                voucherno: v.voucherNo ?? "",
                                debit: v.lcDebit?.toString() ?? "0",
                                credit: v.lcCredit?.toString() ?? "0",
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

  Future<File> _generateTablePdf(String clientName, context) async {
    final pdf = pw.Document();

    // Define the number of items per page
    const itemsPerPage = 25;

    // Split the vouchers into chunks
    final chunks = _splitListIntoChunks(_vouchers, itemsPerPage);

    // Track the starting index for each page
    int globalIndex = 1;

    // Loop through each chunk and add a new page
    for (var chunk in chunks) {
      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header Section
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "Ledger: $clientName",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    pw.Container(
                      width: 150,
                      height: 40,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(),
                        borderRadius: pw.BorderRadius.circular(10),
                      ),
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            "From Date #: ${widget.fromdate}",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
                          pw.Text(
                            "To Date #: ${widget.enddate}",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Table Header
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      vertical: 8, horizontal: 10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Row(
                    children: [
                      _buildPdfHeaderCell("#", flex: 1),
                      _buildPdfHeaderCell("VoucherDate", flex: 2),
                      _buildPdfHeaderCell("Particulars", flex: 3),
                      _buildPdfHeaderCell("VoucherType", flex: 2),
                      _buildPdfHeaderCell("VoucherNo", flex: 2),
                      _buildPdfHeaderCell("Debit", flex: 2),
                      _buildPdfHeaderCell("Credit", flex: 2),
                    ],
                  ),
                ),
                pw.SizedBox(height: 10),

                // Table Rows for the current chunk
                for (int i = 0; i < chunk.length; i++)
                  _buildPdfTableRow(
                    index: (globalIndex++).toString(),
                    date: chunk[i].voucherDate ?? "",
                    particular: chunk[i].accountName ?? "",
                    vouchertype: chunk[i].voucherTypeName ?? "",
                    voucherno: chunk[i].voucherNo ?? "",
                    debit: chunk[i].lcDebit.toString() ?? "0",
                    credit: chunk[i].lcCredit.toString() ?? "0",
                  ),
                pw.Divider(thickness: 0.7, color: PdfColors.black),
                // Add totals to the last page
                if (chunks.indexOf(chunk) == chunks.length - 1) ...[
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.SizedBox(),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        children: [
                          pw.Text(
                            "Transaction Totals #  ",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
                          pw.Text(
                            "Debit Total: ${totalDebit.toStringAsFixed(2)}  ",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
                          pw.Text(
                            "Credit Total: ${totalCredit.toStringAsFixed(2)}",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.SizedBox(),
                      pw.Container(
                        width: 420,
                        height: 50,
                        decoration: pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.circular(10),
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                            children: [
                              pw.Text(
                                "Closing Balance As On ${widget.enddate} ",
                                style: pw.TextStyle(
                                  //2 color: pw. Colour.pBackgroundBlack,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              pw.Text(
                                "Total Amount: ${(totalDebit - totalCredit).toStringAsFixed(2)}",
                                style: pw.TextStyle(
                                  decoration: pw.TextDecoration.underline,
                                  // color: Colour.pBackgroundBlack,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ],
            );
          },
        ),
      );
    }

    // Save the PDF
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyyMMdd_HHmm').format(now);
    return savePdfs(
        name: "Statement_${widget.client_name}_$formattedDate", pdf: pdf);
  }

  List<List<Voucher>> _splitListIntoChunks(List<Voucher> list, int chunkSize) {
    List<List<Voucher>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  pw.Expanded _buildPdfHeaderCell(String text, {int flex = 1}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 8,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Container _buildPdfTableRow({
    required String index,
    required String date,
    required String particular,
    required String vouchertype,
    required String voucherno,
    required String debit,
    required String credit,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: pw.Row(
        children: [
          _buildPdfCell(index, flex: 1),
          _buildPdfCell(date, flex: 2),
          _buildPdfCell(particular, flex: 3),
          _buildPdfCell(vouchertype, flex: 2),
          _buildPdfCell(voucherno, flex: 2),
          _buildPdfCell(debit, flex: 2),
          _buildPdfCell(credit, flex: 2),
        ],
      ),
    );
  }

  pw.Expanded _buildPdfCell(String text, {int flex = 1}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 8),
        textAlign: pw.TextAlign.center,
      ),
    );
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
