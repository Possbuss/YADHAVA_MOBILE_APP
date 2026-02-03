// part of 'route_detail_bloc.dart';
//
// abstract class RouteDetailEvent extends Equatable {
//   const RouteDetailEvent();
// }
//
// class GetRouteDetailedEvent extends RouteDetailEvent{
//  final  int companyId;
//   final int vehicleId ;
//   final int routeId;
//   final int driverId;
//   final String date;
//   const GetRouteDetailedEvent(this.companyId, this.vehicleId, this.routeId, this.driverId, this.date);
//   @override
//   List<Object?> get props=>[
//     companyId,
//     vehicleId,routeId,driverId,date
//   ];
// }
import 'package:equatable/equatable.dart';

abstract class RouteDetailsEvent extends Equatable {
  const RouteDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchRouteDetails extends RouteDetailsEvent {
   final String date;
   final int salesManId;
   final int routeId;
   const FetchRouteDetails(this.date, this.salesManId,this.routeId);
   @override
   List<Object> get props => [date];
}
