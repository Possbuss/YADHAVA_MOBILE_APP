import 'dart:io';

import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/core/util/format_rupees.dart';
import 'package:Yadhava/features/auth/data/login_model.dart';
import 'package:Yadhava/features/auth/domain/login_repo.dart';
import 'package:Yadhava/features/customer/model/InvoiceModel.dart';
import 'package:Yadhava/features/customer/model/mobile_app_sales_Invoice_all.dart';
import 'package:Yadhava/features/customer/presentation/bloc/client_bloc/client_list_bloc.dart';
import 'package:Yadhava/features/customer/presentation/bloc/inovice_bloc/invoice_bloc.dart';
import 'package:Yadhava/features/customer/presentation/bloc/update_invoice/update_invoice_state.dart';
import 'package:Yadhava/features/customer/presentation/pages/Invoice_pages/widgets/CustomAlert.dart';
import 'package:Yadhava/features/customer/presentation/pages/Invoice_pages/widgets/discount_field.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/product_master.dart';
import 'package:Yadhava/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../splash/data/getall_company_model.dart';
import '../../../../splash/domain/repository.dart';
import '../../bloc/update_invoice/update_invoice_bloc.dart';
import '../../bloc/update_invoice/update_invoice_event.dart';
import '../customer_details/bloc/add_item_bloc.dart';
import '../customer_details/widget/custom_dropdown.dart';
import '../customer_details/widget/custom_feild.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceDetailsPage extends StatefulWidget {
  final MobileAppSalesInvoiceMaster invoiceModel;
  final String fromDate;
  final String endDate;
  final int partyId;
  final int vehicleId;
  final int companyId;

  const InvoiceDetailsPage({
    super.key,
    required this.invoiceModel,
    required this.fromDate,
    required this.endDate,
    required this.partyId,
    required this.vehicleId,
    required this.companyId,
  });

  @override
  _InvoiceDetailsPageState createState() => _InvoiceDetailsPageState();
}

class _InvoiceDetailsPageState extends State<InvoiceDetailsPage> {
  TextEditingController discountAmount = TextEditingController(text: '0');
  TextEditingController discountPercentage = TextEditingController();
  TextEditingController paidAmount = TextEditingController();
  final TextEditingController textController = TextEditingController();
  late String selectedOption; // = "Cash";
  final _formKey = GlobalKey<FormState>();
  final _formKeyAlert = GlobalKey<FormState>();

  final TextEditingController qtyController = TextEditingController(text: '1');
  final TextEditingController focController = TextEditingController(text: '0');
  final TextEditingController srtController = TextEditingController(text: '0');
  final TextEditingController unitRateController =
      TextEditingController(text: '0');
  final TextEditingController sellingController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  String? selectedItem;
  String? selectedUOM;
  String? uomInitialValue;

  List<String> uomItems = [];
  List<GetAllCompanyModel> companyList = [];
  late ProductMaster selectedItemData;

  late String endDate;
  late String fromDate;

  late List<MobileAppSalesInvoiceMasterDt> details;
  double totalNet = 0.0;
  bool credit = true;
  bool _isUpdatingDiscount = false;
  int vehicleId = 0;
  int companyId = 0;

  @override
  void initState() {
    fromDate = _getFromDate(15);
    endDate = _getEndDate();

    credit = widget.invoiceModel.payType == 'CREDIT'
        ? credit = false
        : credit = true;
    getAllCompany();
    _getLoginResponse();


    discountAmount.addListener(() {
      String text = discountAmount.text.trim();

      if (text.isEmpty) {
        discountAmount.text = '0';
      }

    });

    super.initState();
    paidAmount.text = widget.invoiceModel.paidAmount.toString().isNotEmpty
        ? widget.invoiceModel.paidAmount.toString()
        : '0';
    context.read<AddItemBloc>().add(FetchItems());
    srtController.text = '0';
    discountAmount.text = widget.invoiceModel.totalDiscountVal.toString();
    details = List.from(widget.invoiceModel.details);
    selectedOption = widget.invoiceModel.payType.isNotEmpty
        ? convertPaymentType(widget.invoiceModel.payType)
        : "Cash";
    _calculateTotalNet(details);
  }

