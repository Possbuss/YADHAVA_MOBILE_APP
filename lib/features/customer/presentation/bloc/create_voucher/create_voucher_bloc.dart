import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import '../../../../../core/util/local_db_helper.dart';
import '../../../domain/cash_receipt_repo.dart';
import '../../../model/response_message_recipts_payments.dart';
import 'create_voucher_event.dart';
import 'create_voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final CashReceiptRepo cashReceiptRepo;

  VoucherBloc(this.cashReceiptRepo) : super(VoucherInitial()) {
    on<CreateVoucherEvent>(_onCreateVoucher);
  }

  Future<void> _onCreateVoucher(
      CreateVoucherEvent event, Emitter<VoucherState> emit) async {
    emit(VoucherLoading());

    try {
      // final response = await dio.post(
      //   "http://www.posbuss.com/yadhava/api/MobileAppSales/CreateVoucher",
      //   data: event.voucherData,
      //   options: Options(headers: {"Content-Type": "application/json"}),
      // );
      final Response? response=await cashReceiptRepo.createReceipt(event.voucherData);

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

        emit(VoucherSuccess(response.data["iDs"]));
      } else {
        emit(VoucherFailure("Failed to create voucher"));
      }
    } catch (e) {
      emit(VoucherFailure("Something went wrong: $e"));
    }
  }
}
