part of 'route_bloc.dart';

abstract class RouteEvent extends Equatable {
  const RouteEvent();
}

class GetRouteEvent extends RouteEvent{
  @override
  List<Object>get props=>[];
}