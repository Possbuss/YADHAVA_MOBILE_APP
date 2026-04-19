import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      final LoginModel loginModel = await loginRepo.loginRepo(event.loginData);
      if(loginModel.loginMessage=='SUCCESS'){
        await loginRepo.storeUserLoginResponse(loginModel);
        LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
        log('Login success for userId=${storedResponse?.userId}');
        emit(LoginLoaded(loginModel));
      } else {
        emit(LoginError(loginModel.loginMessage));
      }
    } catch (e) {
      emit(LoginError("Error$e"));
    }
  }
}
