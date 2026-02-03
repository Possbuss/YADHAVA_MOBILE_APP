part of 'route_history_bloc.dart';

sealed class RouteHistoryState extends Equatable {
  const RouteHistoryState();
}

final class RouteHistoryInitial extends RouteHistoryState {
  @override
  List<Object> get props => [];
}
// class RouteHistoryInitial extends RouteHistoryState {}

class RouteHistoryLoading extends RouteHistoryState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class RouteHistoryLoaded extends RouteHistoryState {
  final List<dynamic> routeHistory;

  RouteHistoryLoaded({required this.routeHistory});

  @override
  List<Object> get props => [routeHistory];
}

class RouteHistoryError extends RouteHistoryState {
  final String message;

  RouteHistoryError({required this.message});

  @override
  List<Object> get props => [message];
}