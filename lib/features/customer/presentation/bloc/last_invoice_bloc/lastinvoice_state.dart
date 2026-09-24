part of 'lastinvoice_bloc.dart';

abstract class LastInvoiceState extends Equatable {
  const LastInvoiceState();

  @override
  List<Object> get props => [];
}

class LastInvoiceInitial extends LastInvoiceState {}

class LastInvoiceLoading extends LastInvoiceState {
  final int partyId;

  const LastInvoiceLoading(this.partyId);

  @override
  List<Object> get props => [partyId];
}

class LastInvoiceLoaded extends LastInvoiceState {
  final int partyId;
  final List<ProductItem> invoice;

  const LastInvoiceLoaded(this.partyId, this.invoice);

  @override
  List<Object> get props => [partyId, invoice];
}

class LastInvoiceError extends LastInvoiceState {
  final int partyId;
  final String message;

  const LastInvoiceError(this.partyId, this.message);

  @override
  List<Object> get props => [partyId, message];
}

class LastInvoiceSyncing extends LastInvoiceState {}

class LastInvoiceSynced extends LastInvoiceState {}

class LastInvoiceSyncError extends LastInvoiceState {
  final String error;
  const LastInvoiceSyncError(this.error);
  @override
  List<Object> get props => [error];
}
