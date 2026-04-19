import 'package:Yadhava/features/customer/model/mobile_app_sales_Invoice_all.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/invoice_repo.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRepo invoiceRepo;

  InvoiceBloc(this.invoiceRepo) : super(InvoiceInitial()) {
    on<FetchInvoiceEvent>(_onFetchInvoiceEvent);
    on<FetchInvoiceAllEvent>(_onSyncInvoiceAllEvent);
    on<DeleteInvoiceEvent>(_onDeleteInvoiceEvent);
  }

  Future<void> _onSyncInvoiceAllEvent(
      FetchInvoiceAllEvent event, Emitter<InvoiceState> emit) async {
    try {
      emit(InvoiceSyncing());
      await invoiceRepo.syncInvoiceDataAll(
          routeId: event.routeId, companyId: event.companyId);
      emit(InvoiceSynced());
      return;
    } catch (e) {
      emit(InvoiceSyncingError('Failed to fetch invoices: ${e.toString()}'));
    }
  }

  Future<void> _onFetchInvoiceEvent(
      FetchInvoiceEvent event, Emitter<InvoiceState> emit) async {
    emit(InvoiceLoading());
    try {
      final localInvoice = await invoiceRepo.getInvoices(
          routeId: event.routeId,
          clientId: event.clientId,
          companyId: event.companyId,
          salesmanId: event.salesmanId,
          vehicleId: event.vehicleId);
      emit(InvoiceLoaded(localInvoice, DateTime.now().toString()));
      return;
    } catch (e) {
      emit(InvoiceError('Failed to fetch invoices: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteInvoiceEvent(
      DeleteInvoiceEvent event, Emitter<InvoiceState> emit) async {
    try {
      emit(InvoiceLoading());
      await invoiceRepo.deleteInvoice(event.invoiceNo, event.companyId);
    } catch (e) {
      emit(InvoiceError('Failed to delete invoice: $e'));
    }
  }
}
