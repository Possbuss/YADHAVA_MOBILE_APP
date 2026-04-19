import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../data/local/sales_quotation_local_data_source.dart';
import '../data/sales_quotation_model.dart';

class SalesQuotationRepo {
  SalesQuotationRepo({
    ApiQuery? apiQuery,
    SalesQuotationLocalDataSource? localDataSource,
  })  : _apiQuery = apiQuery ?? ApiQuery(),
        _localDataSource =
            localDataSource ?? SalesQuotationLocalDataSource();

  final ApiQuery _apiQuery;
  final SalesQuotationLocalDataSource _localDataSource;

  Future<List<SalesQuotationRegisterItem>> getQuotationRegister({
    required String fromDate,
    required String endDate,
    required int partyId,
    required int companyId,
  }) async {
    final response = await _apiQuery.getQuery(
      '${ApiConstants.quotationRegister}frmDate=$fromDate&endDate=$endDate&partyId=$partyId&companyId=$companyId',
    );

    final dynamic data = response?.data;
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
    final response = await _apiQuery.getQuery(
      '${ApiConstants.quotationGetById}invoiceId=$invoiceId&companyId=$companyId',
    );
    return SalesQuotation.fromJson(response!.data as Map<String, dynamic>);
  }

  Future<void> insert(SalesQuotation quotation) async {
    final response = await _apiQuery.postQuery(
      ApiConstants.quotationInsert,
      quotation.toJson(),
    );
    _throwIfFailed(response?.data, fallback: 'Failed to create quotation.');
  }

  Future<void> update(SalesQuotation quotation) async {
    final response = await _apiQuery.postQuery(
      ApiConstants.quotationUpdate,
      quotation.toJson(),
    );
    _throwIfFailed(response?.data, fallback: 'Failed to update quotation.');
  }

  Future<void> delete({
    required String invoiceNo,
    required int companyId,
  }) async {
    final response = await _apiQuery.deleteQuery(
      '${ApiConstants.quotationDelete}invoiceNo=$invoiceNo&companyId=$companyId',
    );
    _throwIfFailed(response?.data, fallback: 'Failed to delete quotation.');
  }

  Future<void> saveDraft(SalesQuotation quotation) =>
      _localDataSource.saveDraft(quotation);

  Future<SalesQuotation?> getDraft({
    required int companyId,
    required int customerId,
    required int invoiceId,
  }) =>
      _localDataSource.getDraft(
        companyId: companyId,
        customerId: customerId,
        invoiceId: invoiceId,
      );

  Future<void> clearDraft({
    required int companyId,
    required int customerId,
    required int invoiceId,
  }) =>
      _localDataSource.clearDraft(
        companyId: companyId,
        customerId: customerId,
        invoiceId: invoiceId,
      );

  void _throwIfFailed(dynamic data, {required String fallback}) {
    if (data is Map<String, dynamic>) {
      final dynamic result = data['result'];
      if (result == false) {
        throw Exception((data['message'] ?? fallback).toString());
      }
    }
  }
}
