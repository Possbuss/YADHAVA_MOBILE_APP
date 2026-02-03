// // customer_statement_bloc.dart
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:posbuss_milk/features/customer/domain/voucher_repo.dart';
// import 'package:posbuss_milk/features/customer/model/statementModel.dart';
// import 'package:intl/intl.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pdfWidgets;
// import 'package:posbuss_milk/features/customer/presentation/statement_bloc.dart/statementevent.dart';
// import 'package:posbuss_milk/features/customer/presentation/statement_bloc.dart/statementstate.dart';

// class CustomerStatementBloc extends Bloc<CustomerStatementEvent, CustomerStatementState> {
//   final VoucherRepo voucherRepo;
//   CustomerStatementBloc({required this.voucherRepo}) : super(CustomerStatementInitial());

//   @override
//   Stream<CustomerStatementState> mapEventToState(CustomerStatementEvent event) async* {
//     if (event is FetchVouchersEvent) {
//       yield CustomerStatementLoading();
//       try {
//         final vouchers = await voucherRepo.getInvoices();
//         yield CustomerStatementLoaded(vouchers: vouchers);
//       } catch (e) {
//         yield CustomerStatementError(error: e.toString());
//       }
//     } else if (event is GeneratePdfEvent) {
//       yield CustomerStatementLoading();
//       try {
//         final pdfFile = await _generateTablePdf([]);
//         yield PdfGeneratedState(filePath: pdfFile.path);
//       } catch (e) {
//         yield CustomerStatementError(error: e.toString());
//       }
//     }
//   }

//   Future<File> _generateTablePdf(List<Voucher> vouchers) async {
//     final pdf = pdfWidgets.Document();
//     pdf.addPage(
//       pdfWidgets.Page(
//         build: (context) => pdfWidgets.Center(child: pdfWidgets.Text("Voucher PDF")),
//       ),
//     );

//     final now = DateTime.now();
//     final formattedDate = DateFormat('yyyyMMdd_HHmm').format(now);
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File("${directory.path}/Statement_$formattedDate.pdf");
//     await file.writeAsBytes(await pdf.save());
//     return file;
//   }
// }
