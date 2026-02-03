import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/sales_summery.dart';
import '../../../domain/salessummeryrepo.dart';

part 'sales_summery_event.dart';
part 'sales_summery_state.dart';

class SalesSummeryBloc extends Bloc<SalesSummeryEvent, SalesSummeryState> {
  final SalesSummaryRepository salesSummaryRepository;
  List<SalesSummery> _allstocks = [];

  SalesSummeryBloc(this.salesSummaryRepository) : super(SalesSummeryInitial()) {
    on<SalesListGetEvent>(_onGetSalesSummery);
  }
  Future<void> _onGetSalesSummery(
    SalesListGetEvent event,
    Emitter<SalesSummeryState> emit,
  ) async {
    emit(SalesSummeryError());
    try {
      final response =
          await salesSummaryRepository.fetchSalesSummary(date: event.date);
      if (response!.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List<dynamic>;
        final stocks = data.map((e) => SalesSummery.fromJson(e)).toList();
        _allstocks = stocks;
        emit(SalesSummeryLoaded(salesList: _allstocks));
      }
    } catch (ex) {
      Exception(ex);
    }
  }
}
