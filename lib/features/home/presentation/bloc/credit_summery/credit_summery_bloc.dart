import 'package:Yadhava/features/home/domain/cashcreditsummeryRepo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/credit_summery.dart';

part 'credit_summery_event.dart';
part 'credit_summery_state.dart';

class CreditummeryBloc
    extends Bloc<CreditSummeryListEvent, CreditSummeryState> {
  final CashCreditSummaryRepository cashCreditSummaryRepository;
  List<CreditSummery> _creditSummery = [];

  CreditummeryBloc(this.cashCreditSummaryRepository)
      : super(CreditSummeryInitial()) {
    on<CreditSummeryListGetEvent>(_onGetCreditSummery);
  }

  Future<void> _onGetCreditSummery(
    CreditSummeryListGetEvent event,
    Emitter<CreditSummeryState> emit,
  ) async {
    emit(CreditSummeryLoading());
    try {
      final response = await cashCreditSummaryRepository.fetchCreditSummary(
        date: event.date,
      );

      if (response!.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List<dynamic>;
        final creditSummery =
            data.map((e) => CreditSummery.fromJson(e)).toList();
        _creditSummery = creditSummery;
        emit(CreditSummeryLoaded(creditSummeryList: _creditSummery));
      } else {
        emit(CreditSummeryError(message: 'Invalid response from server'));
      }
    } catch (ex) {
      emit(CreditSummeryError(message: ex.toString()));
    }
  }
}
