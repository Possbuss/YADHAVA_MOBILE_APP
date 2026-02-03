part of 'cash_summery_bloc.dart';

@immutable
sealed class CashSummeryState extends Equatable {}

final class CashSummeryInitial extends CashSummeryState {
  @override
  List<Object?> get props => [];
}

final class CashSummeryLoading extends CashSummeryState {
  @override
  List<Object?> get props => [];
}

final class CashSummeryLoaded extends CashSummeryState {
  final List<CashSummery> cashSummeryList;
  CashSummeryLoaded({required this.cashSummeryList});
  @override
  List<Object?> get props => [cashSummeryList];
}

final class CashSummeryError extends CashSummeryState {
  @override
  List<Object?> get props => throw UnimplementedError();
}
