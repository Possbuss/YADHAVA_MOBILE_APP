import 'package:Yadhava/features/customer/model/cash_receipt_model.dart';
import 'package:equatable/equatable.dart';

abstract class VoucherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateVoucherEvent extends VoucherEvent {
  final CashReceiptModel voucherData;

  CreateVoucherEvent(this.voucherData);

  @override
  List<Object> get props => [voucherData];
}
