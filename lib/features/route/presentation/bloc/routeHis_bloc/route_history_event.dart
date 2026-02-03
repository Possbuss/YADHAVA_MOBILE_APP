part of 'route_history_bloc.dart';

sealed class RouteHistoryEvent extends Equatable {
  const RouteHistoryEvent();
}

class FetchRouteHistory extends RouteHistoryEvent{
  final int companyId;
  final int vehicleId;
  final int routeId;
  final int driverId;
  const FetchRouteHistory({
    required this.companyId,
    required this.vehicleId,
    required this.routeId,
    required this.driverId,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [companyId, vehicleId, routeId, driverId];

}