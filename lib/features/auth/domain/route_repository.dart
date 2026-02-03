import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../splash/data/getall_company_model.dart';
import '../../splash/domain/repository.dart';

class GetRouteRepo{
  final ApiQuery apiQuery=ApiQuery();
  GetCompanyListRepo companyListRepo=GetCompanyListRepo();

  Future<Response?>getRouteRepo()async{
    try{
      List<GetAllCompanyModel> companies = await companyListRepo.getStoredCompanyDetails();
      int companyId=companies.first.companyId;
      final response= await apiQuery.getWithOutQuery("${ApiConstants.getRoute}companyId=$companyId");
      return response;
    }catch(ex){
      throw Exception('Failed to fetch company list: ${ex.toString()}');
    }
  }
}