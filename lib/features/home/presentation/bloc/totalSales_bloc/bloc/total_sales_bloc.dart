import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/totalSales_model.dart';
import '../../../../domain/totalSalesRepo.dart';

part 'total_sales_event.dart';
part 'total_sales_state.dart';

class TotalSalesBloc extends Bloc<TotalSalesEvent, TotalSalesState> {
  final Totalsalesrepo totalsalesrepo;
  List<SalesTransactions> _alltransactions = [];
  TotalSalesBloc(this.totalsalesrepo) : super(TotalSalesInitial()) {
    on<TotalSalesGetEvent>(_onGetSalesListEvent);
  }

  Future<void> _onGetSalesListEvent(
    TotalSalesEvent event,
    Emitter<TotalSalesState> emit,
  ) async {
    emit(TotalSalesListLoading());
    try {
      final response = await totalsalesrepo.getTotalSalesRepo();
      if (response!.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List<dynamic>;
        final sales = data.map((e) => SalesTransactions.fromJson(e)).toList();
        _alltransactions = sales; // Cache the full client list
        emit(TotalSalesListLoaded(totalSalesList: _alltransactions));
      } else {
        emit(TotalSalesListError(
            message:
                'Failed to fetch sales data. Status code: ${response.statusCode}'));
      }
    } catch (ex) {
      emit(TotalSalesListError(message: 'An error occurred: ${ex.toString()}'));
    }
  }
}
