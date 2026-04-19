import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';

class ProductStockRepo {
  final ApiQuery apiQuery = ApiQuery();
final GetLoginRepo loginRepo=GetLoginRepo();
  Future<Response?> getStockListRepo() async {
    try {
      LoginModel? storedResponse = await loginRepo.getUserLoginResponse();

      final response = await apiQuery.getQuery(
        '${ApiConstants.stockSummeryStatus}companyId=${storedResponse!.companyId}&vehicleId=${storedResponse.vehicleId}',
      );
      return response;
    } catch (ex) {
      throw Exception('Failed to fetch stock list: ${ex.toString()}');
    }
  }
}
