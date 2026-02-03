import 'dart:async';

import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/cash_receipt_repo.dart';
import '../../../model/cash_receipt_model.dart';

part 'cash_receipt_event.dart';
part 'cash_receipt_state.dart';

class CashReceiptBloc extends Bloc<CashReceiptEvent, CashReceiptState> {
  final CashReceiptRepo cashReceiptRepo;
  final bool forceRefresh;
  CashReceiptBloc(this.cashReceiptRepo, {this.forceRefresh = false})
      : super(CashReceiptInitial()) {
    on<CashReceiptGetEvent>(_onCashReceiptGet);
  }

  Future<void> _onCashReceiptGet(
      CashReceiptGetEvent event, Emitter<CashReceiptState> emit) async {
    emit(CashReceiptLoading());

    try {
      final db = LocalDbHelper();
      bool isLocalEmpty = await db.isEmptyReceipts(event.partyId);
      print(isLocalEmpty);
      if (!isLocalEmpty && event.cashReceipt['forceRefresh'] == false) {
        print('data from local db cash receipts');
        // Load from local DB
        print('Party');

        final localReceipts =
            await db.getCashReceipts(event.partyId);

        emit(CashReceiptLoaded(localReceipts));
        return;
      } else {
        final Response? response =
            await cashReceiptRepo.getCasReceipt(event.cashReceipt);

        if (response != null && response.statusCode == 200) {
          List<dynamic> responseData = response.data;
          List<CashReceiptModel> cashReceipts = responseData
              .map((json) => CashReceiptModel.fromJson(json))
              .toList();

          await db.insertReceipts(cashReceipts);

          emit(CashReceiptLoaded(cashReceipts));
        } else {
          emit(CashReceiptError("Failed to load data"));
        }
      }
    } catch (e) {
      emit(CashReceiptError("Something Went Wrong"));
    }
  }
}
