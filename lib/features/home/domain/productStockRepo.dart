import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';

class ProductStockRepo {
  final ApiQuery apiQuery = ApiQuery();
  Session session=Session();
GetLoginRepo loginRepo=GetLoginRepo();
  Future<Response?> getStockListRepo() async {
    String token= await session.tokenExpired();
    print("token....................$token");
    try {
      LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
      log('${ApiConstants.stockSummeryStatus}?companyId=${storedResponse!.companyId}&vehicleId=${storedResponse.vehicleId}');
      
      final response = await apiQuery.getQuery('${ApiConstants.stockSummeryStatus}companyId=${storedResponse.companyId}&vehicleId=${storedResponse.vehicleId}',
          token
      );
      return response;
    } catch (ex) {
      throw Exception('Failed to fetch stock list: ${ex.toString()}');
    }
  }
}
