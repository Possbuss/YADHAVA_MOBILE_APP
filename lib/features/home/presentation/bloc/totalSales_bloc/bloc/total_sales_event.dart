part of 'total_sales_bloc.dart';

sealed class TotalSalesEvent extends Equatable {
  const TotalSalesEvent();

  @override
  List<Object> get props => [];
}
class TotalSalesGetEvent extends TotalSalesEvent {
  const   TotalSalesGetEvent();
}