  String _getEndDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String _getFromDate(int daysAgo) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: daysAgo)));
  }

  Future getAllCompany() async {
    List<GetAllCompanyModel> storedResponse =
        await GetCompanyListRepo().getStoredCompanyDetails();
    setState(() {
      companyList = storedResponse;
    });
  }

  Future<void> _getLoginResponse() async {
    try {
      LoginModel? storedResponse = await GetLoginRepo().getUserLoginResponse();
      if (storedResponse != null) {
        vehicleId = storedResponse.vehicleId;
        companyId = storedResponse.companyId;
      }
    } catch (e) {
      // setState(() {
      //   locationStatus = "Error fetching storedResponse: $e";
      // });
    }
  }

  @override
  void dispose() {
    discountAmount.dispose();
    paidAmount.dispose();
    super.dispose();
  }

  void _calculateTotalNet(List<MobileAppSalesInvoiceMasterDt> details) {
    double sum = 0.0;
    for (var item in details) {
      sum += item.totalRate;
    }
    setState(() {
      totalNet = sum - double.parse(discountAmount.text);
    });
  }

  String convertPaymentType(String payType) {
    if (payType == "CASH") {
      return "Cash";
    } else if (payType == "BANK") {
      return "Bank";
    } else if (payType == "CREDIT") {
      return "Credit";
    } else {
      return "Bank";
    }
  }

  String reConvertPaymentType(String payType) {
    if (payType == "Cash") {
      return "CASH";
    } else if (payType == "Bank") {
      return "BANK";
    } else if (payType == 'Credit') {
      return "CREDIT";
    } else {
      return "Bank";
    }
  }

  void editItem(int index, MobileAppSalesInvoiceMasterDt updatedItem) {
    setState(() {
      details[index] = updatedItem;
    });
    _calculateTotalNet(details);
  }

  void deleteItem(MobileAppSalesInvoiceMasterDt item) {
    setState(() {
      details.remove(item);
    });
    _calculateTotalNet(details);
  }

  void saveOrder(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      showPopup(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter paid amount')),
      );
    }
  }

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Save Invoice"),
          content: const Text("Do you want to update this invoice?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colour.pDeepDarkBlue),
              ),
            ),
            BlocListener<UpdateInvoiceBloc, UpdateInvoiceState>(
              listener: (context, state) {
                if (state is UpdateInvoiceLoading) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is UpdateInvoiceSuccess) {
                  Navigator.of(context).pop(); // Close the loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Invoice updated successfully!")),
                  );

                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.pop(context);
                    Navigator.pop(context,true);
                  });

                  setState(() {
                    discountAmount.text =
                        widget.invoiceModel.totalDiscountVal.toString() ?? '0.0';
                    details = List.from(widget.invoiceModel.details);
                    _calculateTotalNet(details);
                  });
                } else if (state is UpdateInvoiceFailure) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to update invoice: ${state.error}"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: TextButton(
                onPressed: () {
                  // Logic to update the invoice
                  if (totalNet != 0 &&
                      totalNet - double.parse(discountAmount.text) != 0) {

                    var updatedInvoice =
                        widget.invoiceModel;
                    updatedInvoice = updatedInvoice.copyWith(
                      details: details,
                        paidAmount: paidAmount.text.isEmpty
                            ? 0
                            : double.parse(paidAmount.text),
                        discountAmount: discountAmount.text == ''
                            ? 0.0
                            : double.parse(discountAmount.text),
                        payType: reConvertPaymentType(selectedOption),
                        total: totalNet + double.parse(discountAmount.text),
                        netTotal: totalNet);

                    context.read<UpdateInvoiceBloc>().add(
                          SubmitUpdateInvoice(updatedInvoice: updatedInvoice),
                        );

                    // Close the popup
                    // Navigator.of(context).pop();
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(" Cannot save without any item")),
                    );
                  }
                },
                child: const Text("Update",
                    style: TextStyle(color: Colour.pDeepDarkBlue)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<File> generateInvoicePdf(BuildContext context) async {
    final pdf = pw.Document();

    // Example data access, replace with your actual data sources
    final invoice = widget.invoiceModel; // Your invoice model
    final List detailsList = details; // Your list of product details
    final String paymentType = widget.invoiceModel.payType;
    final bool isCredit = credit;
    final double discount = double.tryParse(discountAmount.text) ?? 0;
    final double paid = double.tryParse(paidAmount.text) ?? 0;
    final double total = double.tryParse(invoice.totalAmount.toString()) ?? 0;
    final double netTotal = totalNet;
    final Uint8List logoBytes = await rootBundle
        .load('assets/images/appLogo-removebg-preview.png')
        .then((value) => value.buffer.asUint8List());
    final pw.ImageProvider logoImage = pw.MemoryImage(logoBytes);

    // Create table data rows
    final tableData = detailsList.map((e) {
      return [
        e.productName,
        e.partNumber,
        e.quantity.toStringAsFixed(2),
        e.foc.toStringAsFixed(2),
        e.srtQty.toStringAsFixed(2),
        e.packingName,
        e.unitRate.toStringAsFixed(2),
        "  ${e.totalRate.toStringAsFixed(2)}",
      ];
    }).toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(24),
        build: (pw.Context context) => [
          pw.SizedBox(
            height: 130,
            child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(children: [
                    pw.SizedBox(height: 5),
                    pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                          fontSize: 28, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(
                      height: 80,
                      width: 100,
                      child: pw.Image(logoImage, fit: pw.BoxFit.contain),
                    ),
                    pw.SizedBox(height: 5),
                  ]),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.SizedBox(height: 5),
                        pw.Text('Customer Name: ${invoice.clientName}',
                            style: pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 5),
                        pw.Text('Driver: ${invoice.salesManName}',
                            style: pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 5),
                        pw.Text('Vehicle No: ${invoice.branchName}',
                            style: pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 5),
                        pw.Text('Invoice No: ${invoice.invoiceNo}',
                            style: pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 5),
                        pw.Text('Invoice Date: ${invoice.invoiceDate}',
                            style: pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 5),
                        pw.Text('Payment Type: $paymentType',
                            style: pw.TextStyle(fontSize: 12)),
                      ])
                ]),
          ),
          pw.Divider(height: 3, color: PdfColors.grey300),
          pw.SizedBox(height: 10),

          // Invoice Info Section
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Account Holder: ${companyList[0].bankAccountName}',
                      style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 5),
                  pw.Text('Account Number: ${companyList[0].bankAccountNumber}',
                      style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 5),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('IFSC Code: ${companyList[0].bankIfscCode}',
                      style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 5),
                  pw.Text('Branch: ${companyList[0].bankBranch}',
                      style: pw.TextStyle(fontSize: 12)),
                  // pw.Text('UPI : ${companyList[0].upiId??''}', style: pw.TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Divider(color: PdfColors.grey300),

          // Product Table
          pw.Table.fromTextArray(
            headers: [
              'Product',
              'Code',
              'Qty',
              'FOC',
              'SRT',
              'UOM',
              'Unit Rate',
              'Total'
            ],
            data: tableData,
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
              color: PdfColors.white,
            ),
            headerDecoration: pw.BoxDecoration(color: PdfColors.blue800),
            cellStyle: pw.TextStyle(fontSize: 10),
            cellAlignment: pw.Alignment.centerLeft,
            columnWidths: {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(2),
              2: pw.FlexColumnWidth(1),
              3: pw.FlexColumnWidth(1),
              4: pw.FlexColumnWidth(1),
              5: pw.FlexColumnWidth(1),
              6: pw.FlexColumnWidth(2),
              7: pw.FlexColumnWidth(2),
            },
            border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey300),
          ),

          pw.SizedBox(height: 20),
