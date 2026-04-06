import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:Yadhava/features/auth/data/login_model.dart';
import 'package:Yadhava/features/auth/domain/login_repo.dart';
import 'package:Yadhava/features/customer/data/client_model.dart';
import 'package:Yadhava/features/customer/data/sales_quotation_model.dart';
import 'package:Yadhava/features/customer/domain/sales_quotation_repo.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/product_master.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuotationFormPage extends StatefulWidget {
  const QuotationFormPage({
    super.key,
    required this.client,
    this.initialQuotation,
  });

  final ClientModel client;
  final SalesQuotation? initialQuotation;

  @override
  State<QuotationFormPage> createState() => _QuotationFormPageState();
}

class _QuotationFormPageState extends State<QuotationFormPage> {
  final SalesQuotationRepo _repo = SalesQuotationRepo();
  final GetLoginRepo _loginRepo = GetLoginRepo();
  final LocalDbHelper _db = LocalDbHelper();
  final TextEditingController _quoteDateController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  List<ProductMaster> _products = const <ProductMaster>[];
  List<SalesQuotationDetail> _details = <SalesQuotationDetail>[];
  bool _loading = true;
  bool _saving = false;
  LoginModel? _loginModel;

  bool get _isEdit => widget.initialQuotation != null;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _quoteDateController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final login = await _loginRepo.getUserLoginResponse();
    if (login == null) return;
    final products = await _db.getProductMaster(login.companyId);
    final quotation = widget.initialQuotation;

