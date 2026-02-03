import 'package:Yadhava/core/util/local_db_helper.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
import '../model/route_detailsModel.dart';
import '../model/route_history_model.dart';

class RouteRepo {
  final ApiQuery apiQuery = ApiQuery();
  GetLoginRepo loginRepo = GetLoginRepo();
  Session session = Session();
  List<RouteHistory> _routeHistory = []; // Store the full client list

  Future<List<RouteHistory>> getRouteHistory({
    required int companyId,
    required int vehicleId,
    required int routeId,
    required int driverId,
  }) async {
    try {

      var db = LocalDbHelper();
      bool isLocalEmpty = await db.isEmptyRouteHistory(routeId, companyId);
      print(isLocalEmpty);
      if(!isLocalEmpty){

        final localRouteHistory = await db.getRouteHistory(routeId,companyId);
        _routeHistory = localRouteHistory;
        return _routeHistory;

      }else{

        String finalToken = await session.tokenExpired();
        String url =
            "${ApiConstants.routeHistory}companyId=$companyId&vehicleId=$vehicleId&routeId=$routeId&driverId=$driverId";

        final response = await apiQuery.getQuery(url, finalToken);
        if (response != null && response.statusCode == 200) {

          final data = response.data as List<dynamic>;
          _routeHistory = data.map((e) => RouteHistory.fromJson(e)).toList();
          if(_routeHistory.isNotEmpty){
            await db.insertRouteHistory(_routeHistory);
          }
          return  _routeHistory;
        }
        else if (response != null &&
            (response.statusCode == 401 || response.statusCode == 400)) {
          throw Exception('Unauthorized or Bad Request');
        } else {
          throw Exception('Unexpected error occurred.');
        }
      }







    } catch (ex) {
      throw Exception('Failed to fetch route history: ${ex.toString()}');
    }
  }

  Future<List<RouteDetailsModel>> getRouteDetailedRepo({
    required String date,
    required int salesManId
  }) async {
    try {
      LoginModel? responseModel = await loginRepo.getUserLoginResponse();

      if (responseModel == null) {
        throw Exception("User login details not found.");
      }
       print("dddddddddddddd$date");
      int companyId = responseModel.companyId;
      //int vehicleId = responseModel.vehicleId;
      int vehicleId = 0; //Vehicle Id Commented All Route Details Should Be There
      int routeId = responseModel.routeId;
      // int driverId = responseModel.employeeId;
      int driverId = salesManId;

      String finalToken = await session.tokenExpired();

      String url =
          "${ApiConstants.routeHistoryDetails}companyId=$companyId&vehicleId=$vehicleId&routeId=$routeId&driverId=$driverId&date=$date";

      print("Fetching Route Details from: $url");

      final response = await apiQuery.getQuery(url, finalToken);

      if (response != null && response.statusCode == 200) {
        if (response.data != null && response.data is List) {
          return RouteDetailsModel.fromJsonList(response.data);
        } else {
          throw Exception("Invalid route details data format.");
        }
      } else if (response != null &&
          (response.statusCode == 401 || response.statusCode == 400)) {
        throw Exception("Unauthorized access or Bad Request.");
      } else {
        throw Exception("Unexpected error occurred.");
      }
    } catch (e) {
      throw Exception("Failed to fetch route details: ${e.toString()}");
    }
  }


}
