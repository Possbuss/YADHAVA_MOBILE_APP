// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/constants/color.dart';
// import '../bloc/routeHis_bloc/route_history_bloc.dart';
// import '../pages/route_details/route_details.dart';
// import 'listTile.dart';

//
// class RouteListView extends StatelessWidget {
//   const RouteListView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<RouteHistoryBloc, RouteHistoryState>(
//       builder: (context, state) {
//         if (state is RouteHistoryLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is RouteHistoryLoaded) {
//           return SingleChildScrollView(
//             child: Column(
//               children: state.routeHistory.map((history) {
//                 return AdminShopListTile(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => RouteDetails(routeDate: history.routeDate, routeday: history.routeDay,)),
//                     );
//                   },
//                   title: history.routeDay,
//                   subtitle: "${history.salesManName} \n${history.routeDate}",
//                 );
//               }).toList(),
//             ),
//           );
//         } else if (state is RouteHistoryError) {
//           return Center(child: Text("Something Went Wrong",style: TextStyle(color: Colour.pWhite),));
//         }
//         return const Center(child: Text("No route history available"));
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/color.dart';
import '../../model/route_history_model.dart';
import '../bloc/routeHis_bloc/route_history_bloc.dart';
import '../pages/route_details/route_details.dart';
import 'listTile.dart';

class RouteListView extends StatelessWidget {
  const RouteListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RouteHistoryBloc, RouteHistoryState>(
      builder: (context, state) {
        if (state is RouteHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RouteHistoryLoaded) {
          return SingleChildScrollView(
            child: Column(
              children: state.routeHistory.map((history) {
                return AdminShopListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RouteDetails(
                          routeDate: history.routeDate,
                          routeDay: history.routeDay,
                          salesManId: history.salesManId,
                          routeId: history.routeId,
                        ),
                      ),
                    );
                  },
                  title: history.routeDay,
                  subtitle:''
                  "${history.salesManName} \n${history.routeDate}",
                );
              }).toList(),
            ),
          );
        } else if (state is RouteHistoryError) {
          return Center(
            child: Text(
              "Something Went Wrong: ${state.message}",
              style: TextStyle(color: Colour.pWhite),
            ),
          );
        }
        return const Center(child: Text("No route history available"));
      },
    );
  }
}