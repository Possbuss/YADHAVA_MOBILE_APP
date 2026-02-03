import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
import '../data/client_model.dart';

class CreateClientListRepo {
  final ApiQuery apiQuery = ApiQuery();
GetLoginRepo loginRepo=GetLoginRepo();
Session session=Session();
  Future<Response?> postClientListRepo(ClientModel clientModel) async {
    String token= await session.tokenExpired();

    try {
      LoginModel? storedResponse = await loginRepo.getUserLoginResponse();
      final response = await apiQuery.postQuery(
          ApiConstants.addClient,
          token,
          clientModel.toJson());
      return response;
    } catch (ex) {
      throw Exception('Failed to fetch company list: ${ex.toString()}');
    }
  }
}
