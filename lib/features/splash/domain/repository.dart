import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../data/getall_company_model.dart';
import '../data/local/company_local_data_source.dart';

class GetCompanyListRepo {
  GetCompanyListRepo({
    ApiQuery? apiQuery,
    CompanyLocalDataSource? localDataSource,
  })  : apiQuery = apiQuery ?? ApiQuery(),
        _localDataSource = localDataSource ?? CompanyLocalDataSource();

  final ApiQuery apiQuery;
  final CompanyLocalDataSource _localDataSource;

  Future<List<GetAllCompanyModel>> getCompanyListRepo() async {
    try {
      final response = await apiQuery.getWithOutQuery(ApiConstants.companyGetAll);
      final dynamic data = response?.data;
      if (data is! List) {
        throw Exception('Invalid company list response format.');
      }

      return data
          .whereType<Map<String, dynamic>>()
          .map(GetAllCompanyModel.fromJson)
          .toList();
    } catch (ex) {
      throw Exception('Failed to fetch company list: ${ex.toString()}');
    }
  }

  Future<void> storeCompanyDetails(List<GetAllCompanyModel> companies) =>
      _localDataSource.storeCompanyDetails(companies);

  Future<List<GetAllCompanyModel>> getStoredCompanyDetails() =>
      _localDataSource.getStoredCompanyDetails();
}
