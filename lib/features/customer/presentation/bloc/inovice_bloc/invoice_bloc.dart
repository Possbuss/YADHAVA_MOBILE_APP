import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:Yadhava/features/auth/data/login_model.dart';
import 'package:Yadhava/features/auth/domain/login_repo.dart';
import 'package:Yadhava/features/customer/model/mobile_app_sales_Invoice_all.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/invoice_repo.dart';
import '../../../model/InvoiceModel.dart';

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
      final invoiceRep = InvoiceRepo();
      await invoiceRep.syncInvoiceDataAll(
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
      final invoiceRep = InvoiceRepo();
      final localInvoice = await invoiceRep.getInvoices(
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

      final db = LocalDbHelper();
      await invoiceRepo.deleteInvoice(event.invoiceNo, event.companyId);
    } catch (e) {
      emit(InvoiceError('Failed to delete invoice: $e'));
    }
  }
}
