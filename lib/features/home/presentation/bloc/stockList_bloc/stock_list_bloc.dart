import 'package:Yadhava/features/home/data/stockStsModel.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/productStockRepo.dart';

part 'stock_list_event.dart';
part 'stock_list_state.dart';

class StockListBloc extends Bloc<StockListEvent, StockListState> {
  final ProductStockRepo productStockrepo;
  List<ProductStock> _allstocks = [];
  StockListBloc(this.productStockrepo) : super(StockListInitial()) {
    on<StockListGetEvent>(_onGetStockListEvent);
  }
  Future<void> _onGetStockListEvent(
    StockListEvent event,
    Emitter<StockListState> emit,
  ) async {
    emit(StockListLoading());
    try {
      final response = await productStockrepo.getStockListRepo();
      if (response!.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List<dynamic>;
        final stocks = data.map((e) => ProductStock.fromJson(e)).toList();
        _allstocks = stocks;
        emit(StockListLoaded(stockList: _allstocks));
      } else {
        emit(StockListError(
            message:
                'Failed to fetch Stock data. Status code: ${response.statusCode}'));
      }
    } catch (ex) {
      emit(StockListError(message: 'An error occurred: ${ex.toString()}'));
    }
  }
}
