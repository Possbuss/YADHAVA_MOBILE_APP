// part of 'vehicle_bloc.dart';
//
// abstract class VehicleEvent extends Equatable {
//   const VehicleEvent();
// }
// class GetVehicleList extends VehicleEvent{
//   @override
//   // TODO: implement props
//   List<Object?> get props => throw UnimplementedError();
//
// }

part of 'vehicle_bloc.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();
}

class GetVehicleList extends VehicleEvent {
  @override
  List<Object?> get props => [];
}
