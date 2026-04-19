import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../sales_quotation_model.dart';

class SalesQuotationLocalDataSource {
  Future<SharedPreferences> get _prefs async =>
      SharedPreferences.getInstance();

  String draftKey({
    required int companyId,
    required int customerId,
    required int invoiceId,
  }) {
    return 'sales_quotation_draft_${companyId}_${customerId}_$invoiceId';
  }

  Future<void> saveDraft(SalesQuotation quotation) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(
      draftKey(
        companyId: quotation.companyId,
        customerId: quotation.customerAccountId,
        invoiceId: quotation.invoiceId,
      ),
      jsonEncode(quotation.toJson()),
    );
  }

  Future<SalesQuotation?> getDraft({
    required int companyId,
    required int customerId,
    required int invoiceId,
  }) async {
    final SharedPreferences prefs = await _prefs;
    final String? rawDraft = prefs.getString(
      draftKey(
        companyId: companyId,
        customerId: customerId,
        invoiceId: invoiceId,
      ),
    );
    if (rawDraft == null || rawDraft.isEmpty) {
      return null;
    }

    try {
      return SalesQuotation.fromJson(
        jsonDecode(rawDraft) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clearDraft({
    required int companyId,
    required int customerId,
    required int invoiceId,
  }) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(
      draftKey(
        companyId: companyId,
        customerId: customerId,
        invoiceId: invoiceId,
      ),
    );
  }
}
