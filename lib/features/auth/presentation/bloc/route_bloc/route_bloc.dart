import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
      final response=await  routeRepo.getRouteRepo();
      if(response!.statusCode==200||response.statusCode==201){
        final data=response.data;
        final List<String> route = [];
        final List routeIdList = [];
        for (int i = 0; i < data.length; i++) {
          route.add(data[i]['masterName']);
        } for (int i = 0; i < data.length; i++) {
          routeIdList.add(data[i]['masterId']);
        }
        emit(RouteLoaded(route,routeIdList));
      }else{
        emit(RouteError());
      }
    }catch(ex){
      Exception(ex);
    }
  }
}
