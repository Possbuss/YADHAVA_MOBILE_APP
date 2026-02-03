import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../model/route_history_model.dart';
import '../../../repository/route_history_repo.dart';

part 'route_history_event.dart';
part 'route_history_state.dart';

class RouteHistoryBloc extends Bloc<RouteHistoryEvent, RouteHistoryState> {
  final RouteRepo routeHistoryRepo;

  RouteHistoryBloc({required this.routeHistoryRepo})
      : super(RouteHistoryInitial()) {
    on<FetchRouteHistory>((event, emit) async {
      emit(RouteHistoryLoading());
      try {
        final routeHistory = await routeHistoryRepo.getRouteHistory(
          companyId: event.companyId,
          vehicleId: event.vehicleId,
          routeId: event.routeId,
          driverId: event.driverId,
        );
        // print("RouteHistory type: ${routeHistory.runtimeType}");
        // print("RouteHistory data: $routeHistory");
        emit(RouteHistoryLoaded(routeHistory: routeHistory));
      } catch (e) {
        emit(RouteHistoryError(message: e.toString()));
        print("Error: $e");
      }
    });
  }
}