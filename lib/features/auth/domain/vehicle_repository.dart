
import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../splash/data/getall_company_model.dart';
import '../../splash/domain/repository.dart';

class VehicleRepository {
  final ApiQuery apiQuery = ApiQuery();
  GetCompanyListRepo companyListRepo=GetCompanyListRepo();

  Future<Response?> getVehicleDetails() async {
    try {
      List<GetAllCompanyModel> companies = await companyListRepo.getStoredCompanyDetails();
      int companyId=companies.first.companyId;

      final response = await apiQuery.getWithOutQuery("${ApiConstants.getVehicle}companyId=$companyId");
      print('API Response: ${response?.data}');
      return response;
    } catch (ex) {
      print('Error fetching vehicle details: $ex');
      throw Exception('Failed to fetch vehicle list: $ex');
    }
  }
}


