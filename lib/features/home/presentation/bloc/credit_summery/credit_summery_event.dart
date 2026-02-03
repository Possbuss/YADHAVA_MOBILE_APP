part of 'credit_summery_bloc.dart';

sealed class CreditSummeryListEvent extends Equatable {
  const CreditSummeryListEvent();

  @override
  List<Object> get props => [];
}

class CreditSummeryListGetEvent extends CreditSummeryListEvent {
  final String date;
  const CreditSummeryListGetEvent(this.date);
  @override
  List<Object> get props => [date];
}
