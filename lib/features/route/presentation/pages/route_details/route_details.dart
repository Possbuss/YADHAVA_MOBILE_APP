import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/route_detailed_bloc/route_detail_bloc.dart';
import '../../bloc/route_detailed_bloc/route_detail_event.dart';
import '../../bloc/route_detailed_bloc/route_detail_state.dart';
import 'widget/routeCard.dart';
import 'widget/route_details_appbar.dart';

class RouteDetails extends StatefulWidget {
  final String routeDate;
  final String routeDay;
  final int routeId;
  final int salesManId;

  const RouteDetails(
      {super.key, required this.routeDate, required this.routeDay, required this.salesManId,required this.routeId});

  @override
  State<RouteDetails> createState() => _RouteDetailsState();
}

class _RouteDetailsState extends State<RouteDetails> {
  @override
  void initState() {
    context.read<RouteDetailsBloc>().add(FetchRouteDetails(widget.routeDate,widget.salesManId,widget.routeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: RouteDetailsAppBar(
        routeDate: widget.routeDate,
        routeday: widget.routeDay,
      ),
      body:
          // BlocBuilder<RouteDetailBloc, RouteDetailState>(
          //   builder: (context, state) {
          //     if (state is RouteDetailLoading) {
          //       return const Center(child: CircularProgressIndicator());
          //     } else if (state is RouteDetailLoaded) {
          //       return ListView.builder(
          //         itemCount: state.routeDetails.length,
          //         itemBuilder: (context, index) {
          //           final detail = state.routeDetails[index];
          //           return ListTile(title: Text(detail.customerName)); // Adjust based on model
          //         },
          //       );
          //     } else if (state is RouteDetailError) {
          //       return const Center(child: Text("Error: n"));
          //     }
          //     return const Center(child: Text("No Data"));
          //   },
          // )

          BlocBuilder<RouteDetailsBloc, RouteDetailsState>(
        builder: (context, state) {
          if (state is RouteDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RouteDetailsLoaded) {
            List route = state.routes;
            return ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              itemCount: route.length,
              itemBuilder: (context, index) {
                final routes = route[index];
                return RouteCard(
                  number: (index + 1).toString(),
                  route: routes,
                  isLast: index == route.length - 1,
                );
              },
            );
          } else if (state is RouteDetailsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.green, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return const Center(
                child: Text("No Data", style: TextStyle(color: Colors.white)));
          }
        },
      ),
    );
  }
}
