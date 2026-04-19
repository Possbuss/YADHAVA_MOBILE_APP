// import 'dart:async';
//
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:posbuss_milk/features/auth/domain/vehicle_repository.dart';
//
// import '../../../data/vehicle_model.dart';
//
// part 'vehicle_event.dart';
// part 'vehicle_state.dart';
//
// class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
//   final VehicleRepository vehicleRepository;
//   VehicleBloc(this.vehicleRepository) : super(VehicleInitial()) {
//     on<GetVehicleList>(_onGetVehicleList);
//   }
//   Future<void>_onGetVehicleList(
//       GetVehicleList event,
//       Emitter<VehicleState> emit
//       )async{
//     emit(VehicleLoading());
//     try{
//    final response=await vehicleRepository.getVehicleDetails();
//    if (response!.statusCode == 200 || response.statusCode == 201) {
//      final data = response.data as List<dynamic>;
//      final vehicle = data.map((e) => VehicleModel.fromJson(e)).toList();
//      emit(VehicleLoaded(vehicle));
//
//    } else {
//      emit(VehicleError('Failed to fetch company data. Status code: ${response.statusCode}'));
//    }
//    }catch(ex){
//       Exception(ex);
//     }
//   }
// }

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/vehicle_model.dart';
import '../../../domain/vehicle_repository.dart';

part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleRepository vehicleRepository;

  VehicleBloc(this.vehicleRepository) : super(VehicleInitial()) {
    on<GetVehicleList>(_onGetVehicleList);
  }
  Future<void> _onGetVehicleList(
      GetVehicleList event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());

    try {
      final List<VehicleModel> vehicles =
          await vehicleRepository.getVehicleDetails();
      emit(VehicleLoaded(vehicles));
    } catch (ex) {
      emit(VehicleError('An error occurred: ${ex.toString()}'));
    }
  }
}
