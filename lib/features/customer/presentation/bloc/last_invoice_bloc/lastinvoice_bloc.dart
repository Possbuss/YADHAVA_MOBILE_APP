import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/last_invoice_repo.dart';
import '../../pages/customer_details/model/addItem_model.dart';

part 'lastinvoice_event.dart';
part 'lastinvoice_state.dart';

class LastInvoiceBloc extends Bloc<LastInvoiceEvent, LastInvoiceState> {
  final LastInvoiceRepository repo;

  LastInvoiceBloc(this.repo) : super(LastInvoiceInitial()) {
    on<FetchLastInvoice>(_onFetchLastInvoice);

    on<SyncLastInvoices>(_onSyncLastInvoice);

  }

  Future<void> _onSyncLastInvoice(
      SyncLastInvoices event, Emitter<LastInvoiceState> emit) async {
    try {

      emit(LastInvoiceSyncing());
      await repo.syncLastInvoiceAll(event.partyId);
      emit(LastInvoiceSynced());
      return;

    } catch (e) {
      emit(LastInvoiceSyncError("Failed to Sync Last Invoice: ${e.toString()}"));
    }
  }

  Future<void> _onFetchLastInvoice(
      FetchLastInvoice event, Emitter<LastInvoiceState> emit) async {
    emit(LastInvoiceLoading());
    try {
      final invoiceDet = await repo.fetchLastInvoice(event.partyId);
      final data = invoiceDet ?? [];
      List<ProductItem> details = [];
      for (var item in data) {
        ProductItem selectedItem = ProductItem(
          fac: 0,
          srt: 0,
          productName: item.productName ?? '',
          quantity: 0,
          sell: item.unitRate?.toString() ?? '0',
          totalRate: 0.0,
          uom: item.packingName ?? '0',
          packingDescription: item.packingDescription ?? '',
          packingId: item.packingId ?? 0,
          packingName: item.packingName ?? '',
          partNumber: item.partNumber?.toString() ?? "0",
          productId: item.productId,
        );

        details.add(selectedItem);
      }

      emit(LastInvoiceLoaded(details));
    } catch (e) {
      emit(LastInvoiceError("Failed to load invoice: ${e.toString()}"));
    }
  }
}
