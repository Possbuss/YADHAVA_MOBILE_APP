import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/features/customer/data/client_model.dart';
import 'package:Yadhava/features/customer/data/sales_quotation_model.dart';
import 'package:Yadhava/features/customer/domain/sales_quotation_repo.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'quotation_form_page.dart';

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
  bool _loading = true;
  List<SalesQuotationRegisterItem> _quotations =
      const <SalesQuotationRegisterItem>[];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colour.pBackgroundBlack,
      appBar: AppBar(
        backgroundColor: Colour.pDeepLightBlue,
        foregroundColor: Colors.white,
        title: const Text('Sales Orders'),
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
        label: const Text('Create'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _quotations.isEmpty
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
                              children: [
                                Expanded(
                                  child: Text(
                                    item.quoteNo.isNotEmpty
                                        ? item.quoteNo
                                        : 'Draft Sales Order',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  item.netTotal.toStringAsFixed(2),
                                  style: const TextStyle(
                                    color: Colour.plightpurple,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.customerAccountName,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Quote Date: ${item.quoteDate}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            if (item.remarks.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(
                                'Remarks: ${item.remarks}',
                                style: const TextStyle(color: Colors.white60),
                              ),
                            ],
                            if (item.orderStatus.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(999),
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
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: _quotations.length,
                ),
    );
  }
}
