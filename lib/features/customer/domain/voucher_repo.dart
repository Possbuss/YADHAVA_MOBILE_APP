import 'dart:developer';


import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
import '../model/statementModel.dart';

class VoucherRepo {
  final ApiQuery apiQuery = ApiQuery();
  GetLoginRepo loginRepo = GetLoginRepo();
  Session session = Session();
  Future<List<Voucher>> getInvoices(acId, fromdate, enddate, companyId) async {
    String token = await session.tokenExpired();
   
    try {
      LoginModel? loginModel = await loginRepo.getUserLoginResponse();
      final response = await apiQuery.getQuery(
        "AccountLedgerReport/GetAccountLedgerReportsMobileApp?AccountId=${acId}&FromDate=${fromdate}&EndDate=${enddate}&CompanyId=${companyId}",
          //"${ApiConstants.voucher}AccountId=${acId}&FromDate=${fromdate}&EndDate=${enddate}&CompanyId=${companyId}}",
          token);
      if (response != null && response.statusCode == 200) {
        if (response.data != null && response.data is List) {
          // Parse the list of invoices
          return Voucher.fromJsonList(response.data);
        } else {
          throw Exception('Invoice data is invalid');
        }
      } else if (response != null &&
          (response.statusCode == 401 || response.statusCode == 400)) {
        throw Exception('Unauthorized or Bad Request');
      } else {
        throw Exception('Unexpected error occurred.');
      }
    } catch (ex) {
      throw Exception('Failed to fetch invoice details: ${ex.toString()}');
    }
  }


}
