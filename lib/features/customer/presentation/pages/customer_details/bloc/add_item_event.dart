part of 'add_item_bloc.dart';

sealed class AddItemEvent extends Equatable {
  const AddItemEvent();

  @override
  List<Object> get props => [];
}

final class FetchProductMaster extends AddItemEvent {}

final class FetchItems extends AddItemEvent {}


final class SubmitAddItem extends AddItemEvent {
  final ProductMaster item;
  const SubmitAddItem({
    required this.item,
  });

  @override
  List<Object> get props => [item];
}


class RemoveItem extends AddItemEvent {
  final ProductMaster items;

  const RemoveItem(this.items);

  @override
  List<Object> get props => [items];
}

final class PostAddedItems extends AddItemEvent {
  final OrderModel order;
  // final ClientListBloc clientListBloc;
  // final HomeBloc homeBloc;
  const PostAddedItems(this.order);

  @override
  List<Object> get props => [order];
}

class FetchSalesInvoice extends AddItemEvent {
  final String invoiceNo;
  const FetchSalesInvoice(this.invoiceNo);
  @override
  List<Object> get props => [invoiceNo];
}

class GeneratePdfEvent extends AddItemEvent {
  final List<SalesInvoiceDetail> details;
  final String name;
  final dynamic date;
  final String invoiceNo;
  const GeneratePdfEvent({
    required this.details,
    required this.name,
    required this.date,
    required this.invoiceNo,
  });

  @override
  List<Object> get props => [details];
}

class UpdateItem extends AddItemEvent {
  final ProductMaster item;
  final int index;

  const UpdateItem({required this.item, required this.index});

  @override
  List<Object> get props => [item, index];
}

class RemoveAllItem extends AddItemEvent {}

class SyncInvoices extends AddItemEvent {}