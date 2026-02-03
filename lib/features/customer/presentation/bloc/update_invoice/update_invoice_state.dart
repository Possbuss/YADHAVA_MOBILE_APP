
import 'package:equatable/equatable.dart';

abstract class UpdateInvoiceState extends Equatable {
  const UpdateInvoiceState();

  @override
  List<Object?> get props => [];
}

class UpdateInvoiceInitial extends UpdateInvoiceState {}

class UpdateInvoiceLoading extends UpdateInvoiceState {}

class UpdateInvoiceSuccess extends UpdateInvoiceState {
  final String message;

  const UpdateInvoiceSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class UpdateInvoiceFailure extends UpdateInvoiceState {
  final String error;

  const UpdateInvoiceFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
