import 'dart:async';

import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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


      var db = new LocalDbHelper();
      if (await db.isEmptyCompany()){
        final response = await companyListRepo.getCompanyListRepo();
        if (response!.statusCode == 200 || response.statusCode == 201){
          print(response.data.runtimeType);
          final data = response.data as List<dynamic>;
          final companies =
          data.map((e) => GetAllCompanyModel.fromJson(e)).toList();
          await companyListRepo.storeCompanyDetails(companies);
          await db.insertCompany(companies);
          emit(SplashLoaded(companies));

        }else {
          emit(SplashError(
              'Failed to fetch company data. Status code: ${response.statusCode}'));
        }
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