    setState(() {
      _loginModel = login;
      _products = products;
      _quoteDateController.text = quotation?.quoteDate.isNotEmpty == true
          ? quotation!.quoteDate
          : DateFormat('yyyy-MM-dd').format(DateTime.now());
      _remarksController.text = quotation?.remarks ?? '';
      _details = quotation?.inventorySalesQuotationDetails.toList() ??
          <SalesQuotationDetail>[];
      _loading = false;
    });
  }

  double get _total =>
      _details.fold<double>(0, (sum, item) => sum + item.totalRate);

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = DateTime.tryParse(_quoteDateController.text) ?? now;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
    );
    if (date == null) return;
    _quoteDateController.text = DateFormat('yyyy-MM-dd').format(date);
    if (mounted) setState(() {});
  }

  Future<void> _addItem() async {
    if (_products.isEmpty) return;
    ProductMaster? selected = _products.first;
    final qtyController = TextEditingController(text: '1');
    final rateController = TextEditingController(
      text: selected.sellingPrice.toStringAsFixed(2),
    );

    final result = await showDialog<SalesQuotationDetail>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const Text('Add Product'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<ProductMaster>(
                      initialValue: selected,
                      isExpanded: true,
                      items: _products
                          .map(
                            (product) => DropdownMenuItem<ProductMaster>(
                              value: product,
                              child: Text(product.productName),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setLocalState(() {
                          selected = value;
                          rateController.text =
                              value.sellingPrice.toStringAsFixed(2);
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Product'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: qtyController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Quantity'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: rateController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(labelText: 'Unit Rate'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final product = selected;
                    if (product == null) return;
                    final qty = double.tryParse(qtyController.text.trim()) ?? 0;
                    final rate =
                        double.tryParse(rateController.text.trim()) ?? 0;
                    Navigator.pop(
                      context,
                      SalesQuotationDetail(
                        siNo: _details.length + 1,
                        productId: product.productId,
                        partNumber: product.partNumber,
                        productName: product.productName,
                        packingDescription: product.packingDescription,
                        packingId: product.packingId,
                        packingName: product.packingName,
                        quantity: qty,
                        foc: 0,
                        srtQty: 0,
                        totalQty: qty,
                        unitRate: rate,
                        totalRate: qty * rate,
                      ),
                    );
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );

    qtyController.dispose();
    rateController.dispose();

    if (result == null) return;
    setState(() {
      _details = <SalesQuotationDetail>[..._details, result];
    });
  }

  Future<void> _save() async {
    if (_saving || _loginModel == null) return;
    if (_details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one item.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final quotation = SalesQuotation(
        invoiceId: widget.initialQuotation?.invoiceId ?? 0,
        companyId: _loginModel!.companyId,
        branchId: _loginModel!.vehicleId,
        quoteDate: _quoteDateController.text.trim(),
        quoteNo: widget.initialQuotation?.quoteNo ?? '',
        salesManId: _loginModel!.employeeId,
        salesManName: _loginModel!.employeeName,
        saleAccountId: 0,
        saleAccountName: '',
        customerAccountId: widget.client.id ?? 0,
        customerAccountName: widget.client.contactPersonName?.isNotEmpty == true
            ? widget.client.contactPersonName!
            : (widget.client.name ?? ''),
        address: '',
        telFax: '',
        mobile: widget.client.mobile ?? '',
        email: '',
        poBox: '',
        contactPersonDetails: widget.client.contactPersonName ?? '',
        currencyId: 1,
        currencyName: 'INR',
        currencyRate: 1,
        invoiceNo: '',
        invoiceDate: _quoteDateController.text.trim(),
        remarks: _remarksController.text.trim(),
        tenderdAmount: 0,
        balanceToPay: _total,
        roundOf: 0,
        totalAmount: _total,
        totalDiscount: 0,
        totalDiscountVal: 0,
        totalTaxableAmount: _total,
        totalIgstAmount: 0,
        totalCgstAmount: 0,
        totalSgstAmount: 0,
        totalCessAmount: 0,
        netTotal: _total,
        totalItems: _details.length.toDouble(),
        totalQty: _details.fold<double>(0, (sum, item) => sum + item.quantity),
        orderStatus: 'OPEN',
        programStatus: '',
        paidStatus: '',
        advanceAmount: 0,
        bagQty: 0,
        transactionYear: DateTime.now().year.toString(),
        inventorySalesQuotationDetails: _details,
      );

      if (_isEdit) {
        await _repo.update(quotation);
      } else {
        await _repo.insert(quotation);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEdit
                ? 'Quotation updated successfully.'
                : 'Quotation created successfully.',
          ),
        ),
      );
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save quotation: $error')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colour.pBackgroundBlack,
      appBar: AppBar(
        backgroundColor: Colour.pDeepLightBlue,
        foregroundColor: Colors.white,
        title: Text(_isEdit ? 'Edit Sales Order' : 'Create Sales Order'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading ? null : _addItem,
        backgroundColor: Colour.pWhite,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReadOnlyField(
                    'Customer',
                    widget.client.contactPersonName?.isNotEmpty == true
                        ? widget.client.contactPersonName!
                        : (widget.client.name ?? ''),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _quoteDateController,
                    readOnly: true,
                    onTap: _pickDate,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Quote Date').copyWith(
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _remarksController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration('Remarks'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Items',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ..._details.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colour.pContainerBlack,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Qty: ${item.quantity}  Rate: ${item.unitRate.toStringAsFixed(2)}  Total: ${item.totalRate.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _details.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (_details.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          'No items added yet.',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colour.pTextBoxColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryRow(
                            'Total Items', _details.length.toString()),
                        const SizedBox(height: 6),
                        _buildSummaryRow(
                          'Total Qty',
                          _details
                              .fold<double>(
                                  0, (sum, item) => sum + item.quantity)
                              .toStringAsFixed(2),
                        ),
                        const SizedBox(height: 6),
                        _buildSummaryRow(
                            'Net Total', _total.toStringAsFixed(2)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colour.pDeepLightBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(_saving
                          ? 'Saving...'
                          : (_isEdit
                              ? 'Update Sales Order'
                              : 'Create Sales Order')),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colour.pTextBoxColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colour.pTextBoxColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
