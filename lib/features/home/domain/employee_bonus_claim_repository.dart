import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../data/employee_bonus_claim.dart';

class EmployeeBonusClaimRepository {
  EmployeeBonusClaimRepository({ApiQuery? apiQuery})
      : _apiQuery = apiQuery ?? ApiQuery();

  final ApiQuery _apiQuery;

  Future<EmployeeBonusBalance> getBalance({
    required int companyId,
    required int employeeId,
  }) async {
    final response = await _apiQuery.getQuery(
      '${ApiConstants.employeeBonusBalance}companyId=$companyId&employeeId=$employeeId',
    );
    final data = _unwrap(response?.data);
    if (data is Map<String, dynamic>) {
      return EmployeeBonusBalance.fromJson(data);
    }
    return const EmployeeBonusBalance(
      salaryAccrued: 0,
      bonusAccrued: 0,
      salaryBalance: 0,
      bonusBalance: 0,
      totalBalance: 0,
    );
  }

  Future<List<EmployeeBonusClaim>> getClaims({
    required int companyId,
    required int employeeId,
  }) async {
    final response = await _apiQuery.getQuery(
      '${ApiConstants.employeeBonusClaims}companyId=$companyId&employeeId=$employeeId',
    );
    final data = _unwrap(response?.data);
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((item) =>
            EmployeeBonusClaim.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  dynamic _unwrap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['data'] ??
          data['Data'] ??
          data['result'] ??
          data['Result'] ??
          data;
    }
    return data;
  }
}
