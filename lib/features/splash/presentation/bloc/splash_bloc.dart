import 'dart:async';

import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/getall_company_model.dart';
import '../../domain/repository.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GetCompanyListRepo companyListRepo;

  SplashBloc(this.companyListRepo) : super(SplashInitial()) {
    on<GetCompanyListEvent>(_onGetCompanyListEvent);
  }

  Future<void> _onGetCompanyListEvent(
    GetCompanyListEvent event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoading());
    try {


      var db = LocalDbHelper();
      if (await db.isEmptyCompany()){
        final companies = await companyListRepo.getCompanyListRepo();
        await companyListRepo.storeCompanyDetails(companies);
        await db.insertCompany(companies);
        emit(SplashLoaded(companies));
      }
      else{
        final companies = await db.getAllCompany();
        emit(SplashLoaded(companies));
      }
    } catch (ex) {
      emit(SplashError('An error occurred: ${ex.toString()}'));
    }
  }
}
