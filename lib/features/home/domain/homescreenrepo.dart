import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';

class HomeScreenRepo {
  final ApiQuery apiQuery = ApiQuery();
  Session session = Session();
  GetLoginRepo loginRepo = GetLoginRepo();

  Future<Response?> getHomeScreenData() async {
    String token = await session.tokenExpired();
    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
      log('${ApiConstants.totalSales}companyId=${storedResponse!.companyId}&vehicleId=${storedResponse.vehicleId}&invoiceDate=$formattedDate');

      final response = await apiQuery.getQuery(
          '${ApiConstants.totalSales}companyId=${storedResponse!.companyId}&vehicleId=${storedResponse.vehicleId}&invoiceDate=$formattedDate',
          token);

      return response;
    } catch (ex) {
      throw Exception('Failed to fetch stock list: ${ex.toString()}');
    }
  }
}
