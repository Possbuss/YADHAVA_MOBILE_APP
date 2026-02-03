part of 'cash_receipt_bloc.dart';

abstract class CashReceiptState extends Equatable {
  const CashReceiptState();
}

class CashReceiptInitial extends CashReceiptState {
  @override
  List<Object> get props => [];
}

class CashReceiptLoading extends CashReceiptState {
  @override
  List<Object> get props => [];
}

class CashReceiptLoaded extends CashReceiptState {
  final dynamic response;
  const CashReceiptLoaded(this.response);
  @override
  List<Object> get props => [response];
}

class CashReceiptError extends CashReceiptState {
  final String message;
  const CashReceiptError(this.message);
  @override
  List<Object> get props => [message];
}
