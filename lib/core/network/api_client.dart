import 'package:dio/dio.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

import '../constants/api_constants.dart';
import '../data/auth_storage.dart';
import '../../features/auth/data/login_model.dart';
import '../../features/auth/data/refresh_model.dart';

class ApiClient {
  ApiClient._internal()
      : _authStorage = AuthStorage(),
        _refreshDio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 20),
            headers: const {
              'Content-Type': 'application/json',
            },
          ),
        ),
        dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 20),
            headers: const {
              'Content-Type': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            final bool requiresAuth = options.extra['requiresAuth'] != false;
            if (!requiresAuth) {
              handler.next(options);
              return;
            }

            await _attachAuthHeaders(options);
            handler.next(options);
          } catch (error) {
            handler.reject(
              DioException(
                requestOptions: options,
                error: error,
              ),
            );
          }
        },
        onError: (error, handler) async {
          if (!_shouldRetryWithRefresh(error)) {
            handler.next(error);
            return;
          }

          try {
            final String? token = await getValidAccessToken(forceRefresh: true);
            if (token == null || token.isEmpty) {
              handler.next(error);
              return;
            }

            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            error.requestOptions.extra['retriedWithFreshToken'] = true;
            final Response<dynamic> response = await dio.fetch(error.requestOptions);
            handler.resolve(response);
          } catch (_) {
            handler.next(error);
          }
        },
      ),
    );
  }

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  final Dio dio;
  final Dio _refreshDio;
  final AuthStorage _authStorage;
  Future<String?>? _refreshInFlight;

  Future<String?> getValidAccessToken({bool forceRefresh = false}) async {
    final LoginModel? loginModel = await _authStorage.getLogin();
    if (loginModel == null) {
      return null;
    }

    if (!forceRefresh && !_isExpired(loginModel.tokken)) {
      return loginModel.tokken;
    }

    final RefreshModel? refreshModel = await _authStorage.getRefreshToken();
    if (!forceRefresh &&
        refreshModel != null &&
        !_isExpired(refreshModel.accessToken)) {
      return refreshModel.accessToken;
    }

    final String refreshToken =
        (refreshModel?.refreshToken.isNotEmpty ?? false)
            ? refreshModel!.refreshToken
            : loginModel.refreshToken;

    if (refreshToken.isEmpty) {
      return null;
    }

    return _refreshAccessToken(loginModel, refreshToken);
  }

  Future<void> _attachAuthHeaders(RequestOptions options) async {
    final LoginModel? loginModel = await _authStorage.getLogin();
    if (loginModel == null) {
      return;
    }

    final String? token = await getValidAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = options.headers['Authorization'] ?? 'Bearer $token';
    }

    options.headers['routeId'] = options.headers['routeId'] ?? loginModel.routeId;
    options.headers['vehicleId'] = options.headers['vehicleId'] ?? loginModel.vehicleId;
    options.headers['companyId'] = options.headers['companyId'] ?? loginModel.companyId;
    options.headers['employeeId'] = options.headers['employeeId'] ?? loginModel.employeeId;
    options.headers['userId'] = options.headers['userId'] ?? loginModel.userId;
  }

  bool _shouldRetryWithRefresh(DioException error) {
    if (error.response?.statusCode != 401) {
      return false;
    }

    if (error.requestOptions.extra['requiresAuth'] == false) {
      return false;
    }

    if (error.requestOptions.extra['retriedWithFreshToken'] == true) {
      return false;
    }

    if (error.requestOptions.path.contains(ApiConstants.refreshToken)) {
      return false;
    }

    return true;
  }

  bool _isExpired(String token) {
    if (token.isEmpty) {
      return true;
    }

    return jwtDecode(token).isExpired ?? true;
  }

  Future<String?> _refreshAccessToken(
    LoginModel loginModel,
    String refreshToken,
  ) async {
    if (_refreshInFlight != null) {
      return _refreshInFlight;
    }

    final Future<String?> refreshFuture = () async {
      final Response<dynamic> response = await _refreshDio.post(
        ApiConstants.refreshToken,
        data: {
          'userId': loginModel.userId,
          'userType': loginModel.userType,
          'companyId': loginModel.companyId,
          'refreshToken': refreshToken,
        },
        options: Options(
          extra: const {
            'requiresAuth': false,
          },
        ),
      );

      if (response.statusCode != 200 || response.data is! Map<String, dynamic>) {
        throw Exception('Failed to refresh token.');
      }

      final RefreshModel refreshModel =
          RefreshModel.fromJson(response.data as Map<String, dynamic>);
      await _authStorage.storeRefreshToken(refreshModel);

      loginModel.tokken = refreshModel.accessToken;
      loginModel.refreshToken = refreshModel.refreshToken;
      await _authStorage.storeLogin(loginModel);

      return refreshModel.accessToken;
    }();

    _refreshInFlight = refreshFuture;

    try {
      return await refreshFuture;
    } finally {
      _refreshInFlight = null;
    }
  }

  Exception mapDioException(DioException error) {
    final Object? rawError = error.error;
    final String message =
        rawError?.toString() ?? error.message ?? 'Unknown error';

    if (message.contains('Failed host lookup')) {
      return Exception(
        'Could not resolve ${Uri.parse(ApiConstants.baseUrl).host}. '
        'Check the device internet/DNS connection and confirm plain HTTP access is allowed for this app.',
      );
    }

    if (message.contains('CLEARTEXT communication')) {
      return Exception(
        'Plain HTTP traffic is blocked on this device. '
        'Allow cleartext traffic or move the API to HTTPS.',
      );
    }

    return Exception(message);
  }
}
