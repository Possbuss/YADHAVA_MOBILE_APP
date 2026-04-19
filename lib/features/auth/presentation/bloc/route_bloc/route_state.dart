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
  final List<RouteModel> routes;
  const RouteLoaded(this.routes);

  List<String> get route =>
      routes.map((routeModel) => routeModel.masterName).toList();

  List<int> get routeIdList =>
      routes.map((routeModel) => routeModel.masterId).toList();

  @override
  List<Object> get props => [routes];
}

class RouteError extends RouteState {
  @override
  List<Object> get props => [];
}
