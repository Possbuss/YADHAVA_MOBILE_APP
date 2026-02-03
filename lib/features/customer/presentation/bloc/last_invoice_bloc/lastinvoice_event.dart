part of 'lastinvoice_bloc.dart';

class LastInvoiceEvent extends Equatable {
  const LastInvoiceEvent();

  @override
  List<Object> get props => [];
}

class FetchLastInvoice extends LastInvoiceEvent {
  final int partyId;

  const FetchLastInvoice(this.partyId);

  @override
  List<Object> get props => [partyId];
}


class SyncLastInvoices extends LastInvoiceEvent {
  final int partyId;

  const SyncLastInvoices(this.partyId);

  @override
  List<Object> get props => [partyId];
}