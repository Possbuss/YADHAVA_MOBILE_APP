import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:Yadhava/features/route/presentation/bloc/route_detailed_bloc/route_detail_event.dart';
import 'package:Yadhava/features/route/presentation/bloc/route_detailed_bloc/route_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repository/route_history_repo.dart';

class RouteDetailsBloc extends Bloc<RouteDetailsEvent, RouteDetailsState> {
  RouteRepo repository;

  RouteDetailsBloc(this.repository) : super(RouteDetailsInitial()) {
    on<FetchRouteDetails>(_onFetchRouteDetails);
  }

  Future<void> _onFetchRouteDetails(
      FetchRouteDetails event, Emitter<RouteDetailsState> emit) async {
    try {
      emit(RouteDetailsLoading());

      var db = LocalDbHelper();
      var companyDt = await db.getAllCompany();
      var company = companyDt.first;
      bool isEmpty = await db.isEmptyRouteHistoryDetails(event.salesManId,event.routeId,company.companyId,event.date);

      if(!isEmpty){
        final routesDet = await db.getRouteHistoryDetails(event.date, event.routeId, event.salesManId, company.companyId);
        if (routesDet.isEmpty) {
          emit(const RouteDetailsError("No route details found for the selected date."));
        } else {
          emit(RouteDetailsLoaded(routesDet));
        }
      }
      else{
        final routes = await repository.getRouteDetailedRepo(date: event.date,salesManId: event.salesManId);
        if (routes.isEmpty) {
          emit(const RouteDetailsError("No route details found for the selected date."));
        } else {
          await db.insertRouteHistoryDetails(routes);
          emit(RouteDetailsLoaded(routes));
        }
      }
    } catch (e) {
      emit(RouteDetailsError("Failed to fetch route details: $e"));
    }
  }

}
