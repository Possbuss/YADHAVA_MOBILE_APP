import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:Yadhava/features/auth/domain/login_repo.dart';
import 'package:Yadhava/features/customer/data/client_model.dart';
import 'package:Yadhava/features/customer/data/sales_quotation_model.dart';
import 'package:Yadhava/features/customer/domain/sales_quotation_repo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'quotation_form_page.dart';
import 'sales_order_print_helper.dart';

class QuotationRegisterPage extends StatefulWidget {
  const QuotationRegisterPage({
    super.key,
    required this.client,
  });

  final ClientModel client;

  @override
  State<QuotationRegisterPage> createState() => _QuotationRegisterPageState();
}

class _QuotationRegisterPageState extends State<QuotationRegisterPage> {
  final SalesQuotationRepo _repo = SalesQuotationRepo();
  final GetLoginRepo _loginRepo = GetLoginRepo();
  final LocalDbHelper _localDbHelper = LocalDbHelper();
  bool _loading = true;
  List<SalesQuotationRegisterItem> _quotations =
      const <SalesQuotationRegisterItem>[];

  bool get _canCreate => (widget.client.id ?? 0) > 0;
  bool get _showAllCustomers => !_canCreate;

  @override
  void initState() {
    super.initState();
    _loadRegister();
  }

  Future<void> _loadRegister() async {
    setState(() => _loading = true);
    try {
      final items = await _repo.getQuotationRegister(
        fromDate: DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(const Duration(days: 30))),
        endDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        partyId: widget.client.id ?? 0,
        companyId: widget.client.companyId ?? 0,
      );
      if (!mounted) return;
      setState(() {
        _quotations = items;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load sales orders: $error')),
      );
    }
  }

  Future<void> _openCreate() async {
    if (!_canCreate) {
      await _openCustomerPicker();
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuotationFormPage(client: widget.client),
      ),
    );
    if (result == true) {
      await _loadRegister();
    }
  }

  Future<List<ClientModel>> _loadAvailableClients() async {
    final login = await _loginRepo.getUserLoginResponse();
    if (login == null) {
      return const <ClientModel>[];
    }

    final clients = await _localDbHelper.getClients(
      login.routeId,
      login.companyId,
    );

    clients.sort((a, b) {
      final nameA = (a.contactPersonName?.isNotEmpty == true
              ? a.contactPersonName
              : a.name) ??
          '';
      final nameB = (b.contactPersonName?.isNotEmpty == true
              ? b.contactPersonName
              : b.name) ??
          '';
      return nameA.toLowerCase().compareTo(nameB.toLowerCase());
    });

    return clients;
  }

  Future<void> _openCustomerPicker() async {
    final selectedClient = await showModalBottomSheet<ClientModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colour.pContainerBlack,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.72,
        minChildSize: 0.45,
        maxChildSize: 0.92,
        builder: (_, controller) => FutureBuilder<List<ClientModel>>(
          future: _loadAvailableClients(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final clients = snapshot.data ?? const <ClientModel>[];
            if (clients.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No local customers available. Please sync customers first.',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 18),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'Select Customer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    controller: controller,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: clients.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final client = clients[index];
                      final customerName =
                          client.contactPersonName?.isNotEmpty == true
                              ? client.contactPersonName!
                              : (client.name ?? 'Unnamed Customer');

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => Navigator.pop(context, client),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colour.pBackgroundBlack,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white12,
                                  child: Text(
                                    customerName.isNotEmpty
                                        ? customerName[0].toUpperCase()
                                        : 'C',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        customerName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if ((client.mobile ?? '').isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          client.mobile!,
                                          style: const TextStyle(
                                            color: Colors.white60,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white38,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    if (!mounted || selectedClient == null) {
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuotationFormPage(client: selectedClient),
      ),
    );
    if (result == true) {
      await _loadRegister();
    }
  }

  Future<void> _openEdit(SalesQuotationRegisterItem item) async {
    try {
      final quotation = await _repo.getById(
        invoiceId: item.invoiceId,
        companyId: widget.client.companyId ?? 0,
      );
      if (!mounted) return;
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuotationFormPage(
            client: widget.client,
            initialQuotation: quotation,
          ),
        ),
      );
      if (result == true) {
        await _loadRegister();
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open sales order: $error')),
      );
    }
  }

  Future<void> _printOrder(SalesQuotationRegisterItem item) async {
    try {
      final login = await _loginRepo.getUserLoginResponse();
      if (login == null) {
        throw Exception('Login details not found.');
      }

      final quotation = await _repo.getById(
        invoiceId: item.invoiceId,
        companyId: widget.client.companyId ?? login.companyId,
      );

      await SalesOrderPrintHelper.printSalesOrder(
        quotation: quotation,
        loginModel: login,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to print sales order: $error')),
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
        title: Text(_showAllCustomers ? 'Sales Orders' : 'Customer Sales Orders'),
        actions: [
          IconButton(
            onPressed: _loadRegister,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreate,
        backgroundColor: Colour.pWhite,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add_business_outlined),
        label: Text(_canCreate ? 'Create' : 'Create Sales Order'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_showAllCustomers)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colour.pContainerBlack,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Text(
                      'Open a customer to create a new sales order. This screen shows all existing sales orders.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                Expanded(
                  child: _quotations.isEmpty
                      ? const Center(
                          child: Text(
                            'No sales orders found.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final item = _quotations[index];
                    return InkWell(
                      onTap: () => _openEdit(item),
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colour.pContainerBlack,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.quoteNo.isNotEmpty
                                            ? item.quoteNo
                                            : 'Draft Sales Order',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.customerAccountName,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item.netTotal.toStringAsFixed(2),
                                    style: const TextStyle(
                                      color: Colour.plightpurple,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (item.remarks.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                'Remarks: ${item.remarks}',
                                style: const TextStyle(color: Colors.white60),
                              ),
                            ],
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.08),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Quote Date: ${item.quoteDate}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  if (item.orderStatus.isNotEmpty) ...[
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        item.orderStatus,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () => _printOrder(item),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.04,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.print_outlined,
                                          color: Colors.white70,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: _quotations.length,
                        ),
                ),
              ],
            ),
    );
  }
}
