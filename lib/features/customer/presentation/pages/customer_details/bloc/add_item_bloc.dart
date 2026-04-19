import 'dart:developer';
import 'dart:io';

import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/product_master.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../core/util/api_query.dart';
import '../../../../../../core/util/local_db_helper.dart';
import '../../../../../auth/data/login_model.dart';
import '../../../../../auth/domain/login_repo.dart';
import '../../../../domain/order_repo.dart';
import '../../../../model/orderModel.dart';
import '../../../../model/response_message_invoice.dart';
import '../model/order_model.dart';

part 'add_item_event.dart';
part 'add_item_state.dart';

class AddItemBloc extends Bloc<AddItemEvent, AddItemState> {
  List<ProductMaster> itemsMaster = [];
  List<ProductMaster> addedItems = [];
  //List<ProductItem> addedItems = [];
  //List<Map<String, dynamic>> fetchedItems = [];
  List<ProductMaster> fetchedItems = [];
  List<SalesInvoiceDetail> sales = [];
  final OrderRepo _orderRepo;
  final ApiQuery _apiQuery = ApiQuery();
  final GetLoginRepo _loginRepo = GetLoginRepo();
  int total = 0;

  bool _isSavingInvoice = false;

  AddItemBloc(this._orderRepo) : super(AddItemInitial()) {
    on<FetchProductMaster>(_onFetchProductMaster);
    on<FetchItems>(_onFetchItems);
    on<SubmitAddItem>(_onSubmitAddItem);
    on<PostAddedItems>(_onPostItems);
    on<FetchSalesInvoice>(_onFetchSalesInvoice);
    on<GeneratePdfEvent>(_onGeneratePdf);
    on<RemoveItem>(_onRemoveItem);
    on<UpdateItem>(_onUpdateItem);
    on<RemoveAllItem>(_onRemoveAllItems);
    on<SyncInvoices>(_syncOrdersInBackground);
  }

