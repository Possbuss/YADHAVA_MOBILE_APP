part of 'sales_summery_bloc.dart';

@immutable
sealed class SalesSummeryEvent extends Equatable{
   StockListEvent();

  @override
  List<Object> get props => [];
}
class SalesListGetEvent extends SalesSummeryEvent {
  final String date;

  SalesListGetEvent(this.date);

  @override
  List<Object> get props => [date];

  @override
  StockListEvent() {
    // TODO: implement StockListEvent
    throw UnimplementedError();
  }


}