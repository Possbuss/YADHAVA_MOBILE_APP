import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../../../data/login_model.dart';
import '../../../domain/login_repo.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final GetLoginRepo loginRepo;
  LoginBloc(this.loginRepo) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }
  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<LoginState> emit,

  ) async {
    emit(LoginLoading());

    try {
      final Response? response = await loginRepo.LoginRepo(event.loginData);

      if (response != null && response.statusCode == 200) {
        List responseData = response.data;
        print(responseData.runtimeType);
        LoginModel data=LoginModel.fromJson(responseData.first);
        if(data.loginMessage=='SUCCESS'){
          print(data.runtimeType);
          await loginRepo.storeUserLoginResponse(data);
          LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
          print(storedResponse!.companyId);
          log(storedResponse.tokken);
          emit(LoginLoaded(response.data));
        }else{
          emit(LoginError(data.loginMessage));
        }

      } else {
        emit(LoginError("Error"));
      }
    } catch (e) {
      emit(LoginError("Error$e"));
    }
  }
}
