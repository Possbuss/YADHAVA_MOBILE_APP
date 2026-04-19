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
  final List<VehicleModel> vehicles;

  const VehicleLoaded(this.vehicles);

  List<String> get vehicleNames =>
      vehicles.map((vehicle) => vehicle.branchName).toList();

  List<int> get vehicleId =>
      vehicles.map((vehicle) => vehicle.branchId).toList();

  @override
  List<Object> get props => [vehicles];
}

class VehicleError extends VehicleState {
  final String error;

  const VehicleError(this.error);

  @override
  List<Object> get props => [error];
}