// Summary Section (Total, Discount, Net Total, Paid Amount)
          pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.SizedBox(
                      width: 100,
                      child: pw.Text('Total ',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.SizedBox(
                      width: 3,
                      child: pw.Text(':',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Text('  ${total.toStringAsFixed(2)}'),
                  ],
                ),
                if (discount > 0) ...[
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.SizedBox(
                        width: 100,
                        child: pw.Text('Discount ',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.SizedBox(
                        width: 3,
                        child: pw.Text(':',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Text('  ${discount.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
                if (discount > 0) ...[
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.SizedBox(
                        width: 100,
                        child: pw.Text('Net Total ',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.SizedBox(
                        width: 3,
                        child: pw.Text(':',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Text('  ${netTotal.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
                if (isCredit && paid > 0) ...[
                  pw.SizedBox(height: 5),
                  pw.Row(
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.SizedBox(
                        width: 100,
                        child: pw.Text('Paid Amount ',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.SizedBox(
                        width: 3,
                        child: pw.Text(':',
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Text('  ${paid.toStringAsFixed(2)}'),
                    ],
                  ),
                ],
                pw.SizedBox(height: 5),
              ],
            ),
          ),

          pw.SizedBox(height: 40),

          // Footer (Optional)
          pw.Center(
            child: pw.Text(
              'Thank you for your business!',
              style: pw.TextStyle(
                  fontSize: 14,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey600),
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

  Widget _buildRadioButton(String value) {
    return Row(
      children: [
        Radio<String>(
          activeColor: Colour.pWhite,
          focusColor: Colour.pWhite,
          value: value,
          groupValue: selectedOption,
          onChanged: (newValue) {
            setState(() {
              newValue == 'Credit' ? credit = false : credit = true;
              selectedOption = newValue!;
            });
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        Text(value, style: const TextStyle(fontSize: 14, color: Colour.pWhite)),
      ],
    );
  }

  addItemPopup() {
    // Reset controllers and state variables when opening the popup
    qtyController.text = '0';
    focController.text = '0';
    srtController.text = '0';
    sellingController.clear();
    totalController.clear();
    // setState(() {
    //   selectedItem = null;
    //   selectedItemData = {};
    //   uomInitialValue = 'N/A';
    //   uomItems = ['N/A'];
    // });

    return AlertDialog(
      backgroundColor: Colour.pWhite,
      title: const Text("Add Item", style: TextStyle(color: Colour.blackgery)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKeyAlert,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<AddItemBloc, AddItemState>(
                builder: (context, state) {
                  if (state is ItemsFetchedState) {
                    // Get product IDs of already added items
                    final addedProductIds =
                        details.map((e) => e.productId).toSet();

                    // Filter out items already in the `details` list
                    final availableItems = state.items
                        .where((item) =>
                            !addedProductIds.contains(item.productId))
                        .toList();

                    // Map filtered items to product names
                    final items = availableItems
                        .map((item) => item.productName.toString())
                        .toList();

                    return ReusableDropdown(
                      label: "Item",
                      hintText: "Select Item",
                      items: items,
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value;
                          selectedItemData = availableItems.firstWhere(
                            (item) => item.productName == value,
                            //orElse: () => {},
                          );
                          sellingController.text =
                              selectedItemData.sellingPrice.toString() ??
                                  '0';
                          totalController.text = sellingController.text;
                          uomInitialValue =
                              selectedItemData.packingName.toString() ??
                                  'N/A';
                          uomItems = [uomInitialValue!];
                        });
                      },
                    );
                  } else if (state is ItemsFetchErrorState) {
                    return Text(state.error,
                        style: const TextStyle(color: Colors.red));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(height: 16),
              ReusableVoucherTextField(
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$'))
                // ],
                onChanged: (qt) {
                  int srtCount = int.tryParse(srtController.text) ?? 0;
                  double totalPrice =
                      (double.tryParse(sellingController.text) ?? 0) *
                              (double.tryParse(qt) ?? 0) -
                          (srtCount *
                              (double.tryParse(sellingController.text) ?? 0));
                  totalController.text = totalPrice.toStringAsFixed(2);
                },
                keyboardType: TextInputType.number,
                label: "Quantity",
                controller: qtyController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter quantity' : null,
                hintText: '',
              ),
              const SizedBox(height: 16),
              ReusableVoucherTextField(
                keyboardType: TextInputType.number,
                label: "FOC",
                controller: focController,
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$'))
                // ],
                validator: (value) =>
                    value!.isEmpty ? 'Please enter FOC' : null,
                hintText: '',
              ),
              const SizedBox(height: 16),
              ReusableVoucherTextField(
                onChanged: (srt) {
                  int quantity = int.tryParse(qtyController.text) ?? 0;
                  double totalPrice =
                      ((double.tryParse(sellingController.text) ?? 0) *
                              quantity) -
                          ((double.tryParse(sellingController.text) ?? 0) *
                              (double.tryParse(srt) ?? 0));
                  totalController.text = totalPrice.toStringAsFixed(2);
                },
                keyboardType: TextInputType.number,
                label: "SRT",
                controller: srtController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter SRT' : null,
                hintText: '',
              ),
              const SizedBox(height: 16),
              ReusableVoucherTextField(
                onChanged: (price) {
                  int srtCount = int.tryParse(srtController.text) ?? 0;
                  double totalPrice =
                      (double.tryParse(qtyController.text) ?? 0) *
                              (double.tryParse(price) ?? 0) -
                          (srtCount * (double.tryParse(price) ?? 0));
                  totalController.text = totalPrice.toStringAsFixed(2);
                },
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$'))
                // ],
                keyboardType: TextInputType.number,
                label: "Unit Rate",
                controller: sellingController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter Unit Price' : null,
                hintText: '',
              ),
              ReusableVoucherTextField(
                readOnly: true,
                onChanged: (srt) {
                  int quantity = int.tryParse(qtyController.text) ?? 0;
                  double totalPrice =
                      ((double.tryParse(sellingController.text) ?? 0) *
                              quantity) -
                          ((double.tryParse(sellingController.text) ?? 0) *
                              (double.tryParse(srt) ?? 0));
                  totalController.text = totalPrice.toStringAsFixed(2);
                },
                // inputFormatters: [
                //   FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$'))
                // ],
                keyboardType: TextInputType.number,
                label: "Total",
                controller: totalController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter SRT' : null,
                hintText: '',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Reset form and controllers when canceling
            _formKey.currentState?.reset();
            qtyController.text = '0';
            focController.text = '0';
            srtController.text = '0';
            sellingController.clear();
            totalController.clear();
            setState(() {
              selectedItem = null;
              selectedItemData;
              uomInitialValue = 'N/A';
              uomItems = ['N/A'];
            });
            Navigator.pop(context);
          },
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            int index = details.length;

            if (_formKeyAlert.currentState!.validate()) {
              MobileAppSalesInvoiceMasterDt newItem =
              MobileAppSalesInvoiceMasterDt(
                productName: selectedItem ?? '',
                quantity: double.tryParse(qtyController.text) ?? 0,
                foc: double.tryParse(focController.text) ?? 0.0,
                srtQty: double.tryParse(srtController.text) ?? 0.0,
                totalRate: double.tryParse(totalController.text) ?? 0.0,
                siNo: index,
                companyId: 1,
                clientId: 0,
                productId: selectedItemData.productId,
                partNumber: selectedItemData.partNumber,
                //packingDescription: selectedItemData.packingDescription,
                packingId: selectedItemData.packingId,
                packingName: selectedItemData.packingName,
                totalQty: double.tryParse(totalController.text) ?? 0.0,
                unitRate: double.tryParse(sellingController.text) ?? 0.0,

                salesManName: "",
                packQty: 1,
                netRate: double.tryParse(totalController.text) ?? 0.0,
                invoiceNo: "",
                invoiceId: 0,
                invoiceDate: "",
                clientName: "",
                branchName: "",
                branchId: widget.vehicleId,
                salesManId:0,
                packingOrder: 1,
                packMultiplyQty: 1,
                routeId: 0,
                mobile: ""

              );

              // Check if the item is already present in the list
              bool isDuplicate =
                  details.any((item) => item.productId == newItem.productId);

              if (!isDuplicate) {
                setState(() {
                  details.add(newItem);
                  qtyController.text = '0';
                  focController.text = '0';
                  srtController.text = '0';
                  totalController.clear();
                  sellingController.clear();

                  _calculateTotalNet(details);
                });

                print("Item added. Total items: ${details.length}");
                Navigator.pop(context);
              } else {
                print("Item already exists in the list!");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Item already added!")));
              }
            }
          },
          child: const Text("Add", style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colour.pBackgroundBlack,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return addItemPopup();
                  },
                );
              },
              icon: Icon(
                Icons.add,
                color: Colour.pWhite,
              )),
          IconButton(
            onPressed: () async {
              // final pdfFile = await _generateInvoicePdf(context); // define this method
              final pdfFile =
                  await generateInvoicePdf(context); // define this method
              if (await File(pdfFile.path).exists()) {
                await Share.shareXFiles(
                  [XFile(pdfFile.path)],
                  text: "Sharing Invoice PDF",
                );
              }
            },
            icon: Icon(Icons.picture_as_pdf, color: Colour.pWhite),
          ),
          SizedBox(
            width: 10,
          )
        ],
        centerTitle: true,
        backgroundColor: Colour.pDeepLightBlue,
        title: Text(
          widget.invoiceModel.branchName.isNotEmpty
              ? widget.invoiceModel.branchName
              : "No Vehicle Info",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colour.pDeepLightBlue,
              child: Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 6,
                    children: [
                      Text("Branch:",
                          style: const TextStyle(color: Colors.white)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .13,
                      ),
                      Expanded(
                        child: Text(" ${widget.invoiceModel.branchName}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white)),
                      ),
                      Text(
                        '|',
                        style: TextStyle(color: Colour.pWhite),
                      ),
                      Expanded(
                        child: Text(
                          widget.invoiceModel.branchName.isNotEmpty
                              ? widget.invoiceModel.branchName
                              : 'N/A',
                          style: const TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 6,
                    children: [
                      Text("Invoice No:",
                          style: const TextStyle(color: Colors.white)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .08,
                      ),
                      Text(
                          "${widget.invoiceModel.invoiceNo} | ${widget.invoiceModel.invoiceDate}",
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),

                  Row(
                    spacing: 7,
                    children: [
                      const Text("Amount:",
                          style: TextStyle(color: Colour.pWhite)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .09,
                      ),
                      CustomDiscountTextField(
                        controller: discountAmount,
                        label: "discount",
                        onChanged: (value) {
                          if (value.trim().isNotEmpty) {
                            // widget.invoiceModel
                            //     .copyWith(discountAmount: double.parse(value));
                            _calculateTotalNet(details);
                          }
                        },
                      ),
                      Visibility(
                        visible: credit,
                        child: CustomDiscountTextField(
                            validator: (value) {
                              if (credit) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value == '0.0') {
                                  return "Paid amount is required";
                                }
                              }
                              return null;
                            },
                            controller: paidAmount,
                            label: "paid"),
                      ),
                    ],
                  ),

                  Row(
                    spacing: 6,
                    children: [
                      const Text(
                        "Payment type:",
                        style: TextStyle(color: Colour.pWhite),
                      ),
                      _buildRadioButton("Cash"),
                      _buildRadioButton("Bank"),
                      _buildRadioButton("Credit"),
                    ],
                  ),
                  Row(
                    spacing: 6,
                    children: [
                      Text(
                        "Net Total:",
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .09,
                      ),
                      Text(
                        "₹${totalNet.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: details.length,
                itemBuilder: (context, index) {
                  final detail = details[index];
                  return ItemTile(
                    detail: detail,
                    onEdit: (updatedDetail) => editItem(index, updatedDetail),
                    onDelete: () {
                      deleteItem(detail);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colour.pDeepLightBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => saveOrder(context),
                child: const Text("Save Invoice",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemTile extends StatelessWidget {
  final MobileAppSalesInvoiceMasterDt detail;
  final Function(MobileAppSalesInvoiceMasterDt) onEdit;
  final VoidCallback onDelete;

  const ItemTile({
    super.key,
    required this.detail,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Product: ${detail.productName}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Text(
                "Code: ${detail.partNumber}",
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildDetailColumn("Qty", detail.quantity.toStringAsFixed(2)),
              const SizedBox(width: 10),
              _buildDetailColumn("FOC", detail.foc.toStringAsFixed(2)),
              const SizedBox(width: 10),
              _buildDetailColumn("SRT", detail.srtQty.toStringAsFixed(2)),
              const SizedBox(width: 10),
              _buildDetailColumn("UOM", detail.packingName),
              const SizedBox(width: 10),
              _buildDetailColumn(
                  "Unit Rate", detail.unitRate.toStringAsFixed(2)),
              const SizedBox(width: 10),
              Expanded(
                  child: _buildDetailColumn(
                      "Total", formatRupees(detail.totalRate))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () async {
                  final updatedItem =
                      await showDialog<MobileAppSalesInvoiceMasterDt>(
                    context: context,
                    builder: (context) => _EditItemDialog(item: detail),
                  );
                  if (updatedItem != null) onEdit(updatedItem);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showCustomAlert(
                    context: context,
                    button1Text: 'No',
                    button2Text: 'Yes',
                    onButton1Press: () => Navigator.pop(context),
                    onButton2Press: onDelete,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }
}

class _EditItemDialog extends StatefulWidget {
  final MobileAppSalesInvoiceMasterDt item;

  const _EditItemDialog({super.key, required this.item});

  @override
  __EditItemDialogState createState() => __EditItemDialogState();
}

class __EditItemDialogState extends State<_EditItemDialog> {
  late TextEditingController quantityController;
  late TextEditingController unitRateController;
  late TextEditingController focController;
  late TextEditingController srtController;
  late TextEditingController packingNameController;

  @override
  void initState() {
    super.initState();
    quantityController =
        TextEditingController(text: widget.item.quantity.toString());
    unitRateController =
        TextEditingController(text: widget.item.unitRate.toString());
    focController = TextEditingController(text: widget.item.foc.toString());
    srtController = TextEditingController(text: widget.item.srtQty.toString());
    packingNameController =
        TextEditingController(text: widget.item.packingName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Item",
          style: TextStyle(color: Colour.pDeepDarkBlue)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: "Quantity"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                double quantity = double.tryParse(value) ??
                    0; // Defaults to 1 if null/invalid
                // Update the text field with valid value
                quantityController.selection = TextSelection.fromPosition(
                  TextPosition(offset: quantityController.text.length),
                );

                // final totalRate = quantity * double.parse(widget.item.unitRate.toString());
                // unitRateController.text = totalRate.toStringAsFixed(2);
              },
            ),
            TextField(
              controller: focController,
              decoration: const InputDecoration(labelText: "FOC"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: srtController,
              decoration: const InputDecoration(labelText: "SRT"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  double quantity = double.tryParse(value) ??
                      0; // Defaults to 1 if null/invalid
                  if (quantity < 0) {
                    quantity = 0; // Ensure quantity is at least 1
                    srtController.text =
                        '0'; // Update the text field with valid value
                    srtController.selection = TextSelection.fromPosition(
                      TextPosition(offset: srtController.text.length),
                    );
                  }
                } else {
                  srtController.text = '0';
                }
              },
            ),
            TextField(
              readOnly: true,
              controller: packingNameController,
              decoration: const InputDecoration(labelText: "UOM"),
            ),
            TextField(
              controller: unitRateController,
              decoration: const InputDecoration(labelText: "Unit Rate"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel",
              style: TextStyle(color: Colour.pDeepDarkBlue)),
        ),
        TextButton(
          onPressed: () {
            final updatedItem = widget.item.copyWith(
                quantity: double.parse(quantityController.text),
                foc: double.parse(focController.text),
                packingName: packingNameController.text,
                unitRate: double.parse(unitRateController.text),
                totalRate: (double.parse(quantityController.text) *
                        double.parse(unitRateController.text)) -
                    (double.parse(srtController.text) *
                        double.parse(unitRateController.text)),
                srtQty: double.parse(srtController.text)

            );
            Navigator.pop(context, updatedItem);
          },
          child:
              const Text("Save", style: TextStyle(color: Colour.pDeepDarkBlue)),
        ),
      ],
    );
  }
}
