import 'package:equatable/equatable.dart';

import '../../../model/route_detailsModel.dart';

abstract class RouteDetailsState extends Equatable {
  const RouteDetailsState();

  @override
  List<Object> get props => [];
}

class RouteDetailsInitial extends RouteDetailsState {}

class RouteDetailsLoading extends RouteDetailsState {}

class RouteDetailsLoaded extends RouteDetailsState {
  final List<RouteDetailsModel> routes;

  const RouteDetailsLoaded(this.routes);

  @override
  List<Object> get props => [routes];
}

class RouteDetailsError extends RouteDetailsState {
  final String message;

  const RouteDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
