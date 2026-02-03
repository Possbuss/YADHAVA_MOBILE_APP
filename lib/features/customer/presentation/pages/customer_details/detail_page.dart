// import 'dart:developer' as d;
//
// import 'package:Yadhava/features/customer/presentation/pages/customer_details/widget/custom_button.dart';
// import 'package:Yadhava/features/customer/presentation/pages/customer_details/widget/delete_pop.dart';
// import 'package:Yadhava/features/customer/presentation/pages/customer_details/widget/item_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../../core/constants/color.dart';
// import '../../../../../core/util/format_rupees.dart';
// import '../../../../../core/widget/custom_popup.dart';
// import '../../../../auth/data/login_model.dart';
// import '../../../../auth/domain/login_repo.dart';
// import '../../../../home/presentation/bloc/stockList_bloc/stock_list_bloc.dart';
// import '../../../../home/presentation/bloc/totalSales_bloc/bloc/total_sales_bloc.dart';
// import '../../../data/client_model.dart';
// import '../../../domain/order_repo.dart';
// import '../../../model/orderModel.dart';
// import '../../bloc/client_bloc/client_list_bloc.dart';
// import '../../bloc/inovice_bloc/invoice_bloc.dart';
// import '../Invoice_pages/widgets/discount_field.dart';
// import 'add_items.dart';
// import 'bloc/add_item_bloc.dart';
// import 'model/order_model.dart';
//
// //OrderRepo
// class CustomerDetails extends StatefulWidget {
//   final ClientModel client;
//   final String fromDate;
//   final String endDate;
//   final int vehicleId;
//   final int companyId;
//   final VoidCallback onOrderSaved;
//   const CustomerDetails({
//     super.key,
//     required this.client,
//     required this.onOrderSaved,
//     required this.fromDate,
//     required this.endDate,
//     required this.vehicleId,
//     required this.companyId,
//   });
//
//   @override
//   State<CustomerDetails> createState() => _CustomerDetailsState();
// }
//
// class _CustomerDetailsState extends State<CustomerDetails> {
//   final OrderRepo _orderRepo = OrderRepo();
//   LoginModel? loginResponse;
//   TextEditingController discountAmount = TextEditingController();
//   TextEditingController discountPercentage = TextEditingController();
//   TextEditingController paidAmount = TextEditingController();
//   String selectedOption = "Cash";
//   int discount =  0;
//
//   String paymentType = '';
//   double nettotal = 0.0;
//   // final List<SalesInvoice> _order = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<AddItemBloc>().add(FetchItems());
//     });
//     getLoginResponse();
//
//     discountAmount.addListener(() {
//       setState(() {
//         discount = int.tryParse(discountAmount.text.trim()) ?? 0;
//       });
//     });
//   }
//
//   Future<void> getLoginResponse() async {
//     loginResponse = await GetLoginRepo().getUserLoginResponse();
//     if (mounted) {
//       setState(() {}); // Trigger UI update if necessary
//     }
//   }
//
//   double? latitude;
//   double? longitude;
//   String locationStatus = "Press the button to get location";
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       // Check if location services are enabled
//       bool isLocationServiceEnabled =
//           await Geolocator.isLocationServiceEnabled();
//       if (!isLocationServiceEnabled) {
//         setState(() {
//           locationStatus = "Location services are disabled.";
//         });
//         return;
//       }
//
//       // Check and request location permissions
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           setState(() {
//             locationStatus = "Location permission denied.";
//           });
//           return;
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           locationStatus =
//               "Location permission permanently denied. Enable it from settings.";
//         });
//
//         // Open app settings to allow user to enable permission manually
//         await openAppSettings();
//         return;
//       }
//
//       // Get current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       setState(() {
//         latitude = position.latitude;
//         longitude = position.longitude;
//         locationStatus = "Latitude: $latitude, Longitude: $longitude";
//       });
//     } catch (e) {
//       setState(() {
//         locationStatus = "Error fetching location: $e";
//       });
//     }
//   }
//
//   Widget _buildRadioButton(String value) {
//     return Row(
//       children: [
//         Radio<String>(
//           activeColor: Colour.pWhite,
//
//           focusColor: Colour.pWhite,
//           value: value,
//           groupValue: selectedOption,
//           onChanged: (newValue) {
//             if (newValue == 'Cash') {
//               paymentType = "Cash";
//             } else {
//               paymentType = "Bank";
//             }
//             setState(() {
//               selectedOption = newValue!;
//               paymentType=newValue.toUpperCase();
//             });
//           },
//           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           visualDensity: VisualDensity.compact,
//         ),
//         Text(value, style: const TextStyle(fontSize: 14,color: Colour.pWhite)),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colour.pBackgroundBlack,
//         appBar: AppBar(
//           backgroundColor: Colour.pDeepLightBlue,
//           title: const Text(
//             "Add Invoice",
//             style: TextStyle(
//                 color: Colour.SilverGrey,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600),
//           ),
//           leading: GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: const Icon(
//               Icons.arrow_back_ios,
//               color: Colour.SoftGray,
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: IconButton(
//                 color: Colour.SoftGray,
//                 onPressed: () async {
//                   await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const AddItemScreen(
//                         isEditScreen: false,
//                       ),
//                     ),
//                   );
//                 },
//                 icon: const Icon(Icons.add),
//               ),
//             )
//           ],
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(1.0),
//             child: Container(
//               color: Colour.plightpurple,
//               height: 1.0,
//             ),
//           ),
//         ),
//         body:
//             BlocConsumer<AddItemBloc, AddItemState>(listener: (context, state) {
//           if (state is ItemsFetchErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Error")),
//             );
//           } else if (state is PdfGenerated) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("PDF generated at: ${state.filePath}")),
//             );
//           }
//         }, builder: (context, state) {
//           return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//
//                 /// in the below container
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   color: Colour.pDeepLightBlue,
//                   child: Column(
//                     spacing: 5,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Text("Branch: ${loginResponse.}",
//                       //     style: const TextStyle(color: Colors.white)),
//                       // Text("Invoice No: ${widget.invoiceModel.invoiceNo}",
//                       //     style: const TextStyle(color: Colors.white)),
//                       // Text("Invoice Date: ${widget.invoiceModel.invoiceDate}",
//                       //     style: const TextStyle(color: Colors.white)),
//                       Text(
//                           "Driver Name: ${loginResponse!.userName.isNotEmpty ? loginResponse!.userName : 'N/A'}",
//                           style: const TextStyle(color: Colors.white)),
//                       Row(
//                         children: [
//                           const Text("Discount: ",style: TextStyle(color: Colour.pWhite)),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           CustomDiscountTextField(
//                           // onChanged: (value){
//                           //   discount=int.tryParse(discountAmount.text.trim())??0;
//                           // },
//
//                           controller: discountAmount, label: "amount")
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           const Text("Paid Amount:",style: TextStyle(color: Colour.pWhite),),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           CustomDiscountTextField(
//                               controller: paidAmount, label: "amount"),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           const Text("Payment type:", style:TextStyle(color:Colour.pWhite)),
//                           _buildRadioButton("Cash"),
//                           _buildRadioButton("Bank")
//                         ],
//                       ),
//                       // Text(
//                       //   "Net Total: ₹${totalNet.toStringAsFixed(2)}",
//                       //   style: const TextStyle(color: Colors.white),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: BlocBuilder<AddItemBloc, AddItemState>(
//                   builder: (context, state) {
//                     final items = context.read<AddItemBloc>().addedItems;
//                     if (items.isEmpty) {
//                       return const Center(
//                         child: Text(
//                           "No data",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       );
//                     }
//
//                     return Column(
//                       children: [
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: items.length,
//                             itemBuilder: (context, index) {
//                               final item = items[index];
//                               return Dismissible(
//                                 key: Key(item.productId.toString()),
//                                 background: Container(
//                                   color: Colors.red,
//                                   alignment: Alignment.centerLeft,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20),
//                                   child: const Center(
//                                       child: Icon(Icons.delete,
//                                           color: Colors.white)),
//                                 ),
//                                 secondaryBackground: Container(
//                                   color: Colors.blue,
//                                   alignment: Alignment.centerRight,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20),
//                                   child: const Center(
//                                       child: Icon(Icons.edit,
//                                           color: Colors.white)),
//                                 ),
//                                 confirmDismiss: (direction) async {
//                                   if (direction ==
//                                       DismissDirection.endToStart) {
//                                     await Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => AddItemScreen(
//                                             isEditScreen: true,
//                                             items: item,
//                                             updateIndex: index),
//                                       ),
//                                     );
//                                     return false;
//                                   } else if (direction ==
//                                       DismissDirection.startToEnd) {
//                                     return await deleteDialog(context);
//                                   }
//                                   return false;
//                                 },
//                                 onDismissed: (direction) {
//                                   if (direction ==
//                                       DismissDirection.startToEnd) {
//                                     context
//                                         .read<AddItemBloc>()
//                                         .add(RemoveItem(item));
//                                   }
//                                 },
//                                 child: ItemCard(
//                                   name: item.productName,
//                                   code: index.toString(),
//                                   quantity: item.quantity.toString(),
//                                   srt: item.srt.toString(),
//                                   factor: item.fac.toString(),
//                                   unit: item.uom.toString(),
//                                   sellPrice:
//                                       formatRupees(double.parse(item.sell)),
//                                   total:
//                                       formatRupees(item.totalRate).toString(),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           //: Colors.grey.shade200,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const SizedBox(),
//                               Text(
//
//                                 "Total amount : ${formatRupees(items.fold(0, (sum, item) => (sum + item.totalRate)-discount))}",
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.w400),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//               BlocConsumer<AddItemBloc, AddItemState>(
//                 listener: (context, state) async {
//                   if (state is ItemPostedSuccess) {
//                     SalesInvoice? invoice =
//                         await _orderRepo.getOrder(state.inoviceId);
//                     context.read<AddItemBloc>().add(GeneratePdfEvent(
//                           details: invoice!.mobileAppSalesInvoiceDetails,
//                           name: widget.client.name!,
//                           date: widget.endDate,
//                           invoiceNo: state.inoviceId,
//                         ));
//                     context
//                         .read<AddItemBloc>()
//                         .add(FetchSalesInvoice(state.inoviceId));
//
//                     // Refresh other blocs if needed
//                     context
//                         .read<TotalSalesBloc>()
//                         .add(const TotalSalesGetEvent());
//                     context
//                         .read<StockListBloc>()
//                         .add(const StockListGetEvent());
//                     context
//                         .read<ClientListBloc>()
//                         .add(const ClientListGetEvent());
//
//                     context.read<InvoiceBloc>().add(
//                           FetchInvoiceEvent(
//                             fromDate: widget.fromDate,
//                             endDate: widget.endDate,
//                             partyId: widget.client.id!,
//                             vehicleId: widget.vehicleId,
//                             companyId: widget.companyId,
//                           ),
//                         );
//
// // Then call the callback and pop:
//                     widget.onOrderSaved();
//                     Navigator.pop(context);
//                   }
//                 },
//                 builder: (context, state) {
//                   final items = context.read<AddItemBloc>().addedItems;
//                   return CustomButton(
//                     color: items.isEmpty ? Colors.grey : Colour.pDeepLightBlue,
//                     onPressed: items.isEmpty
//                         ? () {}
//                         : () async {
//                             d.log(locationStatus);
//                             final items =
//                                 context.read<AddItemBloc>().addedItems;
//
//                             SharedPreferences prefs =
//                                 await SharedPreferences.getInstance();
//                             String currentDate =
//                                 DateFormat('yyyy-MM-dd').format(DateTime.now());
//                             String transactionYear =
//                                 DateFormat('yyyy').format(DateTime.now());
//                             LoginModel? storedResponse =
//                                 await GetLoginRepo().getUserLoginResponse();
//
//                             double totalAmount = items.fold(
//                                 0, (sum, item) => sum + item.totalRate);
//
//                             int discountAmt =
//                                 int.tryParse(discountAmount.text) ?? 0;
//                             double discountPercetage =
//                                 (discountAmt / totalAmount) * 100;
//                             setState(() {
//                               nettotal = totalAmount - discountAmt;
//                             });
//                             OrderModel order = OrderModel(
//                                 companyId: storedResponse!.companyId,
//                                 invoiceId: 0,
//                                 clientId: widget.client.id!,
//                                 clientName: widget.client.name!,
//                                 driverId: storedResponse.employeeId,
//                                 driverName: storedResponse.userName,
//                                 payType: paymentType,
//                                 invoiceNo: '',
//                                 invoiceDate: currentDate,
//                                 routeId: storedResponse.routeId,
//                                 vehicleId: storedResponse.vehicleId,
//                                 vehicleNo:
//                                     prefs.getString('selected_vehicle') ?? '',
//                                 total: totalAmount.toInt(),
//                                 discountPercentage: discountPercetage,
//                                 discountAmount: discountAmt,
//                                 netTotal: totalAmount,
//                                 transactionYear: int.parse(transactionYear),
//                                 latitude: latitude ?? 00,
//                                 longitude: longitude ?? 00,
//                                 mobileAppSalesInvoiceDetails: items
//                                     .map(
//                                       (e) => Product.fromJson(e),
//                                     )
//                                     .toList());
//
//                             context
//                                 .read<AddItemBloc>()
//                                 .add(PostAddedItems(order));
//                             showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return const CustomPopup(
//                                     message: "Created Successfully!");
//                               },
//                             );
//                           },
//                     B_text: 'Save Invoice',
//                   );
//                 },
//               ),
//               const SizedBox(
//                 height: 20,
//               )
//             ],
//           );
//         }));
//   }
// }
//

import 'dart:developer' as d;
import 'dart:developer';

import 'package:Yadhava/features/customer/presentation/bloc/last_invoice_bloc/lastinvoice_bloc.dart';
import 'package:Yadhava/features/customer/presentation/pages/Invoice_pages/Invoice_page.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/widget/custom_button.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/widget/delete_pop.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/widget/item_card.dart';
import 'package:Yadhava/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/constants/color.dart';
import '../../../../../core/util/format_rupees.dart';
import '../../../../../core/widget/custom_popup.dart';
import '../../../../auth/data/login_model.dart';
import '../../../../auth/domain/login_repo.dart';
import '../../../../home/presentation/bloc/stockList_bloc/stock_list_bloc.dart';
import '../../../../home/presentation/bloc/totalSales_bloc/bloc/total_sales_bloc.dart';
import '../../../data/client_model.dart';
import '../../../domain/order_repo.dart';
import '../../../model/orderModel.dart';
import '../../bloc/client_bloc/client_list_bloc.dart';
import '../../bloc/inovice_bloc/invoice_bloc.dart';
import '../Invoice_pages/widgets/discount_field.dart';
import '../cash_recept/cash_recept.dart';
import 'add_items.dart';
import 'bloc/add_item_bloc.dart';
import 'model/order_model.dart';

class CustomerDetails extends StatefulWidget {
  final ClientModel client;
  final String fromDate;
  final String endDate;
  final int vehicleId;
  final int companyId;
  final VoidCallback onOrderSaved;
  final int? partyId;

  const CustomerDetails({
    super.key,
    this.partyId,
    required this.client,
    required this.onOrderSaved,
    required this.fromDate,
    required this.endDate,
    required this.vehicleId,
    required this.companyId,
  });

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final OrderRepo _orderRepo = OrderRepo();
  LoginModel? loginResponse;

  TextEditingController discountAmount = TextEditingController();
  TextEditingController discountPercentage = TextEditingController();
  TextEditingController paidAmount = TextEditingController();

  String selectedOption = "Cash";
  String paymentType = 'CASH';

  int discount = 0;
  double nettotal = 0.0;

  bool isExpanded = false;
  bool credit = true;

  @override
  void initState() {
    context.read<LastInvoiceBloc>().add(FetchLastInvoice(widget.partyId!));

    super.initState();
    _getCurrentLocation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddItemBloc>().add(FetchItems());
    });
    getLoginResponse();
    discountAmount.addListener(() {
      setState(() {
        discount = int.tryParse(discountAmount.text.trim()) ?? 0;
      });
    });
  }

  Future<void> getLoginResponse() async {
    loginResponse = await GetLoginRepo().getUserLoginResponse();
    if (mounted) {
      setState(() {}); // Trigger UI update if necessary
    }
  }

  double? latitude;
  double? longitude;
  String locationStatus = "Press the button to get location";

  Future<void> _getCurrentLocation() async {
    try {
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        setState(() {
          locationStatus = "Location services are disabled.";
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            locationStatus = "Location permission denied.";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationStatus =
              "Location permission permanently denied. Enable it from settings.";
        });
        await openAppSettings();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        locationStatus = "Latitude: $latitude, Longitude: $longitude";
      });
    } catch (e) {
      setState(() {
        locationStatus = "Error fetching location: $e";
      });
    }
  }

  Widget _buildRadioButton(String value) {
    return Row(
      children: [
        Radio<String>(
          activeColor: Colour.pWhite,
          focusColor: Colour.pWhite,
          value: value,
          groupValue: selectedOption,
          onChanged: (newValue) {
            setState(() {
              newValue == 'Credit' ? credit = false : credit = true;
              selectedOption = newValue!;
              paymentType = newValue.toUpperCase();
            });
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        Text(value, style: const TextStyle(fontSize: 14, color: Colour.pWhite)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isExpanded) ...[
              FloatingActionButton.small(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvoicePage(
                        client: widget.client,
                        partyId: widget.partyId,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.list_alt),
                heroTag: "fab1",
              ),
              const SizedBox(height: 10),
              FloatingActionButton.small(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CashRecept(
                              clientId: widget.partyId,
                            )),
                  );
                  refreshIndicatorKey.currentState?.show();
                },
                child: const Icon(Icons.receipt_long),
                heroTag: "fab2",
              ),
              const SizedBox(height: 10),
            ],
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Icon(isExpanded ? Icons.close : Icons.menu),
              heroTag: "mainFab",
            ),
          ],
        ),
        backgroundColor: Colour.pBackgroundBlack,
        appBar: AppBar(
          backgroundColor: Colour.pDeepLightBlue,
          title: const Text(
            "Add Invoice",
            style: TextStyle(
                color: Colour.SilverGrey,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colour.SoftGray,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                color: Colour.SoftGray,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddItemScreen(
                        isEditScreen: false,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            )
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colour.plightpurple,
              height: 1.0,
            ),
          ),
        ),
        body: BlocConsumer<AddItemBloc, AddItemState>(
          listener: (context, state) {
            if (state is ItemsFetchErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Error")),
              );
            } else if (state is PdfGenerated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("PDF generated at: ${state.filePath}")),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoicePage(
                    client: widget.client,
                    partyId: widget.partyId ?? 0,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colour.pDeepLightBlue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: 6,
                          children: [
                            Text("Driver Name",
                                style: const TextStyle(color: Colors.white)),
                            Text(":",
                                style: const TextStyle(color: Colors.white)),
                            Text(
                                " \t ${loginResponse != null && loginResponse!.userName.isNotEmpty ? loginResponse!.userName : 'N/A'}",
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        // Visibility(
                        //   visible: credit,
                        //   child: Row(
                        //     spacing: 5,
                        //     children: [
                        //       const Text("Paid Amount",
                        //           style: TextStyle(color: Colour.pWhite)),
                        //       const Text(":",
                        //           style: TextStyle(color: Colour.pWhite)),
                        //       const SizedBox(
                        //         width: 5,
                        //       ),
                        //       CustomDiscountTextField(
                        //           controller: paidAmount, label: "amount"),
                        //     ],
                        //   ),
                        // ),
                        Row(
                          spacing: 6,
                          children: [
                            const Text("Amount",
                                style: TextStyle(color: Colour.pWhite)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .07,
                            ),
                            const Text(":",
                                style: TextStyle(color: Colour.pWhite)),
                            CustomDiscountTextField(
                                controller: discountAmount, label: "discount"),
                            Visibility(
                              visible: credit,
                              child: CustomDiscountTextField(
                                  controller: paidAmount, label: "paid"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Payment type:",
                                style: TextStyle(color: Colour.pWhite)),
                            _buildRadioButton("Cash"),
                            _buildRadioButton("Bank"),
                            _buildRadioButton("Credit")
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<AddItemBloc, AddItemState>(
                    builder: (context, state) {
                      final items = context.read<AddItemBloc>().addedItems;
                      if (items.isEmpty) {
                        return const Center(
                          child: Text(
                            "No data",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Dismissible(
                                  key: Key(item.productId.toString()),
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: const Center(
                                        child: Icon(Icons.delete,
                                            color: Colors.white)),
                                  ),
                                  secondaryBackground: Container(
                                    color: Colors.blue,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: const Center(
                                        child: Icon(Icons.edit,
                                            color: Colors.white)),
                                  ),
                                  confirmDismiss: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddItemScreen(
                                              isEditScreen: true,
                                              items: item,
                                              updateIndex: index),
                                        ),
                                      );
                                      return false;
                                    } else if (direction ==
                                        DismissDirection.startToEnd) {
                                      return await deleteDialog(context);
                                    }
                                    return false;
                                  },
                                  onDismissed: (direction) {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      context
                                          .read<AddItemBloc>()
                                          .add(RemoveItem(item));
                                    }
                                  },
                                  child: ItemCard(
                                    name: item.productName,
                                    code: index.toString(),
                                    quantity: item.quantity.toString(),
                                    srt: item.srt.toString(),
                                    factor: item.foc.toString(),
                                    unit: item.packingName.toString(),
                                    sellPrice:
                                        formatRupees(item.sellingPrice),
                                    total:
                                        formatRupees(item.totalRate).toString(),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total amount : ${formatRupees(items.fold(0.0, (sum, item) => sum + item.totalRate) - discount.toDouble())}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                BlocConsumer<AddItemBloc, AddItemState>(
                  listener: (context, state) async {
                    if (state is ItemPostedSuccess) {
                      SalesInvoice? invoice =
                          await _orderRepo.getOrder(state.inoviceId);
                      context.read<AddItemBloc>().add(GeneratePdfEvent(
                            details: invoice!.mobileAppSalesInvoiceDetails,
                            name: widget.client.name!,
                            date: widget.endDate,
                            invoiceNo: state.inoviceId,
                          ));
                      log("widget.client${state.inoviceId}");
                      context
                          .read<AddItemBloc>()
                          .add(FetchSalesInvoice(state.inoviceId));



                      GetLoginRepo loginRepo = GetLoginRepo();
                      LoginModel? loginModel = await loginRepo.getUserLoginResponse();
                      if (loginModel == null) {
                        throw Exception("User login response is null");
                      }

                      context.read<InvoiceBloc>().add(
                          FetchInvoiceEvent(
                            vehicleId: widget.vehicleId,
                            salesmanId: loginModel.driverId,
                            companyId: loginModel.companyId,
                            clientId: widget.client!.id ?? 0,
                            routeId: loginModel.routeId
                          )
                          );

                      widget.onOrderSaved();
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    final items = context.read<AddItemBloc>().addedItems;
                    return CustomButton(
                      color:
                          items.isEmpty ? Colors.grey : Colour.pDeepLightBlue,
                      onPressed: items.isEmpty
                          ? () {}
                          : () async {
                              d.log(locationStatus);
                              final items =
                                  context.read<AddItemBloc>().addedItems;

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String currentDate = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now());
                              String transactionYear =
                                  DateFormat('yyyy').format(DateTime.now());
                              LoginModel? storedResponse =
                                  await GetLoginRepo().getUserLoginResponse();

                              double totalAmount = items.fold(
                                  0, (sum, item) => sum + item.totalRate);

                              int discountAmt =
                                  int.tryParse(discountAmount.text) ?? 0;
                              double discountPercetage =
                                  (discountAmt / totalAmount) * 100;
                              setState(() {
                                nettotal = totalAmount - discountAmt;
                              });
                              // OrderModel order = OrderModel(
                              //   paidAmount: paidAmount.text.isEmpty
                              //       ? 0
                              //       : double.parse(paidAmount.text),
                              //   companyId: storedResponse!.companyId,
                              //   invoiceId: 0,
                              //   clientId: widget.client.id!,
                              //   clientName: widget.client.name!,
                              //   driverId: storedResponse.employeeId,
                              //   driverName: storedResponse.userName,
                              //   payType: paymentType.toUpperCase(),
                              //   invoiceNo: '',
                              //   invoiceDate: currentDate,
                              //   routeId: storedResponse.routeId,
                              //   vehicleId: storedResponse.vehicleId,
                              //   vehicleNo:
                              //       prefs.getString('selected_vehicle') ?? '',
                              //   total: totalAmount.toInt(),
                              //   discountPercentage: discountPercetage,
                              //   discountAmount: discountAmt,
                              //   netTotal: nettotal,
                              //   transactionYear:
                              //       int.parse(transactionYear) ?? 0000,
                              //   latitude: latitude ?? 00,
                              //   longitude: longitude ?? 00,
                              //   mobileAppSalesInvoiceDetails: items
                              //       .map(
                              //         (e) => Product.fromJson(e),
                              //       )
                              //       .toList(),
                              // );

                              // context
                              //     .read<AddItemBloc>()
                              //     .add(PostAddedItems(order));

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    setState(() {
                                      discountAmount.text = '';
                                    });
                                    Navigator.pop(context);

                                    log("///widget.partyId${widget.partyId}");
                                  });

                                  return const CustomPopup(
                                      message: "Submitted Successfully!");
                                },
                              );
                            },
                      B_text: 'Save Invoice',
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            );
          },
        ));
  }
}
