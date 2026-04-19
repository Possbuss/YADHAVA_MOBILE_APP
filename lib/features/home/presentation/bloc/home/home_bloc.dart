import 'package:Yadhava/features/home/data/home_data.dart';
import 'package:Yadhava/features/home/domain/homerepo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/util/local_db_helper.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  late MobileAppSalesDashBoardHome _mobileAppSalesDashBoardHome;

  HomeBloc(this.homeRepository) : super(HomeStateInitial()) {
    on<HomeGetEvent>(_onGetHomeData);
  }

  Future<void> _onGetHomeData(
    HomeGetEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeStateLoading());
    try {
      final db = LocalDbHelper();
      bool isLocalEmpty = await db.isEmptySalesTransactions();

      if (!isLocalEmpty && event.forceRefresh == false) {
        final tranCreditDetails = await db.getCashCreditDetails();
        final tranCashSummary = await db.getCashSummary();
        final tranCreditSummary = await db.getCreditSummary();
        final tranProductStocks = await db.getProductStocks();
        final tranSalesSummary = await db.getSalesSummary();
        final tranTransactions = await db.getTransactions();

        var dashBoardDt = MobileAppSalesDashBoardHome(
            mobileAppStockBalanceVans: tranProductStocks,
            mobileAppSales: tranSalesSummary,
            mobileAppSalesCash: tranCashSummary,
            mobileAppSalesCredit: tranCreditSummary,
            mobileAppSalesDashBoard: tranTransactions,
            salesInvoiceCollectionCreditCashCustomerImports: tranCreditDetails);

        _mobileAppSalesDashBoardHome = dashBoardDt;
        emit(HomeStateLoaded(homeData: _mobileAppSalesDashBoardHome));
        return;
      } else {
        final response = await homeRepository.fetchMobileAppSalesDashBoardHome(
          date: event.date,
        );

        if (response!.statusCode == 200 || response.statusCode == 201) {
          _mobileAppSalesDashBoardHome =
              MobileAppSalesDashBoardHome.fromJson(response.data);

          await db.clearCashCreditDetails();
          await db.clearCashSummary();
          await db.clearProductStocks();
          await db.clearCreditSummary();
          await db.clearSalesSummary();
          await db.clearTransactions();

          await db.insertCashCreditDetails(_mobileAppSalesDashBoardHome
              .salesInvoiceCollectionCreditCashCustomerImports!);
          await db.insertCashSummary(
              _mobileAppSalesDashBoardHome.mobileAppSalesCash!);
          await db.insertCreditSummary(
              _mobileAppSalesDashBoardHome.mobileAppSalesCredit!);
          await db
              .insertSalesSummary(_mobileAppSalesDashBoardHome.mobileAppSales!);
          await db.insertProductStocks(
              _mobileAppSalesDashBoardHome.mobileAppStockBalanceVans!);
          await db.insertTransactions(
              _mobileAppSalesDashBoardHome.mobileAppSalesDashBoard!);

          emit(HomeStateLoaded(homeData: _mobileAppSalesDashBoardHome));
          return;
        } else {
          emit(HomeStateError(message: 'Invalid response from server'));
        }
      }
    } catch (ex) {
      emit(HomeStateError(message: ex.toString()));
    }
  }
}
