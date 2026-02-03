import 'package:dio/dio.dart';

import '../../features/auth/data/login_model.dart';
import '../../features/auth/domain/login_repo.dart';
import '../constants/api_constants.dart';

class ApiQuery {
  final Dio _dio;

  static final ApiQuery _instance = ApiQuery._internal();
  factory ApiQuery() => _instance;
  ApiQuery._internal() : _dio = Dio() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<Response?> getQuery(String routeUrl, String? token) async {
    final String url = '${ApiConstants.baseUrl}$routeUrl';
    try {
      GetLoginRepo loginRepo = GetLoginRepo();

      LoginModel? loginModel = await loginRepo.getUserLoginResponse();

      final Options options = Options(
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'routeId': loginModel?.routeId ?? '',
          'vehicleId': loginModel?.vehicleId ?? '',
          'companyId': loginModel?.companyId ?? '',
          'employeeId': loginModel?.employeeId ?? '',
          'userId': loginModel?.userId ?? ''
        },
      );
      print(url);
      final Response response = await _dio.get(url, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception(' status code ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getWithOutQuery(String routeUrl) async {
    final String url = '${ApiConstants.baseUrl}$routeUrl';
    try {
      final Response response = await _dio.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception(' status code ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> postQuery(
    String routeUrl,
    String token,
    Map<String, dynamic> data,
  ) async {
    GetLoginRepo loginRepo = GetLoginRepo();

    final String url = '${ApiConstants.baseUrl}$routeUrl';
    LoginModel? loginModel = await loginRepo.getUserLoginResponse();

    try {
      final Options options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'routeId': loginModel?.routeId ?? '',
          'vehicleId': loginModel?.vehicleId ?? '',
          'companyId': loginModel?.companyId ?? '',
          'employeeId': loginModel?.employeeId ?? '',
          'userId': loginModel?.userId ?? ''
        },
      );

      final Response response =
          await _dio.post(url, data: data, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Status code ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> postQueryWithoutToken(
    String routeUrl,
    Map<String, dynamic> data,
  ) async {
    final String url = '${ApiConstants.baseUrl}$routeUrl';
    try {
      final Response response = await _dio.post(
        url,
        data: data,
      );
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Status code ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> updateQuery(
    String routeUrl,
    String token,
    Map<String, dynamic> data,
  ) async {
    final String url = '${ApiConstants.baseUrl}$routeUrl';
    try {
      GetLoginRepo loginRepo = GetLoginRepo();

      LoginModel? loginModel = await loginRepo.getUserLoginResponse();

      final Options options = Options(
        headers: {
          'Authorization': 'Bearer $token',
          'routeId': loginModel?.routeId ?? '',
          'vehicleId': loginModel?.vehicleId ?? '',
          'companyId': loginModel?.companyId ?? '',
          'employeeId': loginModel?.employeeId ?? '',
          'userId': loginModel?.userId ?? ''
        },
      );

      final Response response = await _dio.put(
        url,
        data: data,
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Status code ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
