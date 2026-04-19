import 'package:dio/dio.dart';

import '../../core/network/api_client.dart';

class ApiQuery {
  final Dio _dio;
  final ApiClient _apiClient;

  static final ApiQuery _instance = ApiQuery._internal();
  factory ApiQuery() => _instance;
  ApiQuery._internal()
      : _apiClient = ApiClient(),
        _dio = ApiClient().dio;

  Future<Options> authOptions({
    String? token,
    Map<String, dynamic>? extraHeaders,
    bool requiresAuth = true,
  }) async {
    return Options(
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        ...?extraHeaders,
      },
      extra: {
        'requiresAuth': requiresAuth,
      },
    );
  }

  Future<Response?> getQuery(
    String routeUrl, [
    String? token,
  ]) async {
    return _performGet(
      routeUrl,
      token: token,
    );
  }

  Future<Response?> _performGet(
    String routeUrl, {
    String? token,
    Map<String, dynamic>? extraHeaders,
    bool requiresAuth = true,
  }) async {
    final String url = routeUrl;
    try {
      final Options options = await authOptions(
        token: token,
        extraHeaders: extraHeaders,
        requiresAuth: requiresAuth,
      );
      final Response response = await _dio.get(url, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception(' status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _apiClient.mapDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> getWithOutQuery(String routeUrl) async {
    final String url = routeUrl;
    try {
      final Response response = await _dio.get(
        url,
        options: await authOptions(requiresAuth: false),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception(' status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _apiClient.mapDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> postQuery(
    String routeUrl,
    dynamic tokenOrData, [
    Map<String, dynamic>? maybeData,
  ]) async {
    final Map<String, dynamic> data;
    String? token;

    if (tokenOrData is Map<String, dynamic> && maybeData == null) {
      data = tokenOrData;
    } else if (tokenOrData is String && maybeData != null) {
      token = tokenOrData;
      data = maybeData;
    } else {
      throw ArgumentError(
        'postQuery expects (routeUrl, data) or (routeUrl, token, data).',
      );
    }

    return _performPost(
      routeUrl,
      data,
      token: token,
    );
  }

  Future<Response?> _performPost(
    String routeUrl,
    Map<String, dynamic> data, {
    String? token,
    Map<String, dynamic>? extraHeaders,
    bool requiresAuth = true,
  }) async {
    final String url = routeUrl;

    try {
      final Options options = await authOptions(
        token: token,
        extraHeaders: extraHeaders,
        requiresAuth: requiresAuth,
      );

      final Response response =
          await _dio.post(url, data: data, options: options);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _apiClient.mapDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> postQueryWithoutToken(
    String routeUrl,
    Map<String, dynamic> data,
  ) async {
    final String url = routeUrl;
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        options: await authOptions(requiresAuth: false),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _apiClient.mapDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> updateQuery(
    String routeUrl,
    dynamic tokenOrData, [
    Map<String, dynamic>? maybeData,
  ]) async {
    final Map<String, dynamic> data;
    String? token;

    if (tokenOrData is Map<String, dynamic> && maybeData == null) {
      data = tokenOrData;
    } else if (tokenOrData is String && maybeData != null) {
      token = tokenOrData;
      data = maybeData;
    } else {
      throw ArgumentError(
        'updateQuery expects (routeUrl, data) or (routeUrl, token, data).',
      );
    }

    return _performUpdate(
      routeUrl,
      data,
      token: token,
    );
  }

  Future<Response?> _performUpdate(
    String routeUrl,
    Map<String, dynamic> data, {
    String? token,
    Map<String, dynamic>? extraHeaders,
    bool requiresAuth = true,
  }) async {
    final String url = routeUrl;
    try {
      final Options options = await authOptions(
        token: token,
        extraHeaders: extraHeaders,
        requiresAuth: requiresAuth,
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
    } on DioException catch (e) {
      throw _apiClient.mapDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response?> deleteQuery(
    String routeUrl, [
    String? token,
  ]) async {
    return _performDelete(
      routeUrl,
      token: token,
    );
  }

  Future<Response?> _performDelete(
    String routeUrl, {
    String? token,
    Map<String, dynamic>? data,
    Map<String, dynamic>? extraHeaders,
    bool requiresAuth = true,
  }) async {
    final String url = routeUrl;
    try {
      final Options options =
          await authOptions(
            token: token,
            extraHeaders: extraHeaders,
            requiresAuth: requiresAuth,
          );

      final Response response = await _dio.delete(
        url,
        data: data,
        options: options,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception('Status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _apiClient.mapDioException(e);
    } catch (e) {
      rethrow;
    }
  }
}
