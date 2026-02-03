import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../../../core/util/local_db_helper.dart';
import '../../../domain/cash_receipt_repo.dart';
import '../../../model/response_message_recipts_payments.dart';
import 'create_voucher_event.dart';
import 'create_voucher_state.dart';

class VoucherUpdateBloc extends Bloc<VoucherUpdateEvent, VoucherUpdateState> {
  final CashReceiptRepo cashReceiptRepo;

  VoucherUpdateBloc(this.cashReceiptRepo) : super(VoucherUpdateInitial()) {
    on<UpdateVoucherEvent>(_onCreateVoucher);
  }

  Future<void> _onCreateVoucher(
      UpdateVoucherEvent event, Emitter<VoucherUpdateState> emit) async {
    emit(VoucherUpdateLoading());

    try {
      // final response = await dio.post(
      //   "http://www.posbuss.com/yadhava/api/MobileAppSales/CreateVoucher",
      //   data: event.voucherData,
      //   options: Options(headers: {"Content-Type": "application/json"}),
      // );
      final Response? response=await cashReceiptRepo.updateReceipt(event.voucherData);

      if (response!.statusCode == 200 && response.data["result"] == true) {

        var responseMessageMobileSalesInvoice =
        ResponseMessageReceiptsPayments.fromJson(response.data);

        var db = LocalDbHelper();

        await db.clearTransactions();
        await db.insertTransactions(responseMessageMobileSalesInvoice.mobileAppSalesDashBoardHome?.mobileAppSalesDashBoard);

        await db.clearSalesSummary();
        await db.insertSalesSummary(responseMessageMobileSalesInvoice.mobileAppSalesDashBoardHome?.mobileAppSales);

        await db.clearCreditSummary();
        await db.insertCreditSummary(responseMessageMobileSalesInvoice.mobileAppSalesDashBoardHome?.mobileAppSalesCredit);

        await db.clearCashSummary();
        await db.insertCashSummary(responseMessageMobileSalesInvoice.mobileAppSalesDashBoardHome?.mobileAppSalesCash);

        await db.clearCashCreditDetails();
        await db.insertCashCreditDetails(responseMessageMobileSalesInvoice.mobileAppSalesDashBoardHome?.salesInvoiceCollectionCreditCashCustomerImports);

        await db.updateClients(responseMessageMobileSalesInvoice.clientModel,event.voucherData.customerId);

        await db.clearReceiptsPayments(event.voucherData.customerId);
        await db.insertReceipts(responseMessageMobileSalesInvoice.cashReceipts!);


        emit(VoucherUpdateSuccess(response.data["iDs"]));
      } else {
        emit(UpdateVoucherFailure("Failed to create voucher"));
      }
    } catch (e) {
      emit(UpdateVoucherFailure("Something went wrong: $e"));
    }
  }
}
