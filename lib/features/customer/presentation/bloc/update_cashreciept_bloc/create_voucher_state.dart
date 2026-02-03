import 'package:equatable/equatable.dart';

abstract class VoucherUpdateState extends Equatable {
  @override
  List<Object> get props => [];
}

class VoucherUpdateInitial extends VoucherUpdateState {}

class VoucherUpdateLoading extends VoucherUpdateState {}

class VoucherUpdateSuccess extends VoucherUpdateState {
  final String voucherId;

  VoucherUpdateSuccess(this.voucherId);

  @override
  List<Object> get props => [voucherId];
}

class UpdateVoucherFailure extends VoucherUpdateState {
  final String error;

  UpdateVoucherFailure(this.error);

  @override
  List<Object> get props => [error];
}



