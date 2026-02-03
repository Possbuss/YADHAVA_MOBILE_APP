part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final Map<String, dynamic> loginData;

  const LoginButtonPressed(this.loginData);

  @override
  List<Object?> get props => [loginData];
}