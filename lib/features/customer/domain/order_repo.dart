
import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
import '../model/orderModel.dart';

class OrderRepo {
  final ApiQuery apiQuery = ApiQuery();
  final GetLoginRepo loginRepo = GetLoginRepo();
  final Session session = Session();

  Future<SalesInvoice?> getOrder(String invoiceNo) async {
    String token = await session.tokenExpired();

    try {
      LoginModel? loginModel = await loginRepo.getUserLoginResponse();
      String url = '${ApiConstants.order}invoiceNo=$invoiceNo&companyId=${loginModel!.companyId}';
      final response = await apiQuery.getQuery(
          url,
          token);
      if (response != null && response.statusCode == 200) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          return SalesInvoice.fromJson(response.data);
        } else {
          throw Exception('Invalid response format.');
        }
      } else {
        throw Exception('Unexpected error occurred.');
      }
    } catch (ex) {
      throw Exception('Failed to fetch invoice details: ${ex.toString()}');
    }
  }
}
