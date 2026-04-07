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

import 'sales_order_print_helper.dart';

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
  bool _draftLoaded = false;
  LoginModel? _loginModel;
  int _invoiceId = 0;
  String _quoteNo = '';
  int _customerAccountId = 0;
  String _customerAccountName = '';
  String _customerMobile = '';
  String _contactPersonDetails = '';

  bool get _isEdit => widget.initialQuotation != null;

  @override
  void initState() {
    super.initState();
    _quoteDateController.addListener(_persistDraftIfNeeded);
    _remarksController.addListener(_persistDraftIfNeeded);
    _loadData();
  }

  @override
  void dispose() {
    _quoteDateController.removeListener(_persistDraftIfNeeded);
    _remarksController.removeListener(_persistDraftIfNeeded);
    _quoteDateController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final login = await _loginRepo.getUserLoginResponse();
    if (login == null) return;
    final products = await _db.getProductMaster(login.companyId);
    final int draftCustomerId =
        widget.initialQuotation?.customerAccountId ?? widget.client.id ?? 0;
    final SalesQuotation? draft = await _repo.getDraft(
      companyId: login.companyId,
      customerId: draftCustomerId,
      invoiceId: widget.initialQuotation?.invoiceId ?? 0,
    );
    final quotation = widget.initialQuotation ?? draft;

    setState(() {
      _loginModel = login;
      _products = products;
      _invoiceId = quotation?.invoiceId ?? widget.initialQuotation?.invoiceId ?? 0;
      _quoteNo = quotation?.quoteNo ?? widget.initialQuotation?.quoteNo ?? '';
      _customerAccountId =
          quotation?.customerAccountId ?? widget.client.id ?? 0;
      _customerAccountName =
          quotation?.customerAccountName.isNotEmpty == true
              ? quotation!.customerAccountName
              : (widget.client.contactPersonName?.isNotEmpty == true
                  ? widget.client.contactPersonName!
                  : (widget.client.name ?? ''));
      _customerMobile = quotation?.mobile.isNotEmpty == true
          ? quotation!.mobile
          : (widget.client.mobile ?? '');
      _contactPersonDetails = quotation?.contactPersonDetails.isNotEmpty == true
          ? quotation!.contactPersonDetails
          : (widget.client.contactPersonName ?? '');
      _quoteDateController.text = quotation?.quoteDate.isNotEmpty == true
          ? quotation!.quoteDate
          : DateFormat('yyyy-MM-dd').format(DateTime.now());
      _remarksController.text = quotation?.remarks ?? '';
      _details = quotation?.inventorySalesQuotationDetails.toList() ??
          <SalesQuotationDetail>[];
      _draftLoaded = draft != null;
      _loading = false;
    });

    if (draft != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.initialQuotation == null
                ? 'Saved sales order draft restored.'
                : 'Saved sales order changes restored.',
          ),
        ),
      );
    }
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
    final result = await _showItemDialog();
    if (result == null) return;

    if (_hasDuplicateProduct(result.productId)) {
      _showDuplicateItemMessage();
      return;
    }

    setState(() {
      _details = <SalesQuotationDetail>[..._details, result];
    });
    _persistDraftIfNeeded();
  }

  Future<SalesQuotationDetail?> _showItemDialog({
    SalesQuotationDetail? initialDetail,
    int? editIndex,
  }) async {
    if (_products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No products available to add.')),
      );
      return null;
    }

    return showDialog<SalesQuotationDetail>(
      context: context,
      builder: (context) => _AddQuotationItemDialog(
        products: _products,
        nextSiNo: editIndex != null ? editIndex + 1 : _details.length + 1,
        initialDetail: initialDetail,
      ),
    );
  }

  Future<void> _editItem(int index) async {
    final result = await _showItemDialog(
      initialDetail: _details[index],
      editIndex: index,
    );
    if (result == null) return;

    if (_hasDuplicateProduct(result.productId, ignoreIndex: index)) {
      _showDuplicateItemMessage();
      return;
    }

    setState(() {
      final updated = <SalesQuotationDetail>[..._details];
      updated[index] = result;
      _details = _reindexDetails(updated);
    });
    _persistDraftIfNeeded();
  }

  void _deleteItem(int index) {
    setState(() {
      final updated = <SalesQuotationDetail>[..._details]..removeAt(index);
      _details = _reindexDetails(updated);
    });
    _persistDraftIfNeeded();
  }

  List<SalesQuotationDetail> _reindexDetails(List<SalesQuotationDetail> details) {
    return details.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      return item.copyWith(siNo: index + 1);
    }).toList();
  }

  bool _hasDuplicateProduct(int productId, {int? ignoreIndex}) {
    return _details.asMap().entries.any((entry) {
      if (ignoreIndex != null && entry.key == ignoreIndex) {
        return false;
      }
      return entry.value.productId == productId;
    });
  }

  void _showDuplicateItemMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This item is already added. Duplicate items are not allowed.'),
      ),
    );
  }

  SalesQuotation _buildQuotation() {
    return SalesQuotation(
      invoiceId: _invoiceId,
      companyId: _loginModel!.companyId,
      branchId: _loginModel!.vehicleId,
      quoteDate: _quoteDateController.text.trim(),
      quoteNo: _quoteNo,
      salesManId: _loginModel!.employeeId,
      salesManName: _loginModel!.employeeName,
      saleAccountId: 0,
      saleAccountName: '',
      customerAccountId: _customerAccountId,
      customerAccountName: _customerAccountName,
      address: '',
      telFax: '',
      mobile: _customerMobile,
      email: '',
      poBox: '',
      contactPersonDetails: _contactPersonDetails,
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
  }

  Future<void> _persistDraftIfNeeded() async {
    if (_loading || _loginModel == null) {
      return;
    }

    final bool hasMeaningfulDraft = _details.isNotEmpty ||
        _remarksController.text.trim().isNotEmpty ||
        _quoteDateController.text.trim().isNotEmpty;

    if (!hasMeaningfulDraft) {
      await _repo.clearDraft(
        companyId: _loginModel!.companyId,
        customerId: _customerAccountId,
        invoiceId: _invoiceId,
      );
      return;
    }

    await _repo.saveDraft(_buildQuotation());
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
      final quotation = _buildQuotation();

      if (_isEdit) {
        await _repo.update(quotation);
      } else {
        await _repo.insert(quotation);
      }

      await _repo.clearDraft(
        companyId: _loginModel!.companyId,
        customerId: _customerAccountId,
        invoiceId: _invoiceId,
      );

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

  Future<void> _printSalesOrder() async {
    if (_loginModel == null || _details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add items before printing sales order.')),
      );
      return;
    }

    try {
      await SalesOrderPrintHelper.printSalesOrder(
        quotation: _buildQuotation(),
        loginModel: _loginModel!,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate sales order PDF: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colour.pBackgroundBlack,
      appBar: AppBar(
        backgroundColor: Colour.pDeepLightBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 66,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        title: Text(
          _isEdit ? 'Edit Sales Order' : 'Create Sales Order',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: _loading ? null : _printSalesOrder,
            icon: const Icon(Icons.download_outlined),
            tooltip: 'Print Sales Order',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading ? null : _addItem,
        backgroundColor: Colour.pWhite,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
                  Text(
                    _customerAccountName.isNotEmpty ? _customerAccountName : 'Customer',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildReadOnlyField(
                    'Customer',
                    _customerAccountName,
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
                  if (_draftLoaded)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B3F2E),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'This sales order is being kept locally as a draft until you submit it.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
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
                    return _QuotationItemSlidableCard(
                      key: ValueKey('${item.productId}-${item.siNo}-$index'),
                      item: item,
                      onEdit: () => _editItem(index),
                      onDelete: () => _deleteItem(index),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colour.pTextBoxColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _AddQuotationItemDialog extends StatefulWidget {
  const _AddQuotationItemDialog({
    required this.products,
    required this.nextSiNo,
    this.initialDetail,
  });

  final List<ProductMaster> products;
  final int nextSiNo;
  final SalesQuotationDetail? initialDetail;

  @override
  State<_AddQuotationItemDialog> createState() => _AddQuotationItemDialogState();
}

class _AddQuotationItemDialogState extends State<_AddQuotationItemDialog> {
  late ProductMaster _selected;
  late TextEditingController _qtyController;
  late TextEditingController _rateController;

  @override
  void initState() {
    super.initState();
    final initialProduct = widget.initialDetail == null
        ? widget.products.first
        : widget.products.firstWhere(
            (item) => item.productId == widget.initialDetail!.productId,
            orElse: () => widget.products.first,
          );
    _selected = initialProduct;
    _qtyController = TextEditingController(
      text: widget.initialDetail?.quantity.toString() ?? '1',
    );
    _rateController = TextEditingController(
      text: (widget.initialDetail?.unitRate ?? _selected.sellingPrice)
          .toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _qtyController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  InputDecoration _dialogFieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF212121),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _submit() {
    final qty = double.tryParse(_qtyController.text.trim()) ?? 0;
    final rate = double.tryParse(_rateController.text.trim()) ?? 0;

    Navigator.of(context).pop(
      SalesQuotationDetail(
        siNo: widget.nextSiNo,
        productId: _selected.productId,
        partNumber: _selected.partNumber,
        productName: _selected.productName,
        packingDescription: _selected.packingDescription,
        packingId: _selected.packingId,
        packingName: _selected.packingName,
        quantity: qty,
        foc: 0,
        srtQty: 0,
        totalQty: qty,
        unitRate: rate,
        totalRate: qty * rate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF181818),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Text(
        widget.initialDetail == null ? 'Add Product' : 'Edit Product',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputDecorator(
              decoration: _dialogFieldDecoration('Product'),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selected.productId,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF212121),
                  borderRadius: BorderRadius.circular(14),
                  elevation: 4,
                  style: const TextStyle(color: Colors.white),
                  menuMaxHeight: 320,
                  items: widget.products
                      .map(
                        (product) => DropdownMenuItem<int>(
                          value: product.productId,
                          child: Text(
                            product.productName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (productId) {
                    if (productId == null) return;
                    final product = widget.products.firstWhere(
                      (item) => item.productId == productId,
                    );
                    setState(() {
                      _selected = product;
                      _rateController.text =
                          product.sellingPrice.toStringAsFixed(2);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _qtyController,
              style: const TextStyle(color: Colors.white),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _dialogFieldDecoration('Quantity'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _rateController,
              style: const TextStyle(color: Colors.white),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _dialogFieldDecoration('Unit Rate'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.initialDetail == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}

class _QuotationItemSlidableCard extends StatefulWidget {
  const _QuotationItemSlidableCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final SalesQuotationDetail item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<_QuotationItemSlidableCard> createState() =>
      _QuotationItemSlidableCardState();
}

class _QuotationItemSlidableCardState extends State<_QuotationItemSlidableCard> {
  static const double _actionWidth = 148;
  double _dragOffset = 0;

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dx).clamp(-_actionWidth, 0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      _dragOffset = _dragOffset.abs() > (_actionWidth / 2) ? -_actionWidth : 0;
    });
  }

  void _closeActions() {
    if (_dragOffset == 0) return;
    setState(() {
      _dragOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        onTap: _closeActions,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF232323),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _SlideActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      color: const Color(0xFF2C6BFF),
                      onTap: () {
                        _closeActions();
                        widget.onEdit();
                      },
                    ),
                    _SlideActionButton(
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      color: const Color(0xFFD94B4B),
                      onTap: () {
                        _closeActions();
                        widget.onDelete();
                      },
                    ),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(_dragOffset, 0, 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.productName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '₹${widget.item.totalRate.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Qty ${widget.item.quantity.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'UOM ${widget.item.packingName ?? '-'}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Rate ${widget.item.unitRate.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Total ${widget.item.totalRate.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Code: ${widget.item.partNumber}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.swipe_left_alt_outlined,
                          color: Colors.white30,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideActionButton extends StatelessWidget {
  const _SlideActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
