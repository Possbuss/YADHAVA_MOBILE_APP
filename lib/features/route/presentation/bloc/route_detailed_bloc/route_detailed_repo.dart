// // import 'package:dio/dio.dart';
// // import 'package:posbuss_milk/core/constants/api_constants.dart';
// // import 'package:posbuss_milk/core/util/api_query.dart';
// // import 'package:posbuss_milk/features/auth/data/login_model.dart';
// // import 'package:posbuss_milk/features/splash/data/getall_company_model.dart';
// //
// // import '../../../../../core/util/session.dart';
// // import '../../../../auth/domain/loginRepo.dart';
// //
// // class RouteDetailedRepo{
// //   final ApiQuery apiQuery=ApiQuery();
// //   GetLoginRepo loginRepo=GetLoginRepo();
// //   Session session=Session();
// //   GetLoginRepo userRepo=GetLoginRepo();
// //
// //   Future<Response?> getRouteDetailedRepo()async{
// //     LoginModel? responseModel=await userRepo.getUserLoginResponse();
// //     int companyId=responseModel!.companyId;
// //     int vehicleId=responseModel.vehicleId;
// //     // int routeId=responseModel.routeId;
// //     int routeId=2;
// //     int driverId=responseModel.driverId;
// //     String date="2025-01-30";
// //     String token= await session.tokenExpired();
// //     try{
// //       final response = await apiQuery.getQuery(
// //           "${ApiConstants.detaileRoute}companyId=$companyId&vehicleId=$vehicleId&routeId=$routeId&driverId=$driverId&date=$date",
// //           token
// //       );
// //
// //       return response;
// //     }catch(ex){
// //       Exception(ex);
// //     }
// //   }
// // }
// import 'package:dio/dio.dart';
// import 'package:posbuss_milk/core/constants/api_constants.dart';
// import 'package:posbuss_milk/core/util/api_query.dart';
// import 'package:posbuss_milk/features/auth/data/login_model.dart';
// import '../../../../../core/util/session.dart';
// import '../../../../auth/domain/loginRepo.dart';
// import '../../../data/route_detail_model.dart';
//
// class RouteDetailedRepo {
//   final ApiQuery apiQuery = ApiQuery();
//   final GetLoginRepo userRepo = GetLoginRepo();
//   final Session session = Session();
//
//   Future<List<RouteDetailsModel>?> getRouteDetailedRepo( ) async {
//     try {
//       LoginModel? responseModel = await userRepo.getUserLoginResponse();
//       if (responseModel == null) {
//         throw Exception("User login response is null");
//       }
//
//       int companyId = responseModel.companyId;
//       int vehicleId = responseModel.vehicleId;
//       int routeId = 2;  // Static for now
//       int driverId = responseModel.driverId;
//       String date = "2025-01-30";
//       String token = await session.tokenExpired();
//
//       final response = await apiQuery.getQuery(
//         "${ApiConstants.detaileRoute}companyId=$companyId&vehicleId=$vehicleId&routeId=$routeId&driverId=$driverId&date=$date",
//         token,
//       );
//       if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
//         if(response.data != null && response.data is List){
//           return routeDetailsModelFromJson(response!.data);
//         }else if (response != null &&
//             (response.statusCode == 401 || response.statusCode == 400)) {
//           throw Exception('Unauthorized or Bad Request');
//         } else {
//           throw Exception('Unexpected error occurred.');
//         }
//
//       }
//       // return routeDetailsModelFromJson(response!.data);
//     } catch (ex) {
//       print('Error fetching route details: $ex');
//       Exception(ex);
//       return null;
//     }
//   }
// }


// class RouteDetailedRepo {
//   final ApiQuery apiQuery = ApiQuery();
//   final GetLoginRepo userRepo = GetLoginRepo();
//   final Session session = Session();
//
//   Future<List<RouteDetailsModel>?> getRouteDetailedRepo() async {
//     try {
//       LoginModel? responseModel = await userRepo.getUserLoginResponse();
//       if (responseModel == null) {
//         throw Exception("User login response is null");
//       }
//
//       int companyId = responseModel.companyId;
//       int vehicleId = responseModel.vehicleId;
//       int routeId = 2; // Static for now
//       int driverId = responseModel.driverId;
//       String date = "2025-01-30";
//       String token = await session.tokenExpired();
//
//       final response = await apiQuery.getQuery(
//         "${ApiConstants.detaileRoute}companyId=$companyId&vehicleId=$vehicleId&routeId=$routeId&driverId=$driverId&date=$date",
//         token,
//       );
//
//       if (response == null) {
//         throw Exception("Null response received");
//       }
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (response.data != null && response.data is List) {
//           return response.data.map<RouteDetailsModel>((item) => RouteDetailsModel.fromJson(item)).toList();
//         } else if (response.data is String && response.data.isEmpty) {
//           throw Exception("Empty response received");
//         } else {
//           throw Exception("Unexpected response format");
//         }
//       } else if (response.statusCode == 401 || response.statusCode == 400) {
//         throw Exception('Unauthorized or Bad Request');
//       } else {
//         throw Exception('Unexpected error occurred. Status Code: ${response.statusCode}');
//       }
//     } catch (ex) {
//       print('Error fetching route details: $ex');
//       return null;
//     }
//   }
// }
