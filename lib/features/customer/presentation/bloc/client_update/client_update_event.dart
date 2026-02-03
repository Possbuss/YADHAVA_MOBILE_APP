part of 'client_update_bloc.dart';

@immutable
sealed class ClientUpdateEvent {}

class UpdateClient extends ClientUpdateEvent {
  final ClientModel clientModel;
  UpdateClient(this.clientModel);
}

class ClientUpdateResetEvent extends ClientUpdateEvent {
  ClientUpdateResetEvent();
}
