part of 'client_update_bloc.dart';

@immutable
sealed class ClientUpdateState {}

final class ClientUpdateInitial extends ClientUpdateState {}


final class ClientCreateInitial extends ClientUpdateState {}

final class ClientUpdateLoading extends ClientUpdateState {}

final class ClientUpdateLoaded extends ClientUpdateState {
  final ClientModel clientModel;
  ClientUpdateLoaded(this.clientModel);
}

final class ClientUpdateError extends ClientUpdateState {
  final String msg;
  ClientUpdateError(this.msg);
}