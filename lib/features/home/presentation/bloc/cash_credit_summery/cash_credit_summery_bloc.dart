import 'package:Yadhava/features/home/data/cash_credit_details.dart';
import 'package:Yadhava/features/home/domain/cashcreditsummeryRepo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
part 'cash_credit_summery_event.dart';
part 'cash_credit_summery_state.dart';

class CashCreditSummeryBloc
    extends Bloc<CashCreditSummeryListEvent, CashCreditSummeryState> {
  final CashCreditSummaryRepository cashCreditSummaryRepository;
  List<CashCreditDetailsModel> _cashSummery = [];

  CashCreditSummeryBloc(this.cashCreditSummaryRepository)
      : super(CashCreditSummeryInitial()) {
    on<CashCreditSummeryListGetEvent>(_onGetCashSummery);
  }
  Future<void> _onGetCashSummery(
    CashCreditSummeryListGetEvent event,
    Emitter<CashCreditSummeryState> emit,
  ) async {
    emit(CashCreditSummeryLoading());
    try {
      debugPrint('Fetching Cash Credit Summary...');
      final response = await cashCreditSummaryRepository.fetchCashCreditSummary(
          date: event.date);
      if (response!.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List<dynamic>;
        final cashSummery =
            data.map((e) => CashCreditDetailsModel.fromJson(e)).toList();
        _cashSummery = cashSummery;
        emit(CashCreditSummeryLoaded(cashSummeryList: _cashSummery));
      }
    } catch (ex) {
      debugPrint('CashCreditSummeryBloc error: $ex');
      emit(CashCreditSummeryError(message: ex.toString()));
    }
  }
}
