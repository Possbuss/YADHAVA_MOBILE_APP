part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginLoaded extends LoginState {
  final LoginModel response;
  const LoginLoaded(this.response);

  @override
  List<Object> get props => [response];
}

class LoginError extends LoginState {
  final String errorMessage;
  const LoginError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
