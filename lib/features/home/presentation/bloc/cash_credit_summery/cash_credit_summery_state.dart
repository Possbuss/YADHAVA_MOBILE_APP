part of 'cash_credit_summery_bloc.dart';

@immutable
sealed class CashCreditSummeryState extends Equatable {}

final class CashCreditSummeryInitial extends CashCreditSummeryState {
  @override
  List<Object?> get props => [];
}

final class CashCreditSummeryLoading extends CashCreditSummeryState {
  @override
  List<Object?> get props => [];
}

final class CashCreditSummeryLoaded extends CashCreditSummeryState {
  final List<CashCreditDetailsModel> cashSummeryList;
  CashCreditSummeryLoaded({required this.cashSummeryList});
  @override
  List<Object?> get props => [cashSummeryList];
}

final class CashCreditSummeryError extends CashCreditSummeryState {
  final String message;

  CashCreditSummeryError({required this.message});

  @override
  List<Object?> get props => [message];
}
