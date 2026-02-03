part of 'cash_credit_summery_bloc.dart';

sealed class CashCreditSummeryListEvent extends Equatable {
  const CashCreditSummeryListEvent();

  @override
  List<Object> get props => [];
}

class CashCreditSummeryListGetEvent extends CashCreditSummeryListEvent {
  final String date;
  const CashCreditSummeryListGetEvent(this.date);
}
