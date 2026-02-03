part of 'cash_summery_bloc.dart';

sealed class CashSummeryListEvent extends Equatable {
  const CashSummeryListEvent();

  @override
  List<Object> get props => [];
}

class CashSummeryListGetEvent extends CashSummeryListEvent {
  final String date;
  const CashSummeryListGetEvent(this.date);
}
