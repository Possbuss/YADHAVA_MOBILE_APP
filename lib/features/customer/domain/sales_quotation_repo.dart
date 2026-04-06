import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/session.dart';
import '../../auth/data/login_model.dart';
import '../../auth/domain/login_repo.dart';
import '../data/sales_quotation_model.dart';

class SalesQuotationRepo {
  final Dio _dio = Dio();
  final Session _session = Session();
  final GetLoginRepo _loginRepo = GetLoginRepo();

  Future<Options> _options() async {
    final String token = await _session.tokenExpired();
    final LoginModel? loginModel = await _loginRepo.getUserLoginResponse();
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
        'routeId': loginModel?.routeId ?? '',
        'vehicleId': loginModel?.vehicleId ?? '',
        'companyId': loginModel?.companyId ?? '',
        'employeeId': loginModel?.employeeId ?? '',
        'userId': loginModel?.userId ?? '',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<List<SalesQuotationRegisterItem>> getQuotationRegister({
    required String fromDate,
    required String endDate,
    required int partyId,
    required int companyId,
  }) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.quotationRegister}frmDate=$fromDate&endDate=$endDate&partyId=$partyId&companyId=$companyId',
      options: await _options(),
    );

    final dynamic data = response.data;
    if (data is! List) {
      return const <SalesQuotationRegisterItem>[];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(SalesQuotationRegisterItem.fromJson)
        .toList();
  }

  Future<SalesQuotation> getById({
    required int invoiceId,
    required int companyId,
  }) async {
    final response = await _dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.quotationGetById}invoiceId=$invoiceId&companyId=$companyId',
      options: await _options(),
    );
    return SalesQuotation.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> insert(SalesQuotation quotation) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.quotationInsert}',
      data: quotation.toJson(),
      options: await _options(),
    );
    _throwIfFailed(response.data, fallback: 'Failed to create quotation.');
  }

  Future<void> update(SalesQuotation quotation) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.quotationUpdate}',
      data: quotation.toJson(),
      options: await _options(),
    );
    _throwIfFailed(response.data, fallback: 'Failed to update quotation.');
  }

  Future<void> delete({
    required String invoiceNo,
    required int companyId,
  }) async {
    final response = await _dio.delete(
      '${ApiConstants.baseUrl}${ApiConstants.quotationDelete}invoiceNo=$invoiceNo&companyId=$companyId',
      options: await _options(),
    );
    _throwIfFailed(response.data, fallback: 'Failed to delete quotation.');
  }

  void _throwIfFailed(dynamic data, {required String fallback}) {
    if (data is Map<String, dynamic>) {
      final dynamic result = data['result'];
      if (result == false) {
        throw Exception((data['message'] ?? fallback).toString());
      }
    }
  }
}
