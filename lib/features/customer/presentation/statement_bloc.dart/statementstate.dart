// // customer_statement_state.dart
// import 'package:equatable/equatable.dart';
// import 'package:posbuss_milk/features/customer/model/statementModel.dart';

// abstract class CustomerStatementState extends Equatable {
//   @override
//   List<Object> get props => [];
// }

// class CustomerStatementInitial extends CustomerStatementState {}

// class CustomerStatementLoading extends CustomerStatementState {}

// class CustomerStatementLoaded extends CustomerStatementState {
//   final List<Voucher> vouchers;
//   CustomerStatementLoaded({required this.vouchers});
  
//   @override
//   List<Object> get props => [vouchers];
// }

// class CustomerStatementError extends CustomerStatementState {
//   final String error;
//   CustomerStatementError({required this.error});
  
//   @override
//   List<Object> get props => [error];
// }

// class PdfGeneratedState extends CustomerStatementState {
//   final String filePath;
//   PdfGeneratedState({required this.filePath});
  
//   @override
//   List<Object> get props => [filePath];
// }
