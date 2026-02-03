part of 'stock_list_bloc.dart';

sealed class StockListEvent extends Equatable {
  const StockListEvent();

  @override
  List<Object> get props => [];
}
 class StockListGetEvent extends StockListEvent {
  const   StockListGetEvent();
}
