part of 'route_bloc.dart';

abstract class RouteState extends Equatable {
  const RouteState();
}

class RouteInitial extends RouteState {
  @override
  List<Object> get props => [];
}

class RouteLoading extends RouteState {
  @override
  List<Object> get props => [];
}

class RouteLoaded extends RouteState {
  final List<String> route;
  final List routeIdList;
  const RouteLoaded(this.route, this.routeIdList);
  @override
  List<Object> get props => [route,routeIdList];
}

class RouteError extends RouteState {
  @override
  List<Object> get props => [];
}
