part of 'client_list_bloc.dart';

sealed class ClientListState extends Equatable {
  const ClientListState();
}

final class ClientListInitial extends ClientListState {
  @override
  List<Object> get props => [];
}
final class ClientListLoading extends ClientListState {
  @override
  List<Object> get props => [];
}

final class ClientListActiveLoading extends ClientListState {
  @override
  List<Object> get props => [];
}
final class ClientListInActiveLoading extends ClientListState {
  @override
  List<Object> get props => [];
}

final class ClientListSearchLoading extends ClientListState {
  @override
  List<Object> get props => [];
}

final class ClientListLoaded extends ClientListState {
  final List<ClientModel> clientList;
  final Map<String, String> locations;
  const ClientListLoaded({required this.clientList,required this.locations});
  @override
  List<Object> get props => [clientList,locations];
}

final class ClientListActiveLoaded extends ClientListState {
  final List<ClientActiveInActiveModel> clientList;
  final Map<String, String> locations;
  const ClientListActiveLoaded({required this.clientList,required this.locations});
  @override
  List<Object> get props => [clientList,locations];
}


final class ClientListInActiveLoaded extends ClientListState {
  final List<ClientActiveInActiveModel> clientList;
  final Map<String, String> locations;
  const ClientListInActiveLoaded({required this.clientList,required this.locations});
  @override
  List<Object> get props => [clientList,locations];
}

final class ClientListError extends ClientListState {
  final String message;
  const ClientListError({required this.message});
  @override
  List<Object> get props => [message];
}