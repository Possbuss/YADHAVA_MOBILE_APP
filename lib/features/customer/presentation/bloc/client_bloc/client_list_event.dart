part of 'client_list_bloc.dart';

 class ClientListEvent extends Equatable {
  const ClientListEvent();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
 class ClientListGetEvent extends ClientListEvent {
  const ClientListGetEvent();
}

class ClientListSearchEvent extends ClientListEvent {
 final String query;
 const ClientListSearchEvent(this.query);
}

class SyncClientListEvent extends ClientListEvent {
 final String query;
 const SyncClientListEvent(this.query);
}

class GetActiveClientListEvent extends ClientListEvent{
 final bool forceRefresh;
 const GetActiveClientListEvent({this.forceRefresh = false});
}

class GetInActiveClientListEvent extends ClientListEvent{
 final bool forceRefresh;
 const GetInActiveClientListEvent({this.forceRefresh = false});
}

class FetchClientLocationEvent extends ClientListEvent {
 final String clientId;
 final double latitude;
 final double longitude;

 const FetchClientLocationEvent({
  required this.clientId,
  required this.latitude,
  required this.longitude,
 });
}
