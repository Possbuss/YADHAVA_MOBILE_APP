// import 'dart:async';
//
// import 'package:bloc/bloc.dart';
// import 'package:dio/dio.dart';
// import 'package:equatable/equatable.dart';
// import 'package:posbuss_milk/features/auth/data/refresh_model.dart';
// import 'package:posbuss_milk/features/auth/domain/refresh_repo.dart';
//
// import '../../../data/login_model.dart';
// import '../../../domain/login_repo.dart';
//
// part 'refresh_event.dart';
// part 'refresh_state.dart';
//
// class RefreshBloc extends Bloc<RefreshEvent, RefreshState> {
//   final RefreshRepo refreshRepo;
//   final GetLoginRepo loginRepo;
//
//   RefreshBloc(this.refreshRepo, this.loginRepo) : super(RefreshInitial()) {
//     on<RefreshTokenEvent>(_onRefreshTokenEvent);
//   }
//
//   Future<void>_onRefreshTokenEvent(
//       RefreshTokenEvent event,
//       Emitter<RefreshState> emit
//       )async{
//     emit(RefreshLoading());
//     try{
//       final Response? response = await refreshRepo.refreshRepo(event.refreshData);
//       if(response != null && response.statusCode == 200){
//         List responseData = response.data;
//
//         /// refresh
//         RefreshModel data=RefreshModel.fromJson(responseData.first);
//
//           print(data.runtimeType);
//           await refreshRepo.storeToken(data);
//           ///refresh
//           emit(RefreshLoaded(response.data));
//
//       }
//     }catch(ex){
//       Exception(ex);
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import '../../../data/login_model.dart';
import '../../../data/refresh_model.dart';
import '../../../domain/login_repo.dart';
import '../../../domain/refresh_repo.dart';

part 'refresh_event.dart';
part 'refresh_state.dart';

class RefreshBloc extends Bloc<RefreshEvent, RefreshState> {
  final RefreshRepo refreshRepo;
  final GetLoginRepo loginRepo;

  RefreshBloc(this.refreshRepo, this.loginRepo) : super(RefreshInitial()) {
    on<RefreshTokenEvent>(_onRefreshTokenEvent);
  }

  Future<void> _onRefreshTokenEvent(
      RefreshTokenEvent event,
      Emitter<RefreshState> emit) async {
    emit(RefreshLoading());
    try {
      final Response? response = await refreshRepo.refreshRepo(event.refreshData);
      if (response != null && response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        RefreshModel data = RefreshModel.fromJson(responseData);

        await refreshRepo.storeToken(data);
        emit(RefreshLoaded(data));
      } else {
        emit(RefreshError("Failed to refresh token"));
      }
    } catch (ex) {
      emit(RefreshError(ex.toString()));
    }
  }
}

