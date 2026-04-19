import 'package:Yadhava/features/home/domain/cashcreditsummeryRepo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/cash_summery.dart';
part 'cash_summery_event.dart';
part 'cash_summery_state.dart';

class CashSummeryBloc extends Bloc<CashSummeryListEvent, CashSummeryState> {
  final CashCreditSummaryRepository cashCreditSummaryRepository;
  List<CashSummery> _cashSummery = [];

  CashSummeryBloc(this.cashCreditSummaryRepository)
      : super(CashSummeryInitial()) {
    on<CashSummeryListGetEvent>(_onGetCashSummery);
  }
  Future<void> _onGetCashSummery(
    CashSummeryListGetEvent event,
    Emitter<CashSummeryState> emit,
  ) async {
    emit(CashSummeryError());
    try {
      final response =
          await cashCreditSummaryRepository.fetchCashSummary(date: event.date);
      if (response!.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List<dynamic>;
        final cashSummery = data.map((e) => CashSummery.fromJson(e)).toList();
        _cashSummery = cashSummery;
        emit(CashSummeryLoaded(cashSummeryList: _cashSummery));
      }
    } catch (ex) {
      Exception(ex);
    }
  }
}
