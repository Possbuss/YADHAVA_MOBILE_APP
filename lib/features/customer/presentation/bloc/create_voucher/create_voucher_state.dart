import 'package:equatable/equatable.dart';

abstract class VoucherState extends Equatable {
  @override
  List<Object> get props => [];
}

class VoucherInitial extends VoucherState {}

class VoucherLoading extends VoucherState {}

class VoucherSuccess extends VoucherState {
  final String voucherId;

  VoucherSuccess(this.voucherId);

  @override
  List<Object> get props => [voucherId];
}

class VoucherFailure extends VoucherState {
  final String error;

  VoucherFailure(this.error);

  @override
  List<Object> get props => [error];
}
