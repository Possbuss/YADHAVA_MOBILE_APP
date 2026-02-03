part of 'invoice_bloc.dart';

sealed class InvoiceState extends Equatable {
  const InvoiceState();
}

// Initial state
final class InvoiceInitial extends InvoiceState {
  @override
  List<Object> get props => [];
}

// Loading state
class InvoiceLoading extends InvoiceState {
  @override
  List<Object> get props => [];
}

// Loaded state with invoices
class InvoiceLoaded extends InvoiceState {
  final List<MobileAppSalesInvoiceMaster> invoices;
  final String timestamp; // Unique identifier

  const InvoiceLoaded(this.invoices, this.timestamp);

  @override
  List<Object> get props => [invoices, timestamp]; // Include timestamp
}

// Error state
class InvoiceError extends InvoiceState {
  final String message;

  const InvoiceError(this.message);

  @override
  List<Object> get props => [message];
}

// INVOICE SYNCING
class InvoiceSyncing extends InvoiceState {
  @override
  List<Object> get props => [];
}

class InvoiceSynced extends InvoiceState {
  @override
  List<Object> get props => [];
}

class InvoiceSyncingError extends InvoiceState {
  final String erroMessage;

  const InvoiceSyncingError(this.erroMessage);

  @override
  List<Object> get props => [erroMessage];
}