  Future<void> _onFetchProductMaster(
      FetchProductMaster event, Emitter<AddItemState> emit) async {
    try {
      var db = LocalDbHelper();
      bool isRefreshNeed = await db.shouldRefreshProductList();
      LoginModel? storedResponse = await _loginRepo.getUserLoginResponse();
      if (isRefreshNeed) {
        LoginModel? storedResponse =
            await _loginRepo.getUserLoginResponse();
        String routeUrl =
            '${ApiConstants.productList}companyId=${storedResponse!.companyId}';

        Response? response = await _apiQuery.getQuery(routeUrl);
        if (response != null && response.statusCode == 200) {
          final data = response.data as List<dynamic>;
          final lastInvoicedetails =
              data.map((e) => ProductMaster.fromJson(e)).toList();
          await db.refreshProductList(lastInvoicedetails);
        } else {
          emit(ItemsFetchErrorState(
              'Failed to fetch items: ${response?.statusCode}'));
        }
      }
      final data = await db.getProductMaster(storedResponse!.companyId);
      emit(ItemsFetchedState(data));
    } catch (e) {
      emit(ItemsFetchErrorState('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onFetchItems(
      FetchItems event, Emitter<AddItemState> emit) async {
    try {
      var db = LocalDbHelper();
      LoginModel? storedResponse = await _loginRepo.getUserLoginResponse();
      final data = await db.getProductMaster(storedResponse!.companyId);
      emit(ItemsFetchedState(data));
    } catch (e) {
      emit(ItemsFetchErrorState('An unexpected error occurred: $e'));
    }
  }

  void _onSubmitAddItem(SubmitAddItem event, Emitter<AddItemState> emit) {
    bool itemExists =
        addedItems.any((item) => item.productName == event.item.productName);

    if (!itemExists) {
      addedItems.add(event.item); // Add the item to the list
      emit(ItemsAddedState(addedItems)); // Emit the updated list
      emit(const ItemAddedState(
          'Item added successfully!', false)); // Emit success state
    } else {
      emit(const ItemAddedState('Item already exists!',
          true)); // Emit a message indicating the item already exists
    }
  }

  Future<int> saveOrderLocally(OrderModel order) async {
    var db = LocalDbHelper();
    return await db.insertOrder(order);
  }

  Future<void> _onPostItems(
      PostAddedItems event, Emitter<AddItemState> emit) async {
    if (_isSavingInvoice) return; // 👈 BLOCK duplicates

    _isSavingInvoice = true;

    emit(SalesInvoiceSaving());

    try {
      //  LoginModel? storedResponse = await GetLoginRepo().getUserLoginResponse();

      int orderId = await saveOrderLocally(event.order);
      emit(const ItemPostedState(
          'Order saved locally. It will sync in background.'));
      addedItems.clear();
      emit(ItemsAddedState(addedItems));
      emit(ItemPostedSuccess('1'));
      _syncOrdersInBackgroundLocally(orderId);
    } catch (e) {
      emit(ItemsFetchErrorState('An unexpected error occurred: $e'));
    } finally {
      _isSavingInvoice = false; // 👈 ALWAYS reset
    }
  }

  Future<void> _syncOrdersInBackground(
      SyncInvoices event, Emitter<AddItemState> emit) async {
    emit(SyncingSalesInvoices());
    try {
      final db = LocalDbHelper();
      final List<OrderModel> pendingOrders = await db.getPendingOrders();

      for (final order in pendingOrders) {
        final Response? response = await _apiQuery.postQuery(
          ApiConstants.createSalesInvoice,
          order.toJson(),
        );

        if (response?.statusCode == 200) {
          bool responseStatus = response?.data['result'] ?? false;
          if (responseStatus) {
            var responseMessageMobileSalesInvoice =
                ResponseMessageMobileSalesInvoice.fromJson(response!.data);

            if (responseMessageMobileSalesInvoice.result) {
              var db = LocalDbHelper();

              if (responseMessageMobileSalesInvoice.mobileAppSalesInvoiceAll!
                  .mobileAppSalesInvoiceMaster!.isNotEmpty) {
                await db.insertInvoices(
                    responseMessageMobileSalesInvoice
                        .mobileAppSalesInvoiceAll!.mobileAppSalesInvoiceMaster,
                    responseMessageMobileSalesInvoice.mobileAppSalesInvoiceAll!
                        .mobileAppSalesInvoiceMasterDt);
              }

              await db.clearTransactions();
              await db.insertTransactions(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome?.mobileAppSalesDashBoard);

              await db.clearProductStocks();
              await db.insertProductStocks(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome?.mobileAppStockBalanceVans);

              await db.clearSalesSummary();
              await db.insertSalesSummary(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome?.mobileAppSales);

              await db.clearCreditSummary();
              await db.insertCreditSummary(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome?.mobileAppSalesCredit);

              await db.clearCashSummary();
              await db.insertCashSummary(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome?.mobileAppSalesCash);

              await db.clearCashCreditDetails();
              await db.insertCashCreditDetails(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome
                  ?.salesInvoiceCollectionCreditCashCustomerImports);

              await db.updateClients(
                  responseMessageMobileSalesInvoice.clientModel,
                  order.clientId);
              await db.updateLastInvoiceData(
                  responseMessageMobileSalesInvoice.lastInvoiceModel,
                  order.clientId,
                  order.companyId);
              await db.updateRouteHistory(
                  responseMessageMobileSalesInvoice.routeHistory,
                  order.routeId,
                  order.companyId);
              await db.updateRouteHistoryDetails(
                  responseMessageMobileSalesInvoice.routeDetails,
                  order.invoiceDate,
                  order.routeId,
                  order.companyId);

              // ✅ Mark local order as "synced"
              await db.markOrderAsSynced(order.id);

              //emit(const ItemPostedState('order created successfully!'));
              //emit(ItemPostedSuccess(responseMessageMobileSalesInvoice.iDs));
              //addedItems.clear();

              //emit(ItemsAddedState(addedItems));
            } else {
              //emit(ItemsFetchErrorState('Failed to save items: ${responseMessageMobileSalesInvoice.message}'));
            }
          } else {
            ///emit(const ItemsFetchErrorState('Please check your data'));
          }
        } else {
          //emit(ItemsFetchErrorState('Failed to fetch items: ${response.statusCode}'));
        }
      }
      emit(SalesInvoicesSynced());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        emit(SalesInvoicesSyncError('An error occurred: ${e.message}'));
      } else {
        emit(SalesInvoicesSyncError('An error occurred: ${e.message}'));
        //emit(ItemsFetchErrorState('An error occurred: ${e.message}'));
      }
    } catch (e) {
      emit(SalesInvoicesSyncError('Failed to sync invoices: $e'));
    }
  }

//FetchItems event, Emitter<AddItemState> emit

  bool _isSyncing = false;

  Future<void> _syncOrdersInBackgroundLocally([int orderId = 0]) async {
    try {
      if (_isSyncing) {
        return;
      }

      _isSyncing = true;

      final db = LocalDbHelper();
      final List<OrderModel> pendingOrders = await db.getPendingOrders(orderId);

      for (final order in pendingOrders) {
        final Response? response = await _apiQuery.postQuery(
          ApiConstants.createSalesInvoice,
          order.toJson(),
        );

        if (response?.statusCode == 200) {
          bool responseStatus = response?.data['result'] ?? false;
          if (responseStatus) {
            var responseMessageMobileSalesInvoice =
                ResponseMessageMobileSalesInvoice.fromJson(response!.data);

            if (responseMessageMobileSalesInvoice.result) {
              var db = LocalDbHelper();

              if (responseMessageMobileSalesInvoice.mobileAppSalesInvoiceAll!
                  .mobileAppSalesInvoiceMaster!.isNotEmpty) {
                await db.insertInvoices(
                    responseMessageMobileSalesInvoice
                        .mobileAppSalesInvoiceAll!.mobileAppSalesInvoiceMaster,
                    responseMessageMobileSalesInvoice.mobileAppSalesInvoiceAll!
                        .mobileAppSalesInvoiceMasterDt);
              }

              await db.markOrderAsSynced(order.id);

              await db.clearTransactions();
              await db.insertTransactions(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome?.mobileAppSalesDashBoard);

              await db.clearProductStocks();
              await db.insertProductStocks(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome?.mobileAppStockBalanceVans);

              await db.clearSalesSummary();
              await db.insertSalesSummary(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome?.mobileAppSales);

              await db.clearCreditSummary();
              await db.insertCreditSummary(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome?.mobileAppSalesCredit);

              await db.clearCashSummary();
              await db.insertCashSummary(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome?.mobileAppSalesCash);

              await db.clearCashCreditDetails();
              await db.insertCashCreditDetails(responseMessageMobileSalesInvoice
                  .mobileAppSalesDashBoardHome
                  ?.salesInvoiceCollectionCreditCashCustomerImports);

              await db.updateClients(
                  responseMessageMobileSalesInvoice.clientModel,
                  order.clientId);
              await db.updateLastInvoiceData(
                  responseMessageMobileSalesInvoice.lastInvoiceModel,
                  order.clientId,
                  order.companyId);
              await db.updateRouteHistory(
                  responseMessageMobileSalesInvoice.routeHistory,
                  order.routeId,
                  order.companyId);
              await db.updateRouteHistoryDetails(
                  responseMessageMobileSalesInvoice.routeDetails,
                  order.invoiceDate,
                  order.routeId,
                  order.companyId);

              // ✅ Mark local order as "synced"

              //emit(const ItemPostedState('order created successfully!'));
              //emit(ItemPostedSuccess(responseMessageMobileSalesInvoice.iDs));
              //addedItems.clear();

              //emit(ItemsAddedState(addedItems));
            } else {
              //emit(ItemsFetchErrorState('Failed to save items: ${responseMessageMobileSalesInvoice.message}'));
            }
          } else {
            ///emit(const ItemsFetchErrorState('Please check your data'));
          }
        } else {
          //emit(ItemsFetchErrorState('Failed to fetch items: ${response.statusCode}'));
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        //emit(const ItemsFetchErrorState('Unauthorized: Please check your credentials.'));
      } else {
        //emit(ItemsFetchErrorState('An error occurred: ${e.message}'));
      }
    } catch (e) {
      //emit(SalesInvoicesSyncError('An error occurred: ${e.toString()}'));
    } finally {
      _isSyncing = false; // always reset
    }
  }

  Future<void> _onFetchSalesInvoice(
      FetchSalesInvoice event, Emitter<AddItemState> emit) async {
    emit(SalesInvoiceLoading());

    try {
      SalesInvoice? invoice = await _orderRepo.getOrder(event.invoiceNo);
      if (invoice != null) {
        log("invoiceNo${event.invoiceNo}");
        sales = invoice.mobileAppSalesInvoiceDetails;
        emit(SalesInvoiceLoaded(invoice.mobileAppSalesInvoiceDetails));
        _onGeneratePdf(
          GeneratePdfEvent(
            details: invoice.mobileAppSalesInvoiceDetails,
            name: invoice.clientName, // Replace with actual client name
            date: DateTime.now(), // Replace with actual date
            invoiceNo: event.invoiceNo, // Pass the invoiceNo here
          ),
          emit,
        );
      } else {
        emit(const ItemsFetchErrorState("Failed to load invoice details."));
      }
    } catch (e) {
      emit(ItemsFetchErrorState(e.toString()));
    }
  }

  Future<void> _onGeneratePdf(
      GeneratePdfEvent event, Emitter<AddItemState> emit) async {
    try {
      emit(SalesInvoiceLoading());

      final pdf = pw.Document();

      // Define the number of items per page
      const itemsPerPage = 25;

      final dynamic date = event.date;
      SalesInvoice? invoice = await _orderRepo.getOrder(event.invoiceNo);
      final String clientname = invoice!.clientName;
      // Split the data into chunks
      final chunks = _splitListIntoChunks(event.details, itemsPerPage);

      // Track the starting index for each page
      int globalIndex = 1;

      // Loop through each chunk and add a new page
      for (var chunk in chunks) {
        _calculateTotal(chunk);
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            clientname,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          pw.Text(
                            "$date", // Replace with the client name
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      pw.Container(
                        width: 200,
                        height: 50,
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              "Total : $total",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            pw.Text(
                              "${chunk.length} items", // Replace with actual to date
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),

                  // Table Header
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Row(
                      children: [
                        _buildPdfHeaderCell("No", flex: 1),
                        _buildPdfHeaderCell("Item", flex: 3),
                        _buildPdfHeaderCell("Quantity", flex: 2),
                        _buildPdfHeaderCell("Price", flex: 2),
                        _buildPdfHeaderCell("Total", flex: 2),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  // Table Rows for the current chunk
                  for (int i = 0; i < chunk.length; i++)
                    _buildPdfTableRow(
                      index:
                          (globalIndex++).toString(), // Increment global index

                      item: chunk[i].productName ?? "",
                      quantity: chunk[i].quantity.toString(),
                      price: chunk[i].unitRate.toString(),
                      total: chunk[i].totalRate.toString(),
                    ),

                  // Balance Portion
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.SizedBox(),
                      pw.Container(
                          width: 100,
                          height: 50,
                          padding: const pw.EdgeInsets.all(10),
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(),
                            borderRadius: pw.BorderRadius.circular(8),
                          ),
                          child: pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: event.invoiceNo,
                          )),
                    ],
                  )
                ],
              );
            },
          ),
        );
      }

