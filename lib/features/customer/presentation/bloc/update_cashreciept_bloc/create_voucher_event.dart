import 'package:Yadhava/features/customer/model/cash_receipt_model.dart';
import 'package:equatable/equatable.dart';

abstract class VoucherUpdateEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateVoucherEvent extends VoucherUpdateEvent {
  final CashReceiptModel voucherData;

  UpdateVoucherEvent(this.voucherData);

  @override
  List<Object> get props => [voucherData];
}
