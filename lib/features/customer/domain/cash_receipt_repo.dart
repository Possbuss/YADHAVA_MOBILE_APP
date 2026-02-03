import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/util/api_query.dart';
import '../../../core/util/session.dart';
import '../model/cash_receipt_model.dart';

class CashReceiptRepo{
  
  final ApiQuery apiQuery=ApiQuery();
  Session session=Session();
  
  Future<Response?>getCasReceipt( Map<String,dynamic>data
      )async{
    try{
      String token=await session.tokenExpired();
      final  cashReceiptResponse=await apiQuery.postQuery(ApiConstants.cashReceiptGet, token, data);
      return cashReceiptResponse;
    }catch(ex){
      Exception(ex);
    }

  }

  Future<Response?>createReceipt(CashReceiptModel data)async{
   try{
     String token=await session.tokenExpired();
     final  cashReceiptResponse=await apiQuery.postQuery(ApiConstants.createVoucher, token, data.toJson());
     return cashReceiptResponse;

   }catch(ex){
     Exception(ex);
   }
   return null;
  }
  Future<Response?>updateReceipt(CashReceiptModel data)async{
    try{
      String token=await session.tokenExpired();
      final  cashReceiptResponse=await apiQuery.postQuery(ApiConstants.updatVoucher, token, data.toJson());
      return cashReceiptResponse;

    }catch(ex){
      Exception(ex);
    }
  }

}