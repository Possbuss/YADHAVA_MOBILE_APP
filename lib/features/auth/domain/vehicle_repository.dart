import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../data/vehicle_model.dart';
import '../../splash/data/getall_company_model.dart';
import '../../splash/domain/repository.dart';

class VehicleRepository {
  final ApiQuery apiQuery = ApiQuery();
  GetCompanyListRepo companyListRepo=GetCompanyListRepo();

  Future<List<VehicleModel>> getVehicleDetails() async {
    try {
      List<GetAllCompanyModel> companies = await companyListRepo.getStoredCompanyDetails();
      int companyId=companies.first.companyId;

      final response = await apiQuery.getWithOutQuery("${ApiConstants.getVehicle}companyId=$companyId");
      final dynamic data = response?.data;
      if (data is! List) {
        throw Exception('Invalid vehicle response format.');
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(VehicleModel.fromJson)
          .toList();
    } catch (ex) {
      throw Exception('Failed to fetch vehicle list: $ex');
    }
  }
}

