import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/route_model.dart';
import '../../../domain/route_repository.dart';

part 'route_event.dart';
part 'route_state.dart';

class RouteBloc extends Bloc<RouteEvent, RouteState> {
  final GetRouteRepo routeRepo;

  RouteBloc(this.routeRepo) : super(RouteInitial()) {
    on<GetRouteEvent>(_onGetRouteEvent);
  }

  Future<void>_onGetRouteEvent(
      GetRouteEvent event,
      Emitter<RouteState> emit
      )async{
    emit(RouteLoading());
    try{
      final List<RouteModel> routes = await routeRepo.getRouteRepo();
      emit(RouteLoaded(routes));
    }catch(_){
      emit(RouteError());
    }
  }
}
