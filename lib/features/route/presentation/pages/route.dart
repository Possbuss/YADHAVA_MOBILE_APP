import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/data/login_model.dart';
import '../../../auth/domain/login_repo.dart';
import '../../repository/route_history_repo.dart';
import '../bloc/routeHis_bloc/route_history_bloc.dart';
import '../widgets/header.dart';
import '../widgets/routeListview.dart';
import '../widgets/searchBar.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final GetLoginRepo userRepo = GetLoginRepo();
  bool isDataFetched = false;

  int? companyId;
  int? vehicleId;
  int? routeId;
  int? driverId;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    LoginModel? responseModel = await userRepo.getUserLoginResponse();

    if (responseModel != null) {
      setState(() {
        companyId = responseModel.companyId;
        vehicleId = 0;
        routeId = responseModel.routeId;
        driverId = 0;
        isDataFetched = true;
      });
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataFetched) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocProvider(
      create: (context) => RouteHistoryBloc(routeHistoryRepo: RouteRepo())
        ..add(FetchRouteHistory(
          companyId: companyId ?? 1,
          vehicleId: vehicleId ?? 0,
          routeId: routeId ?? 0,
          driverId: driverId ?? 0,
        )),
      child: const Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.all(16),
              child: RouteSearchBar(),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: AdminSectionHeader(title: "Route history"),
            ),
            SizedBox(height: 10),
            Expanded(
              child: RouteListView(),
            ),
          ],
        ),
      ),
    );
  }
}
