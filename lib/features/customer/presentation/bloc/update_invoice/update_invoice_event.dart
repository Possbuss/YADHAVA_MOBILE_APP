// part of 'update_invoice_bloc.dart';
//
// abstract class UpdateInvoiceEvent extends Equatable {
//   const UpdateInvoiceEvent();
//   @override
//   List<Object> get props => [];
// }
// final class SubmitAddItem extends UpdateInvoiceEvent {
//   final ProductItem item;
//   const SubmitAddItem({
//     required this.item,
//   });
//
//   @override
//   List<Object> get props => [item];
// }
import 'package:Yadhava/features/customer/model/mobile_app_sales_Invoice_all.dart';
import 'package:equatable/equatable.dart';

import '../../../model/InvoiceModel.dart';

abstract class UpdateInvoiceEvent extends Equatable {
  const UpdateInvoiceEvent();

  @override
  List<Object?> get props => [];
}

class SubmitUpdateInvoice extends UpdateInvoiceEvent {
  final MobileAppSalesInvoiceMaster updatedInvoice;

  const SubmitUpdateInvoice({required this.updatedInvoice});

  @override
  List<Object?> get props => [updatedInvoice];
}
