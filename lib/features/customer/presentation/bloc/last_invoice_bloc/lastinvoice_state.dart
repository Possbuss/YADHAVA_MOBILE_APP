part of 'lastinvoice_bloc.dart';

abstract class LastInvoiceState extends Equatable {
  const LastInvoiceState();

  @override
  List<Object> get props => [];
}

class LastInvoiceInitial extends LastInvoiceState {}

class LastInvoiceLoading extends LastInvoiceState {}

class LastInvoiceLoaded extends LastInvoiceState {
  final List<ProductItem> invoice;

  const LastInvoiceLoaded(this.invoice);

  @override
  List<Object> get props => [invoice];
}

class LastInvoiceError extends LastInvoiceState {
  final String message;

  const LastInvoiceError(this.message);

  @override
  List<Object> get props => [message];
}


class LastInvoiceSyncing extends LastInvoiceState {}
class LastInvoiceSynced extends LastInvoiceState {}
class LastInvoiceSyncError extends LastInvoiceState {
  final String error ;
  const LastInvoiceSyncError(this.error);
  @override
  List<Object> get props => [error];
}
