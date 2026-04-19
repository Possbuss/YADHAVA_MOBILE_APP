import 'dart:math' as math;

import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/core/util/format_rupees.dart';
import 'package:Yadhava/features/customer/presentation/pages/Invoice_pages/Invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../auth/data/login_model.dart';
import '../../../../auth/domain/login_repo.dart';
import '../../../data/client_model.dart';
import '../customer_details/bloc/add_item_bloc.dart';
import '../customer_details/model/addItem_model.dart';
import '../customer_details/model/order_model.dart';

class SummeryPage extends StatefulWidget {
  final ClientModel client;
  final List selectedItemList;

  const SummeryPage({
    super.key,
    required this.selectedItemList,
    required this.client,
  });

  @override
  State<SummeryPage> createState() => _SummeryPageState();
}

class _SummeryPageState extends State<SummeryPage> {
  final TextEditingController discountAmount = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String endDate;
  late String fromDate;

  int vehicleId = 0;
  int companyId = 0;
  double previousAmount = 0.0;
  double totalAmount = 0.0;
  double discountedSubtotal = 0.0;
  double totalTaxableAmount = 0.0;
  double totalSgstAmount = 0.0;
  double totalCgstAmount = 0.0;
  double totalIgstAmount = 0.0;
  double totalCessAmount = 0.0;
  double roundOf = 0.0;
  double netTotal = 0.0;
  double amountToBePaid = 0.0;
  String selectedOption = 'Cash';
  String paymentType = 'CASH';
  String invoiceType = 'SALES_INVOICE';
  bool collectPayment = true;
  bool _loadingDialogShown = false;
  double? latitude;
  double? longitude;
  String locationStatus = 'Press the button to get location';
  late final List<_TaxLineItem> _taxItems;

  bool get isTaxInvoice => invoiceType == 'TAX_INVOICE';

  double _round4(double value) => OrderModel.roundToFourDecimals(value);

  double _computeRoundOf(double amount) {
    return OrderModel.computeRoundOf(amount);
  }

  @override
  void initState() {
    super.initState();
    previousAmount = widget.client.amount ?? 0.0;
    _taxItems = widget.selectedItemList
        .whereType<ProductItem>()
        .map(_TaxLineItem.fromProductItem)
        .toList();
    _getCurrentLocation();
    _recalculateTotals();
    fromDate = _getFromDate(15);
    endDate = _getEndDate();
    _getLoginResponse();
  }

  Future<void> _getLoginResponse() async {
    try {
      final LoginModel? storedResponse =
          await GetLoginRepo().getUserLoginResponse();
      if (storedResponse != null) {
        vehicleId = storedResponse.vehicleId;
        companyId = storedResponse.companyId;
      }
    } catch (e) {
      setState(() {
        locationStatus = 'Error fetching storedResponse: $e';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        setState(() {
          locationStatus = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            locationStatus = 'Location permission denied.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationStatus =
              'Location permission permanently denied. Enable it from settings.';
        });
        await openAppSettings();
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        locationStatus = 'Latitude: $latitude, Longitude: $longitude';
      });
    } catch (e) {
      setState(() {
        locationStatus = 'Error fetching location: $e';
      });
    }
  }

  void _recalculateTotals() {
    totalAmount = 0.0;
    totalTaxableAmount = 0.0;
    totalSgstAmount = 0.0;
    totalCgstAmount = 0.0;
    totalIgstAmount = 0.0;
    totalCessAmount = 0.0;
    roundOf = 0.0;

    for (final _TaxLineItem item in _taxItems) {
      totalAmount += item.lineTotal;
    }
    totalAmount = _round4(totalAmount);

    final double discountValue = double.tryParse(discountAmount.text) ?? 0.0;
    discountedSubtotal = _round4(math.max(0.0, totalAmount - discountValue));

    for (final _TaxLineItem item in _taxItems) {
      final double taxableAmount = totalAmount == 0
          ? 0.0
          : (item.lineTotal / totalAmount) * discountedSubtotal;
      item.recalculate(
          isTaxInvoice: isTaxInvoice, taxableAmount: taxableAmount);
      totalTaxableAmount += item.taxableAmount;
      totalSgstAmount += item.sgstAmount;
      totalCgstAmount += item.cgstAmount;
      totalIgstAmount += item.igstAmount;
    }
    totalTaxableAmount = _round4(totalTaxableAmount);
    totalSgstAmount = _round4(totalSgstAmount);
    totalCgstAmount = _round4(totalCgstAmount);
    totalIgstAmount = _round4(totalIgstAmount);
    totalCessAmount = _round4(totalCessAmount);

    final double subtotal = _round4(totalTaxableAmount +
        totalSgstAmount +
        totalCgstAmount +
        totalIgstAmount +
        totalCessAmount);
    roundOf = _computeRoundOf(subtotal);
    netTotal = _round4(subtotal + roundOf);
    amountToBePaid = _round4(netTotal + previousAmount);
  }

