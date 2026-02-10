import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/local_db_helper.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
import '../data/client_model.dart';

class GetClientListRepo {

  final ApiQuery apiQuery = ApiQuery();
  Session session=Session();

  Future<Response?> getClientListRepo(int? companyId,int? routeId,int? id) async {

    String token= await session.tokenExpired();
    try {
      //final response = await apiQuery.getQuery("${ApiConstants.clientList}companyId=$companyId&routeId=$routeId&id=$id",token);
      //return response;

      final clientRequestModel = ClientRequestModel(
        routeId: routeId,
        clientId: id,
        companyId: companyId,
        dateTime: (await LocalDbHelper().getClientSyncDateStamp()) ?? ""
      );


      final response = await apiQuery.postQuery(
          ApiConstants.clientListDateWise,
        token,
          clientRequestModel.toJson()
      );

      return response;


    } catch (ex) {
      throw Exception('Failed to fetch company list: ${ex.toString()}');
    }
  }

  Future<Response?> getClientListAllRepo(int? companyId,int? routeId,int? id) async {

    String token= await session.tokenExpired();
    try {
      //final response = await apiQuery.getQuery("${ApiConstants.clientList}companyId=$companyId&routeId=$routeId&id=$id",token);
      //return response;

      final clientRequestModel = ClientRequestModel(
          routeId: routeId,
          clientId: id,
          companyId: companyId,
          dateTime: (await LocalDbHelper().getClientSyncDateStamp()) ?? ""
      );


      final response = await apiQuery.postQuery(
          ApiConstants.clientListDateWise,
          token,
          clientRequestModel.toJson()
      );

      return response;


    } catch (ex) {
      throw Exception('Failed to fetch company list: ${ex.toString()}');
    }
  }

  Future<Response?> getClientListActive(int? companyId,int? routeId,int? id) async {

    String token= await session.tokenExpired();
    try {
      String token = await session.tokenExpired();
      final response = await apiQuery.getQuery(
          "${ApiConstants.getMobileActiveClients}companyId=$companyId&routeId=$routeId",
          token);
      return response;
    } catch (ex) {
      throw Exception('Failed to fetch getClientListActive list: ${ex.toString()}');
    }
  }

  Future<Response?> getClientListInActive(int? companyId,int? routeId,int? id) async {

    String token= await session.tokenExpired();
    try {
      String token = await session.tokenExpired();
      final response = await apiQuery.getQuery(
          "${ApiConstants.getMobileInActiveClients}companyId=$companyId&routeId=$routeId",
          token);
      return response;
    } catch (ex) {
      throw Exception('Failed to fetch getClientListInActive list: ${ex.toString()}');
    }

  }
}
