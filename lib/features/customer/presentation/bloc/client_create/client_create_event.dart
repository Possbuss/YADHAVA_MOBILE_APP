part of 'client_create_bloc.dart';

@immutable
sealed class ClientCreateEvent {}

class PostClientCreate extends ClientCreateEvent {
  final ClientModel clientModel;
  PostClientCreate(this.clientModel);
}
class ClientResetEvent extends ClientCreateEvent {
  ClientResetEvent();
}