part of 'total_sales_bloc.dart';

sealed class TotalSalesState extends Equatable {
  const TotalSalesState();
  
  @override
  List<Object> get props => [];
}

final class TotalSalesInitial extends TotalSalesState {
   @override
  List<Object> get props => [];
}
final class TotalSalesListLoading extends TotalSalesState {
  @override
  List<Object> get props => [];
}
final class TotalSalesListLoaded extends TotalSalesState {
  final List<SalesTransactions> totalSalesList;
  const TotalSalesListLoaded({required this.totalSalesList});
  @override
  List<Object> get props => [totalSalesList];
}
final class TotalSalesListError extends TotalSalesState {
  final String message;
  const TotalSalesListError({required this.message});
  @override
  List<Object> get props => [message];

  
}

