part of 'invoice_bloc.dart';

sealed class InvoiceEvent extends Equatable {
  const InvoiceEvent();
}

class FetchInvoiceAllEvent extends InvoiceEvent {
  final int routeId;
  final int companyId;
  const FetchInvoiceAllEvent({required this.routeId, required this.companyId});
  @override
  List<Object> get props => [routeId, companyId];
}

class FetchInvoiceEvent extends InvoiceEvent {
  final int salesmanId;
  final int routeId;
  final int vehicleId;
  final int companyId;
  final int clientId;
  const FetchInvoiceEvent(
      {required this.salesmanId,
      required this.routeId,
      required this.vehicleId,
      required this.companyId,
      required this.clientId});
  @override
  List<Object> get props =>
      [salesmanId, routeId, vehicleId, companyId, clientId];
}

class DeleteInvoiceEvent extends InvoiceEvent {
  final int invoiceId;
  final String invoiceNo;
  final String fromDate;
  final String endDate;
  final int partyId;
  final int vehicleId;
  final int companyId;

  const DeleteInvoiceEvent(this.invoiceId, this.invoiceNo, this.fromDate,
      this.endDate, this.partyId, this.vehicleId, this.companyId);

  @override
  List<Object> get props =>
      [invoiceId, invoiceNo, fromDate, endDate, partyId, vehicleId, companyId];
}
