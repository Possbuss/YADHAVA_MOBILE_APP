part of 'cash_receipt_bloc.dart';

abstract class CashReceiptEvent extends Equatable {
  const CashReceiptEvent();

}
class CashReceiptGetEvent extends CashReceiptEvent{
  final Map<String,dynamic>cashReceipt;
  final int partyId;

  const CashReceiptGetEvent(this.cashReceipt,this.partyId);
  @override
  List<Object?>get props=>[cashReceipt];
}