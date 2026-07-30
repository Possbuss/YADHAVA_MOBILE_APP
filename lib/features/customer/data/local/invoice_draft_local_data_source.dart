import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../client_model.dart';
import '../../presentation/pages/customer_details/model/addItem_model.dart';

class InvoiceDraft {
  final ClientModel client;
  final List<ProductItem> items;
  final DateTime savedAt;

  const InvoiceDraft({
    required this.client,
    required this.items,
    required this.savedAt,
  });

  factory InvoiceDraft.fromJson(Map<String, dynamic> json) {
    final clientJson = Map<String, dynamic>.from(json['client'] as Map);
    final itemJson = (json['items'] as List? ?? const [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    return InvoiceDraft(
      client: ClientModel.fromJson(clientJson),
      items: itemJson.map(ProductItem.fromMap).toList(),
      savedAt: DateTime.tryParse(json['savedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client': client.toJson(),
      'items': items.map((item) => item.toMap()).toList(),
      'savedAt': savedAt.toIso8601String(),
    };
  }
}

class InvoiceDraftLocalDataSource {
  static const String _draftKey = 'unfinished_sales_invoice_draft';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<void> save({
    required ClientModel client,
    required List<ProductItem> items,
  }) async {
    final prefs = await _prefs;
    final draft = InvoiceDraft(
      client: client,
      items: List<ProductItem>.from(items),
      savedAt: DateTime.now(),
    );
    await prefs.setString(_draftKey, jsonEncode(draft.toJson()));
  }

  Future<InvoiceDraft?> load() async {
    final prefs = await _prefs;
    final encoded = prefs.getString(_draftKey);
    if (encoded == null || encoded.isEmpty) {
      return null;
    }

    try {
      return InvoiceDraft.fromJson(
        Map<String, dynamic>.from(jsonDecode(encoded) as Map),
      );
    } catch (_) {
      await clear();
      return null;
    }
  }

  Future<void> clear() async {
    final prefs = await _prefs;
    await prefs.remove(_draftKey);
  }
}