      // Save the PDF
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/invoice.pdf");
      await file.writeAsBytes(await pdf.save());

      // Open the PDF
      OpenFile.open(file.path);
      emit(PdfGenerated(file.path));
    } catch (e) {
      emit(ItemsFetchErrorState("Error generating PDF: $e"));
    }
  }

  pw.Widget _buildPdfHeaderCell(String text, {int flex = 1}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  pw.Widget _buildPdfTableRow({
    required String index,
    required String item,
    required String quantity,
    required String price,
    required String total,
  }) {
    return pw.Column(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          // decoration: pw.BoxDecoration(
          //   border: pw.Border.all(),
          //   borderRadius: pw.BorderRadius.circular(8),
          // ),
          child: pw.Row(
            children: [
              _buildPdfCell(index, flex: 1),
              _buildPdfCell(item, flex: 3),
              _buildPdfCell(quantity, flex: 2),
              _buildPdfCell(price, flex: 2),
              _buildPdfCell(total, flex: 2),
            ],
          ),
        ),
        pw.Divider(color: PdfColors.black, thickness: 1)
      ],
    );
  }

  pw.Widget _buildPdfCell(String text, {int flex = 1}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }

// Helper function to split the list into chunks
  List _splitListIntoChunks(List list, int chunkSize) {
    List chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(
          i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }
    return chunks;
  }

  void _onRemoveItem(RemoveItem event, Emitter<AddItemState> emit) {
    addedItems.remove(event.items);

    emit(ItemsAddedState(addedItems));
    emit(const ItemAddedState('Item remove successfully!', false));
  }

  void _onRemoveAllItems(RemoveAllItem event, Emitter<AddItemState> emit) {
    addedItems.clear();
    emit(ItemsAddedState(addedItems));
  }

  void _onUpdateItem(UpdateItem event, Emitter<AddItemState> emit) {
    addedItems[event.index] = event.item;
    emit(ItemsAddedState(addedItems));
    emit(const ItemAddedState('Item updated successfully!', false));
  }

  void _calculateTotal(List<SalesInvoiceDetail> chunk) {
    total = 0; // Reset the total

    for (int i = 0; i < chunk.length; i++) {
      // Check if totalRate is not null and is a valid integer
      try {
        // Parse totalRate to integer and add to total
        total += (chunk[i].totalRate).toInt();
      } catch (e) {
        // Handle invalid totalRate format (e.g., log the error)
        log("Error parsing totalRate for item at index $i: ${chunk[i].totalRate}");
      }
    }
  }
}
