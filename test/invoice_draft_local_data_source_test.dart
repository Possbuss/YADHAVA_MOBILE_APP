import 'package:Yadhava/features/customer/data/client_model.dart';
import 'package:Yadhava/features/customer/data/local/invoice_draft_local_data_source.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/addItem_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('saves, restores, and clears an unfinished invoice', () async {
    final store = InvoiceDraftLocalDataSource();
    final client = ClientModel(
      companyId: 1,
      id: 42,
      name: 'Test Client',
      isActive: 'Y',
    );
    final items = [
      ProductItem(
        srt: 0,
        productName: 'Test Product',
        fac: 0,
        quantity: 2,
        uom: 'Box',
        sell: '25.50',
        totalRate: 51,
        productId: 7,
        partNumber: 'P-7',
        packingDescription: 'Two units',
        packingName: 'Box',
        packingId: 3,
      ),
    ];

    await store.save(client: client, items: items);

    final restored = await store.load();
    expect(restored, isNotNull);
    expect(restored!.client.id, 42);
    expect(restored.client.name, 'Test Client');
    expect(restored.items, hasLength(1));
    expect(restored.items.single.productId, 7);
    expect(restored.items.single.quantity, 2);
    expect(restored.items.single.totalRate, 51);

    await store.clear();
    expect(await store.load(), isNull);
  });
}
