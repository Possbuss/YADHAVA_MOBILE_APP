import 'dart:async';

import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:Yadhava/features/customer/presentation/bloc/inovice_bloc/invoice_bloc.dart';
import 'package:bloc/bloc.dart';

import '../../../domain/inventory_update_repo.dart';
import 'update_invoice_event.dart';
import 'update_invoice_state.dart';

class UpdateInvoiceBloc extends Bloc<UpdateInvoiceEvent, UpdateInvoiceState> {
  final InvoiceRepository invoiceRepository;

  UpdateInvoiceBloc({required this.invoiceRepository})
      : super(UpdateInvoiceInitial()) {
    on<SubmitUpdateInvoice>(_onSubmitUpdateInvoice);
  }

  Future<void> _onSubmitUpdateInvoice(
      SubmitUpdateInvoice event, Emitter<UpdateInvoiceState> emit) async {
    try {
      emit(UpdateInvoiceLoading());

      if(event.updatedInvoice.payType == "CREDIT"){
        event.updatedInvoice.paidAmount = 0;
      }

      bool? response =
          await invoiceRepository.updateInvoice(event.updatedInvoice);

      if (response == true) {

        emit(const UpdateInvoiceSuccess(
            message: 'Invoice updated successfully!'));
      } else {
        emit(const UpdateInvoiceFailure(error: 'Failed to update invoice.'));
      }
    } catch (error) {
      emit(UpdateInvoiceFailure(error: error.toString()));
    }
  }
}
