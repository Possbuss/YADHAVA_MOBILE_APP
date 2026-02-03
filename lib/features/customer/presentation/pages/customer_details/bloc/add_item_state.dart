part of 'add_item_bloc.dart';

sealed class AddItemState extends Equatable {
  const AddItemState();

  @override
  List<Object> get props => [];
}


class SyncingSalesInvoices extends AddItemState {}
class SalesInvoicesSynced extends AddItemState {}
 class SalesInvoicesSyncError extends AddItemState {
  final String error ;
  const SalesInvoicesSyncError(this.error);
  @override
  List<Object> get props => [error];
}

final class AddItemInitial extends AddItemState {}

class SalesInvoiceLoading extends AddItemState {}


class SalesInvoiceSaving extends AddItemState {}

final class ItemsFetchedState extends AddItemState {
  //final List<Map<String, dynamic>> items;
  final List<ProductMaster> items;

  const ItemsFetchedState(this.items);

  @override
  List<Object> get props => [items];
}

final class ItemsAddedState extends AddItemState {
  final List<ProductMaster> addedItems;

  const ItemsAddedState(this.addedItems);

  @override
  List<Object> get props => [addedItems];
}

class SalesInvoiceLoaded extends AddItemState {
  final List<SalesInvoiceDetail> details;

  const SalesInvoiceLoaded(this.details);

  @override
  List<Object> get props => [details];
}

final class ItemsFetchErrorState extends AddItemState {
  final String error;

  const ItemsFetchErrorState(this.error);

  @override
  List<Object> get props => [error];
}

final class ItemAddedState extends AddItemState {
  final String message;
  final bool isAlreadyExists;
  const ItemAddedState(this.message,this.isAlreadyExists);

  @override
  List<Object> get props => [message];
}

final class ItemPostedState extends AddItemState {
  final String message;

  const ItemPostedState(this.message);

  @override
  List<Object> get props => [message];
}
final class ItemPostedSuccess extends AddItemState {
  final String inoviceId;

  const ItemPostedSuccess(this.inoviceId);

  @override
  List<Object> get props => [inoviceId];
}

class PdfGenerated extends AddItemState {
  final String filePath;

  const PdfGenerated(this.filePath);

  @override
  List<Object> get props => [filePath];
}
