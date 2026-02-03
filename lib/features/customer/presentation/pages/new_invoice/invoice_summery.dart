// import 'package:Yadhava/core/constants/color.dart';
// import 'package:flutter/material.dart';
//
// class SummeryPage extends StatefulWidget {
//   const SummeryPage({super.key});
//
//   @override
//   State<SummeryPage> createState() => _SummeryPageState();
// }
//
// class _SummeryPageState extends State<SummeryPage> {
//   TextEditingController discountAmount=TextEditingController();
//   TextEditingController paidAmountController=TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colour.pBackgroundBlack,
//       appBar: AppBar(
//         backgroundColor: Colour.pBackgroundBlack,
//         centerTitle: true,
//         title:const Text("Invoice Summery",style: TextStyle(color: Colour.mediumGray),),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           spacing: 10,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//            const SizedBox(height: 5,),
//            SizedBox(
//              height: MediaQuery.of(context).size.height*.3,
//              // width: double.infinity,
//              // decoration: BoxDecoration(
//              //   color: Colour.lightblack,
//              //   shape: BoxShape.rectangle,
//              //   borderRadius: BorderRadius.circular(20)
//              // ),
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                spacing: 6,
//                children: [
//                  const Row(
//                    spacing: 50,
//                    children: [
//                        Text(
//                        'Net Amount',
//                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colour.mediumGray),
//                      ),
//                        Text(
//                        ':',
//                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colour.mediumGray),
//                      ),
//                        Text(
//                        ' 5000',
//                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colour.mediumGray),
//                      ),
//                    ],
//                  ),
//                  const Row(
//                    spacing: 12,
//                    children: [
//                         Text(
//                        'Previous Amount',
//                        style: TextStyle(fontSize: 16,color: Colour.mediumGray ),
//                      ),
//                         Text(
//                        ':',
//                        style: TextStyle(fontSize: 16,color: Colour.mediumGray ),
//                      ),
//                         Text(
//                        '500',
//                        style: TextStyle(fontSize: 16,color: Colour.mediumGray ),
//                      ),
//                    ],
//                  ),
//                  Row(
//                    children: [
//                     const  Text(
//                        'Amount To Be Paid',
//                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colour.mediumGray),
//                      ),
//                    const  Text(
//                        ':',
//                        style:  TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colour.mediumGray),
//                      ),
//                      Text(
//                        (500- (double.tryParse(paidAmountController.text) ?? 0.0)).toStringAsFixed(2),
//                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colour.mediumGray),
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//            ),
//             Container(
//               height: MediaQuery.of(context).size.height*.3,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   color: Colour.lightblack,
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.circular(20)
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                 child: Column(
//                   spacing: 6,
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     TextField(
//                       style: const TextStyle(color: Colour.mediumGray),
//                       keyboardType: TextInputType.number,
//                       decoration: InputDecoration(
//                         fillColor: Colour.blackgery,
//                         filled: true,
//                         labelText: 'Discount Amount',
//                         labelStyle: const TextStyle(color: Colour.darkgrey),
//                         hintText: 'Enter discount amount',
//                         prefixIcon: const Icon(Icons.money_off),
//
//                         // Default border
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                             color: Colors.grey,
//                             width: 1.5,
//                           ),
//                         ),
//
//                         // Border when enabled but not focused
//                         // enabledBorder: OutlineInputBorder(
//                         //   borderRadius: BorderRadius.circular(12),
//                         //   borderSide: const BorderSide(
//                         //     color: Colors.blue,
//                         //     width: 1.5,
//                         //   ),
//                         // ),
//
//                         // Border when focused
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                             color: Colour.plightpurple,
//                             width: 2,
//                           ),
//                         ),
//
//                         // Border when in error state
//                         errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                             color: Colors.red,
//                             width: 1.5,
//                           ),
//                         ),
//
//                         // Border when focused in error state
//                         // focusedErrorBorder: OutlineInputBorder(
//                         //   borderRadius: BorderRadius.circular(12),
//                         //   borderSide: const BorderSide(
//                         //     color: Colors.red,
//                         //     width: 2,
//                         //   ),
//                         // ),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           // discountAmount.text = double.tryParse(value) ?? 0.0;
//                         });
//                       },
//                     ),
//
//                     TextField(
//                       style:const TextStyle(color: Colour.mediumGray),
//                       controller: paidAmountController,
//                       keyboardType: TextInputType.number,
//                       decoration:const InputDecoration(
//                         labelStyle: TextStyle(color: Colour.darkgrey),
//                         labelText: 'Paid Amount',
//                         hintText: 'Enter paid amount',
//                         prefixIcon: Icon(Icons.payment),
//                       ),
//                       onChanged: (value) {
//                         setState(() {
//                           // You can store and use this value to calculate remaining balance if necessary
//                         });
//                       },
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//
//             const Text(
//               'Total Amount: \$ 200',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colour.mediumGray),
//             ),
//             // Text(
//             //   'Paid Amount: \$${paidAmountController.text.isNotEmpty ? paidAmountController.text : "0.00"}',
//             //   style: const TextStyle(fontSize: 16,color: Colour.mediumGray),
//             // ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height*.01,
//             ),
//             Center(
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width*.8,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colour.plightpurple, // Background color
//                     foregroundColor: Colors.white, // Text color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20), // Rounded corners
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Button padding
//                     elevation: 4, // Shadow size
//                   ),
//                   onPressed: () {
//                     print('Button Pressed');
//                   },
//                   child: const Text('Save Invoice'),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/core/util/format_rupees.dart';
import 'package:Yadhava/features/customer/presentation/bloc/client_bloc/client_list_bloc.dart';
import 'package:Yadhava/features/customer/presentation/bloc/inovice_bloc/invoice_bloc.dart';
import 'package:Yadhava/features/customer/presentation/pages/Invoice_pages/Invoice_page.dart';
import 'package:Yadhava/features/home/presentation/bloc/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../auth/data/login_model.dart';
import '../../../../auth/domain/login_repo.dart';
import '../../../data/client_model.dart';
import '../customer_details/bloc/add_item_bloc.dart';
import '../customer_details/model/addItem_model.dart';
import '../customer_details/model/order_model.dart';

class SummeryPage extends StatefulWidget {
  final ClientModel client;

  final List selectedItemList;
  const SummeryPage({
    super.key,
    required this.selectedItemList,
    required this.client,
  });

  @override
  State<SummeryPage> createState() => _SummeryPageState();
}

class _SummeryPageState extends State<SummeryPage> {
  final TextEditingController discountAmount = TextEditingController();
  final TextEditingController paidAmountController = TextEditingController();

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  late String endDate;
  late String fromDate;

  int vehicleId = 0;
  int companyId = 0;
  bool isDataFetched = false;
  double netTotal = 0.0;
  double amountToBePaid = 0;
  double previousAmount = 0.0;
  double mediaHeight = 0.56;

  double totalAmount = 0;
  String selectedOption = "Cash";
  bool credit = true;
  String paymentType = 'CASH';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    previousAmount = widget.client.amount!;
    _getCurrentLocation();
    calculation();

    fromDate = _getFromDate(15);
    endDate = _getEndDate();
    _getLoginResponse();
  }

  calculation() {
    int count = widget.selectedItemList.length;
    for (int i = 0; i < count; i++) {
      var item = widget.selectedItemList[i] as ProductItem;
      print(item.totalRate);
      totalAmount += item.totalRate;
    }
    netTotal = totalAmount;
    amountToBePaid = netTotal + (widget.client.amount ?? 0);
  }

  double? latitude;
  double? longitude;
  String locationStatus = "Press the button to get location";

  Future<void> _getLoginResponse() async {
    try {
      LoginModel? storedResponse = await GetLoginRepo().getUserLoginResponse();
      if (storedResponse != null) {
        this.vehicleId = storedResponse.vehicleId;
        this.companyId = storedResponse.companyId;
      }
    } catch (e) {
      setState(() {
        locationStatus = "Error fetching storedResponse: $e";
      });
    }
  }

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

  String _getEndDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  String _getFromDate(int daysAgo) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: daysAgo)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddItemBloc, AddItemState>(
      listener: (context, state) async {
        if (state is ItemPostedSuccess) {
          // ✅ Refresh Client List

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Saved Successfully"),
              backgroundColor: Colors.green,
            ),
          );
          await Future.delayed(const Duration(seconds: 1));
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => InvoicePage(
                  client: widget.client,
                  partyId: widget.client.id,
                ),
              ),
              (route) => false, // Clear back stack
            );
          }
        } else if (state is SalesInvoiceSaving) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is ItemsFetchErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed: ${state.error}"),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is ItemsFetchErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colour.pBackgroundBlack,
        appBar: AppBar(
          backgroundColor: Colour.pBackgroundBlack,
          centerTitle: true,
          title: const Text(
            "Invoice Summery",
            style: TextStyle(color: Colour.mediumGray),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummarySection(),
                  const SizedBox(height: 10),
                  const SizedBox(height: 50),
                  _buildSaveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
              print('chk state');
              newValue == 'Credit' ? credit = false : credit = true;
              if (newValue == 'Credit') {
                paidAmountController.clear();
              }
              selectedOption = newValue!;
              //paidAmountController.clear();
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

  /// Summary Section
  Widget _buildSummarySection() {
    print(credit.toString());
    //paidAmountController.clear();
    return Container(
      decoration: BoxDecoration(
          color: Colour.lightblack,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20)),
      height: MediaQuery.of(context).size.height * mediaHeight,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          spacing: 5,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryRow(
                'Total Item', widget.selectedItemList.length.toString()),
            _buildSummaryRow('Total Amount', formatRupees(totalAmount)),
            const SizedBox(height: 10),
            _buildTextFieldDecimal(
              onChanged: (value) {
                setState(() {
                  // netTotal=totalAmount-double.parse(value);
                  // amountToBePaid=netTotal+previousAmount;
                  double discount = double.tryParse(value) ?? 0.0;
                  netTotal = totalAmount - discount;
                  amountToBePaid = netTotal + previousAmount;
                });
              },
              controller: discountAmount,
              label: 'Discount Amount',
              hint: 'Enter discount amount',
              icon: Icons.currency_rupee,
            ),
            const SizedBox(height: 10),
            _buildSummaryRow('Net Total', formatRupees(netTotal)),
            _buildSummaryRow(
                'Previous Balance', formatRupees(widget.client.amount!)),
            _buildSummaryRow('Amount to be Paid', formatRupees(amountToBePaid)),
            const SizedBox(height: 10),
            Visibility(
              visible: credit,
              child: _buildTextFieldDecimal(
                validator: (value) {
                  if (credit) {
                    if (value == null || value.isEmpty) {
                      setState(() {
                        mediaHeight = 0.57;
                      });
                      return "Amount Required";
                    }
                  }
                  return null;
                },
                controller: paidAmountController,
                label: 'Paid Amount',
                hint: 'Enter paid amount',
                icon: Icons.payment,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 10),
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
    );
  }

  /// Row for Summary Details
  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3, // Adjust flex value based on alignment requirements
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colour.mediumGray,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Text(
            ':',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colour.mediumGray,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colour.mediumGray,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Custom TextField
  Widget _buildTextField({
    final String? Function(String?)? validator,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      style: const TextStyle(color: Colour.mediumGray),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        fillColor: Colour.blackgery,
        filled: true,
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colour.darkgrey),
        labelStyle: const TextStyle(color: Colour.darkgrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colour.plightpurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildTextFieldDecimal({
    final String? Function(String?)? validator,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      validator: validator,
      controller: controller,
      style: const TextStyle(color: Colour.mediumGray),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,4}')),
      ],
      decoration: InputDecoration(
        fillColor: Colour.blackgery,
        filled: true,
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colour.darkgrey),
        labelStyle: const TextStyle(color: Colour.darkgrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colour.plightpurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      onChanged: onChanged,
    );
  }

  /// Save Button
  Widget _buildSaveButton() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colour.plightpurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            elevation: 4,
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              showPopup(context); // Show the confirmation popup
            }
          },
          child: const Text('Save Invoice'),
        ),
      ),
    );
  }

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Save Invoice"),
          content: const Text("Do you want to save this invoice?"),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colour.pDeepDarkBlue),
              ),
            ),

            // Save Button (Processes in the background)
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext)
                    .pop(); // Close the dialog immediately

                // Fetch added items
                final items = context.read<AddItemBloc>().addedItems;

                // Convert selected items to product list
                List<Product> productList = widget.selectedItemList.map((item) {
                  if (item is ProductItem) {
                    return Product.fromJson({
                      'siNo': 0,
                      'productId': item.productId,
                      'partNumber': item.partNumber.toString(),
                      'productName': item.productName,
                      'packingDescription': item.packingDescription,
                      'packingId': item.packingId,
                      'packingName': item.packingName,
                      'quantity': item.quantity,
                      'foc': int.tryParse(item.fac.toString() ?? '0') ?? 0,
                      'totalQty': item.quantity,
                      'unitRate':
                          double.tryParse(item.sell?.toString() ?? '0.0') ??
                              0.0,
                      'totalRate': item.totalRate,
                      'srtQty': int.tryParse(item.srt?.toString() ?? '0') ?? 0,
                      'uom': item.uom?.toString() ?? '',
                    });
                  }
                  throw Exception("Invalid type");
                }).toList();

                // Calculate discount details
                double discountAmt = double.tryParse(discountAmount.text) ?? 0;
                double discountPercentage = (discountAmt / totalAmount) * 100;

                // Get stored user data
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String currentDate =
                    DateFormat('yyyy-MM-dd').format(DateTime.now());
                String transactionYear =
                    DateFormat('yyyy').format(DateTime.now());
                LoginModel? storedResponse =
                    await GetLoginRepo().getUserLoginResponse();

                // Prepare order model
                OrderModel order = OrderModel(
                  id: 0,
                  uuid: '',
                  paidAmount: paidAmountController.text.isEmpty
                      ? 0
                      : double.parse(paidAmountController.text),
                  companyId: storedResponse!.companyId,
                  invoiceId: 0,
                  clientId: widget.client.id!,
                  clientName: widget.client.name!,
                  driverId: storedResponse.employeeId,
                  driverName: storedResponse.userName,
                  payType: paymentType.toUpperCase(),
                  invoiceNo: '',
                  invoiceDate: currentDate,
                  routeId: storedResponse.routeId,
                  vehicleId: storedResponse.vehicleId,
                  vehicleNo: prefs.getString('selected_vehicle') ?? '',
                  total: totalAmount,
                  discountPercentage: discountPercentage,
                  discountAmount: discountAmt,
                  netTotal: netTotal,
                  transactionYear: int.parse(transactionYear),
                  latitude: latitude ?? 00,
                  longitude: longitude ?? 00,
                  mobileAppSalesInvoiceDetails: productList,
                );

                // final clientListBloc = context.read<ClientListBloc>();
                // final homeBloc = context.read<HomeBloc>();
                final addItemBloc = context.read<AddItemBloc>();

                addItemBloc.add(PostAddedItems(order));

                print('Save process completed');
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colour.pDeepDarkBlue),
              ),
            ),
          ],
        );
      },
    );
  }
}
