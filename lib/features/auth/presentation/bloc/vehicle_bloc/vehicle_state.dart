// part of 'vehicle_bloc.dart';
//
// abstract class VehicleState extends Equatable {
//   const VehicleState();
// }
//
// class VehicleInitial extends VehicleState {
//   @override
//   List<Object> get props => [];
// }
//
// class VehicleLoading extends VehicleState {
//   @override
//   List<Object> get props => [];
// }
//
// class VehicleLoaded extends VehicleState {
//   final List vehicle;
//   const VehicleLoaded(this.vehicle);
//   @override
//   List<Object> get props => [vehicle];
// }
//
// class VehicleError extends VehicleState {
//   final String error;
//  const  VehicleError(this.error);
//   @override
//   List<Object> get props => [error];
// }


part of 'vehicle_bloc.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();
}

class VehicleInitial extends VehicleState {
  @override
  List<Object> get props => [];
}

class VehicleLoading extends VehicleState {
  @override
  List<Object> get props => [];
}

class VehicleLoaded extends VehicleState {
  final List<String> vehicles;
  final List vehicleId;

  const VehicleLoaded(this.vehicles, this.vehicleId);

  @override
  List<Object> get props => [vehicles,vehicleId];
}

class VehicleError extends VehicleState {
  final String error;

  const VehicleError(this.error);

  @override
  List<Object> get props => [error];
}
