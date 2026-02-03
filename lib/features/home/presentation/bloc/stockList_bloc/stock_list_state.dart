part of 'stock_list_bloc.dart';

sealed class StockListState extends Equatable {
  const StockListState();

  @override
  List<Object> get props => [];
}

final class StockListInitial extends StockListState {
  @override
  List<Object> get props => [];
}

final class StockListLoading extends StockListState {
  @override
  List<Object> get props => [];
}

final class StockListLoaded extends StockListState {
  final List<ProductStock> stockList;
  const StockListLoaded({required this.stockList});
  @override
  List<Object> get props => [stockList];
}

final class StockListError extends StockListState {
  final String message;
  const StockListError({required this.message});
  @override
  List<Object> get props => [message];
}
