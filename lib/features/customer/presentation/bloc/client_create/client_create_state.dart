part of 'client_create_bloc.dart';

@immutable
sealed class ClientCreateState {}

final class ClientCreateInitial extends ClientCreateState {}

final class ClientCreateLoading extends ClientCreateState {}

final class ClientCreateLoaded extends ClientCreateState {
  final ClientModel clientModel;
  ClientCreateLoaded(this.clientModel);
}

final class ClientCreateError extends ClientCreateState {
  final String msg;
  ClientCreateError(this.msg);
}