  String _getEndDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String _getFromDate(int daysAgo) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: daysAgo)));
  }

  @override
  void dispose() {
    discountAmount.dispose();
    paidAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddItemBloc, AddItemState>(
      listener: (context, state) async {
        if (state is ItemPostedSuccess) {
          if (_loadingDialogShown) {
            Navigator.of(context, rootNavigator: true).pop();
            _loadingDialogShown = false;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Saved Successfully'),
              backgroundColor: Colors.green,
            ),
          );
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => InvoicePage(
                  client: widget.client,
                  partyId: widget.client.id,
                ),
              ),
              (route) => false,
            );
          }
        } else if (state is SalesInvoiceSaving) {
          _loadingDialogShown = true;
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ItemsFetchErrorState) {
          if (_loadingDialogShown) {
            Navigator.of(context, rootNavigator: true).pop();
            _loadingDialogShown = false;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed: ${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colour.pBackgroundBlack,
        appBar: AppBar(
          backgroundColor: Colour.pBackgroundBlack,
          centerTitle: true,
          title: const Text(
            'Invoice Summery',
            style: TextStyle(color: Colour.mediumGray),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInvoiceTypeSection(),
                  const SizedBox(height: 14),
                  if (isTaxInvoice) ...[
                    _buildTaxItemsSection(),
                    const SizedBox(height: 14),
                  ],
                  _buildSummarySection(),
                  const SizedBox(height: 24),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceTypeSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colour.lightblack,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Invoice Type',
            style: TextStyle(
              color: Colour.pWhite,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colour.plightpurple;
                }
                return Colour.blackgery;
              }),
              foregroundColor: WidgetStateProperty.all(Colour.pWhite),
              side: WidgetStateProperty.all(
                const BorderSide(color: Colour.darkgrey),
              ),
            ),
            segments: const [
              ButtonSegment<String>(
                value: 'SALES_INVOICE',
                label: Text('Sales Invoice'),
              ),
              ButtonSegment<String>(
                value: 'TAX_INVOICE',
                label: Text('Tax Invoice'),
              ),
            ],
            selected: <String>{invoiceType},
            onSelectionChanged: (Set<String> selection) {
              setState(() {
                invoiceType = selection.first;
                _recalculateTotals();
              });
            },
          ),
          if (isTaxInvoice) ...[
            const SizedBox(height: 10),
            const Text(
              'GST is split equally into SGST and CGST as standard local tax calculation.',
              style: TextStyle(color: Colour.mediumGray, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTaxItemsSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colour.lightblack,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Tax Details',
            style: TextStyle(
              color: Colour.pWhite,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          for (int index = 0; index < _taxItems.length; index++) ...[
            _buildTaxItemCard(_taxItems[index], index),
            if (index != _taxItems.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildTaxItemCard(_TaxLineItem item, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colour.blackgery,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.productName,
            style: const TextStyle(
              color: Colour.pWhite,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Base Amount: ${formatRupees(item.lineTotal)}',
            style: const TextStyle(color: Colour.mediumGray),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: item.gstPercentage == 0
                ? ''
                : item.gstPercentage.toStringAsFixed(2),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            style: const TextStyle(color: Colour.mediumGray),
            decoration: InputDecoration(
              fillColor: Colour.pBackgroundBlack,
              filled: true,
              labelText: 'GST %',
              hintText: 'Example: 5, 12, 18',
              prefixIcon: const Icon(Icons.percent, color: Colour.darkgrey),
              labelStyle: const TextStyle(color: Colour.darkgrey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Colour.plightpurple, width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {
                item.gstPercentage = double.tryParse(value) ?? 0.0;
                _recalculateTotals();
              });
            },
          ),
          const SizedBox(height: 10),
          _buildSummaryRow('Taxable', formatRupees(item.taxableAmount)),
          _buildSummaryRow(
            'SGST (${item.sgstPercentage.toStringAsFixed(2)}%)',
            formatRupees(item.sgstAmount),
          ),
          _buildSummaryRow(
            'CGST (${item.cgstPercentage.toStringAsFixed(2)}%)',
            formatRupees(item.cgstAmount),
          ),
          _buildSummaryRow('Line Total', formatRupees(item.netAmount)),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colour.lightblack,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Total Item', _taxItems.length.toString()),
          _buildSummaryRow('Total Amount', formatRupees(totalAmount)),
          const SizedBox(height: 10),
          _buildTextFieldDecimal(
            controller: discountAmount,
            label: 'Discount Amount',
            hint: 'Enter discount amount',
            icon: Icons.currency_rupee,
            onChanged: (value) {
              setState(_recalculateTotals);
            },
          ),
          const SizedBox(height: 10),
          _buildSummaryRow(
            'Taxable Amount',
            formatRupees(totalTaxableAmount),
          ),
          if (isTaxInvoice) ...[
            _buildSummaryRow('SGST', formatRupees(totalSgstAmount)),
            _buildSummaryRow('CGST', formatRupees(totalCgstAmount)),
          ],
          _buildSummaryRow('Round Off', formatRupees(roundOf)),
          _buildSummaryRow('Net Total', formatRupees(netTotal), isBold: true),
          _buildSummaryRow('Previous Balance', formatRupees(previousAmount)),
          _buildSummaryRow(
            'Amount to be Paid',
            formatRupees(amountToBePaid),
            isBold: true,
          ),
          const SizedBox(height: 10),
          if (collectPayment) ...[
            _buildTextFieldDecimal(
              validator: (value) {
                if (!collectPayment) {
                  return null;
                }
                if (value == null || value.trim().isEmpty) {
                  return 'Amount Required';
                }
                return null;
              },
              controller: paidAmountController,
              label: 'Paid Amount',
              hint: 'Enter paid amount',
              icon: Icons.payment,
            ),
            const SizedBox(height: 10),
          ],
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              const Text(
                'Payment type:',
                style: TextStyle(color: Colour.pWhite),
              ),
              _buildRadioButton('Cash'),
              _buildRadioButton('Bank'),
              _buildRadioButton('Credit'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          activeColor: Colour.pWhite,
          focusColor: Colour.pWhite,
          value: value,
          groupValue: selectedOption,
          onChanged: (newValue) {
            setState(() {
              selectedOption = newValue!;
              paymentType = newValue.toUpperCase();
              collectPayment = newValue != 'Credit';
              if (!collectPayment) {
                paidAmountController.clear();
              }
            });
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colour.pWhite),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colour.mediumGray,
              ),
            ),
          ),
          const Text(
            ':',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colour.mediumGray,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colour.mediumGray,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldDecimal({
    String? Function(String?)? validator,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      style: const TextStyle(color: Colour.mediumGray),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,4}')),
      ],
      decoration: InputDecoration(
        fillColor: Colour.blackgery,
        filled: true,
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colour.darkgrey),
        labelStyle: const TextStyle(color: Colour.darkgrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colour.plightpurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colour.plightpurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            elevation: 4,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              showPopup(context);
            }
          },
          child: const Text('Save Invoice'),
        ),
      ),
    );
  }

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Save Invoice'),
          content: const Text('Do you want to save this invoice?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colour.pDeepDarkBlue),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                final double discountAmt =
                    _round4(double.tryParse(discountAmount.text) ?? 0.0);
                final double discountPercentage = _round4(
                  totalAmount == 0 ? 0.0 : (discountAmt / totalAmount) * 100,
                );
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final String currentDate =
                    DateFormat('yyyy-MM-dd').format(DateTime.now());
                final String transactionYear =
                    DateFormat('yyyy').format(DateTime.now());
                final LoginModel? storedResponse =
                    await GetLoginRepo().getUserLoginResponse();

                if (storedResponse == null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User details not available'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  return;
                }

                final List<Product> productList =
                    _taxItems.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final _TaxLineItem item = entry.value;
                  return Product(
                    orderId: 0,
                    siNo: index + 1,
                    productId: item.item.productId,
                    partNumber: item.item.partNumber,
                    productName: item.item.productName,
                    packingDescription: item.item.packingDescription,
                    packingId: item.item.packingId,
                    packingName: item.item.packingName,
                    quantity: item.item.quantity,
                    foc: item.item.fac,
                    srtQty: item.item.srt,
                    totalQty: item.item.quantity,
                    companyId: storedResponse.companyId,
                    clientId: widget.client.id ?? 0,
                    invoiceId: 0,
                    unitRate: double.tryParse(item.item.sell) ?? 0.0,
                    totalRate: item.lineTotal,
                    gstPercentage: item.gstPercentage,
                    sgstPercentage: item.sgstPercentage,
                    cgstPercentage: item.cgstPercentage,
                    igstPercentage: item.igstPercentage,
                    cessPercentage: 0.0,
                    taxableAmount: item.taxableAmount,
                    sgstAmount: item.sgstAmount,
                    cgstAmount: item.cgstAmount,
                    igstAmount: item.igstAmount,
                    cessAmount: 0.0,
                    netAmount: item.netAmount,
                  );
                }).toList();

                final OrderModel order = OrderModel(
                  id: 0,
                  uuid: '',
                  companyId: storedResponse.companyId,
                  invoiceId: 0,
                  clientId: widget.client.id ?? 0,
                  clientName: widget.client.name ?? '',
                  driverId: storedResponse.employeeId,
                  driverName: storedResponse.userName,
                  payType: paymentType.toUpperCase(),
                  invoiceNo: '',
                  invoiceDate: currentDate,
                  receiptNo: '',
                  routeId: storedResponse.routeId,
                  vehicleId: storedResponse.vehicleId,
                  vehicleNo: prefs.getString('selected_vehicle') ?? '',
                  invoiceType: invoiceType,
                  total: _round4(totalAmount),
                  discountPercentage: discountPercentage,
                  discountAmount: discountAmt,
                  totalTaxableAmount: _round4(totalTaxableAmount),
                  totalSgstAmount: _round4(totalSgstAmount),
                  totalCgstAmount: _round4(totalCgstAmount),
                  totalIgstAmount: _round4(totalIgstAmount),
                  totalCessAmount: _round4(totalCessAmount),
                  roundOf: _round4(roundOf),
                  netTotal: _round4(netTotal),
                  transactionYear: int.parse(transactionYear),
                  latitude: _round4(latitude ?? 0),
                  longitude: _round4(longitude ?? 0),
                  paidAmount: paidAmountController.text.isEmpty
                      ? 0.0
                      : _round4(double.parse(paidAmountController.text)),
                  mobileAppSalesInvoiceDetails: productList,
                );

                if (context.mounted) {
                  context.read<AddItemBloc>().add(PostAddedItems(order));
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colour.pDeepDarkBlue),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TaxLineItem {
  final ProductItem item;
  double gstPercentage;
  double sgstPercentage;
  double cgstPercentage;
  double igstPercentage;
  double taxableAmount;
  double sgstAmount;
  double cgstAmount;
  double igstAmount;
  double netAmount;

  _TaxLineItem({
    required this.item,
    required this.gstPercentage,
    required this.sgstPercentage,
    required this.cgstPercentage,
    required this.igstPercentage,
    required this.taxableAmount,
    required this.sgstAmount,
    required this.cgstAmount,
    required this.igstAmount,
    required this.netAmount,
  });

  factory _TaxLineItem.fromProductItem(ProductItem item) {
    return _TaxLineItem(
      item: item,
      gstPercentage: 0.0,
      sgstPercentage: 0.0,
      cgstPercentage: 0.0,
      igstPercentage: 0.0,
      taxableAmount: item.totalRate,
      sgstAmount: 0.0,
      cgstAmount: 0.0,
      igstAmount: 0.0,
      netAmount: item.totalRate,
    );
  }

  String get productName => item.productName;
  double get lineTotal => item.totalRate;

  void recalculate({
    required bool isTaxInvoice,
    required double taxableAmount,
  }) {
    this.taxableAmount = OrderModel.roundToFourDecimals(taxableAmount);
    if (!isTaxInvoice) {
      sgstPercentage = 0.0;
      cgstPercentage = 0.0;
      igstPercentage = 0.0;
      sgstAmount = 0.0;
      cgstAmount = 0.0;
      igstAmount = 0.0;
      netAmount = OrderModel.roundToFourDecimals(this.taxableAmount);
      return;
    }

    final double localHalf = OrderModel.roundToFourDecimals(gstPercentage / 2);
    sgstPercentage = localHalf;
    cgstPercentage = localHalf;
    igstPercentage = 0.0;
    sgstAmount = OrderModel.roundToFourDecimals(
        this.taxableAmount * sgstPercentage / 100);
    cgstAmount = OrderModel.roundToFourDecimals(
        this.taxableAmount * cgstPercentage / 100);
    igstAmount = 0.0;
    netAmount = OrderModel.roundToFourDecimals(
      this.taxableAmount + sgstAmount + cgstAmount,
    );
  }
}
