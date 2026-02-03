// import 'package:Yadhava/core/constants/color.dart';
// import 'package:Yadhava/core/util/format_rupees.dart';
// import 'package:Yadhava/features/customer/model/InvoiceModel.dart';
// import 'package:Yadhava/features/customer/model/last_invoice_model.dart';
// import 'package:Yadhava/features/customer/presentation/bloc/last_invoice_bloc/lastinvoice_bloc.dart';
// import 'package:Yadhava/features/customer/presentation/bloc/update_invoice/update_invoice_state.dart';
// import 'package:Yadhava/features/customer/presentation/pages/Invoice_pages/widgets/CustomAlert.dart';
// import 'package:Yadhava/features/customer/presentation/pages/Invoice_pages/widgets/add_item_popup.dart';
// import 'package:Yadhava/features/customer/presentation/pages/Invoice_pages/widgets/discount_field.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../bloc/update_invoice/update_invoice_bloc.dart';
// import '../../bloc/update_invoice/update_invoice_event.dart';
// import '../customer_details/add_items.dart';
// import '../customer_details/bloc/add_item_bloc.dart';
// import '../customer_details/widget/custom_dropdown.dart';
// import '../customer_details/widget/custom_feild.dart';
//
// class LastInvoiceDetailsPage extends StatefulWidget {
//
// final int partyId;
//   const LastInvoiceDetailsPage({
//     super.key, required this.partyId,
//
//   });
//
//   @override
//   _InvoiceDetailsPageState createState() => _InvoiceDetailsPageState();
// }
//
// class _InvoiceDetailsPageState extends State<LastInvoiceDetailsPage> {
//   TextEditingController discountAmount = TextEditingController();
//   TextEditingController discountPercentage = TextEditingController();
//   TextEditingController paidAmount = TextEditingController();
//   final TextEditingController textController = TextEditingController();
//   late String selectedOption;
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController qtyController = TextEditingController(text: '1');
//   final TextEditingController focController = TextEditingController(text: '0');
//   final TextEditingController srtController = TextEditingController(text: '0');
//   final TextEditingController unitRateController =
//       TextEditingController(text: '0');
//   final TextEditingController sellingController = TextEditingController();
//   final TextEditingController totalController = TextEditingController();
//
//   String? selectedItem;
//   String? selectedUOM;
//   String? uomInitialValue;
//   List<String> uomItems = [];
//   Map<String, dynamic> selectedItemData = {};
//
//   late List<MobileAppSalesInvoiceDetails> details;
//   double totalNet = 0.0;
//
//   @override
//   void initState() {
//     discountAmount.addListener((){
//       String text=discountAmount.text;
//       if(text.isEmpty){
//         discountAmount.text='0';
//         discountAmount.selection=TextSelection.fromPosition(TextPosition(offset: discountAmount.text.length));
//       }else if(!text.startsWith('0')){
//         discountAmount.text='0$text';
//         discountAmount.selection=TextSelection.fromPosition(TextPosition(offset: discountAmount.text.length));
//       }
//     });
//     super.initState();
//     context.read<AddItemBloc>().add(FetchItems());
//     context.read<LastInvoiceBloc>().add(FetchLastInvoice(widget.partyId));
//
//     _calculateTotalNet(details);
//   }
//
//   void _calculateTotalNet(List<MobileAppSalesInvoiceDetails> details) {
//     double sum = 0.0;
//     for (var item in details) {
//       sum += item.totalRate;
//     }
//     setState(() {
//       totalNet = sum - double.parse(discountAmount.text);
//     });
//   }
//
//   String convertPaymentType(String payType) {
//     if (payType == "CASH") {
//       return "Cash";
//     } else if (payType == "BANK") {
//       return "Bank";
//     } else {
//       return "Cash";
//     }
//   }
//
//   String reConvertPaymentType(String payType) {
//     if (payType == "Cash") {
//       return "CASH";
//     } else if (payType == "Bank") {
//       return "BANK";
//     } else {
//       return "CASH";
//     }
//   }
//
//   void editItem(int index, MobileAppSalesInvoiceDetails updatedItem) {
//     setState(() {
//       details[index] = updatedItem;
//     });
//     _calculateTotalNet(details);
//   }
//
//   void deleteItem(MobileAppSalesInvoiceDetails item) {
//     setState(() {
//       details.remove(item);
//     });
//     _calculateTotalNet(details);
//   }
//
//   void saveOrder(BuildContext context,List<MobileAppSalesInvoiceDetails> invoiceDetails,int dcntamt ) {
//     showPopup(context,invoiceDetails, dcntamt); // Show the confirmation popup
//   }
//
//   void showPopup(BuildContext context,List<MobileAppSalesInvoiceDetails> invoiceDetail,int discountamnt ) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Save Invoice"),
//           content: const Text("Do you want to save this invoice?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 "No",
//                 style: TextStyle(color: Colour.pDeepDarkBlue),
//               ),
//             ),
//             BlocListener<UpdateInvoiceBloc, UpdateInvoiceState>(
//               listener: (context, state) {
//                 if (state is UpdateInvoiceLoading) {
//                   showDialog(
//                     barrierDismissible: false,
//                     context: context,
//                     builder: (context) => const Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   );
//                 } else if (state is UpdateInvoiceSuccess) {
//                   Navigator.of(context).pop(); // Close the loading dialog
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                         content: Text("Invoice updated successfully!")),
//                   );
//
//                   Future.delayed(const Duration(seconds: 1), () {
//                     Navigator.pop(context);
//                     Navigator.pop(context);
//                   });
//
//                   // Refresh the page by calling setState
//                   setState(() {
//                     ///-------------------------------------------------------
//                     // Trigger a refresh by re-initializing the invoice data
//                     discountAmount.text =
//                         discountamnt.toString()??'0.0';
//                     details = List.from(invoiceDetail);
//                     _calculateTotalNet(details);
//                   });
//                 } else if (state is UpdateInvoiceFailure) {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pop();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text("Failed to update invoice: ${state.error}"),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               },
//               child: TextButton(
//                 onPressed: () {
//                   // Logic to update the invoice
//                   if (totalNet != 0 &&
//                       totalNet - double.parse(discountAmount.text) != 0) {
//                     var updatedInvoice =
//                         invoiceDetail.copyWith(details: details);
//                     updatedInvoice = updatedInvoice.copyWith(
//                         discountAmount: discountAmount.text == ''
//                             ? 0.0
//                             : double.parse(discountAmount.text),
//                         payType: reConvertPaymentType(selectedOption),
//                         total: totalNet + double.parse(discountAmount.text),
//                         netTotal: totalNet);
//
//                     context.read<UpdateInvoiceBloc>().add(
//                           SubmitUpdateInvoice(updatedInvoice: updatedInvoice),
//                         );
//
//                     // Close the popup
//                     // Navigator.of(context).pop();
//                   } else {
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text(" Cannot ave without any item")),
//                     );
//                   }
//                 },
//                 child: const Text("Yes",
//                     style: TextStyle(color: Colour.pDeepDarkBlue)),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _buildRadioButton(String value) {
//     return Row(
//       children: [
//         Radio<String>(
//           activeColor: Colour.pWhite,
//           focusColor: Colour.pWhite,
//           value: value,
//           groupValue: selectedOption,
//           onChanged: (newValue) {
//             setState(() {
//               selectedOption = newValue!;
//             });
//           },
//           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//           visualDensity: VisualDensity.compact,
//         ),
//         Text(value, style: const TextStyle(fontSize: 14, color: Colour.pWhite)),
//       ],
//     );
//   }
//
//   addItemPopup() {
//     return AlertDialog(
//       backgroundColor: Colour.pBackgroundBlack,
//       title: const Text("Add Item", style: TextStyle(color: Colour.SilverGrey)),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               BlocBuilder<AddItemBloc, AddItemState>(
//                 builder: (context, state) {
//                   if (state is ItemsFetchedState) {
//                     final items = state.items
//                         .map((item) => item['productName'].toString())
//                         .toList();
//                     return ReusableDropdown(
//                       label: "Item",
//                       hintText: "Select Item",
//                       items: items,
//                       onChanged: (value) {
//                         setState(() {
//                           selectedItem = value;
//                           selectedItemData = state.items.firstWhere(
//                             (item) => item['productName'] == value,
//                             orElse: () => {},
//                           );
//                           sellingController.text =
//                               selectedItemData['sellingPrice']?.toString() ??
//                                   '0';
//                           totalController.text = sellingController.text;
//                           uomInitialValue =
//                               selectedItemData['packingName']?.toString() ??
//                                   'N/A';
//                           // unitRateController.text=sellingController[]?.
//                           uomItems = [uomInitialValue!];
//                         });
//                       },
//                     );
//                   } else if (state is ItemsFetchErrorState) {
//                     return Text(state.error,
//                         style: const TextStyle(color: Colors.red));
//                   } else {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                 },
//               ),
//               const SizedBox(height: 16),
//               ReusableVoucherTextField(
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$'))
//                 ],
//                 onChanged: (qt) {
//                   int srtCount = int.tryParse(srtController.text) ?? 0;
//                   double totalPrice =
//                       (double.tryParse(sellingController.text) ?? 0) *
//                               (double.tryParse(qt) ?? 0) -
//                           (srtCount *
//                               (double.tryParse(sellingController.text) ?? 0));
//                   totalController.text = totalPrice.toStringAsFixed(2);
//                 },
//                 keyboardType: TextInputType.number,
//                 label: "Quantity",
//                 controller: qtyController,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter quantity' : null,
//                 hintText: '',
//               ),
//               const SizedBox(height: 16),
//               ReusableVoucherTextField(
//                 keyboardType: TextInputType.number,
//                 label: "FOC",
//                 controller: focController,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$'))
//                 ],
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter FOC' : null,
//                 hintText: '',
//               ),
//               const SizedBox(height: 16),
//               ReusableVoucherTextField(
//                 onChanged: (srt) {
//                   int quantity = int.tryParse(qtyController.text) ?? 0;
//                   double totalPrice =
//                       ((double.tryParse(sellingController.text) ?? 0) *
//                               quantity) -
//                           ((double.tryParse(sellingController.text) ?? 0) *
//                               (double.tryParse(srt) ?? 0));
//                   totalController.text = totalPrice.toStringAsFixed(2);
//                 },
//                 keyboardType: TextInputType.number,
//                 label: "SRT",
//                 controller: srtController,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter SRT' : null,
//                 hintText: '',
//               ),
//               const SizedBox(height: 16),
//               ReusableVoucherTextField(
//                 onChanged: (price) {
//                   int srtCount = int.tryParse(srtController.text) ?? 0;
//                   double totalPrice =
//                       (double.tryParse(qtyController.text) ?? 0) *
//                               (double.tryParse(price) ?? 0) -
//                           (srtCount * (double.tryParse(price) ?? 0));
//                   totalController.text = totalPrice.toStringAsFixed(2);
//                 },
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$'))
//                 ],
//                 keyboardType: TextInputType.number,
//                 label: "Unit Rate",
//                 controller: sellingController,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter Unit Price' : null,
//                 hintText: '',
//               ),
//               ReusableVoucherTextField(
//                 onChanged: (srt) {
//                   int quantity = int.tryParse(qtyController.text) ?? 0;
//                   double totalPrice =
//                       ((double.tryParse(sellingController.text) ?? 0) *
//                               quantity) -
//                           ((double.tryParse(sellingController.text) ?? 0) *
//                               (double.tryParse(srt) ?? 0));
//                   totalController.text = totalPrice.toStringAsFixed(2);
//                 },
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$'))
//                 ],
//                 keyboardType: TextInputType.number,
//                 label: "Total",
//                 controller: totalController,
//                 validator: (value) =>
//                     value!.isEmpty ? 'Please enter SRT' : null,
//                 hintText: '',
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel", style: TextStyle(color: Colors.red)),
//         ),
//         TextButton(
//           onPressed: () {
//             int index = details.length ?? 0;
//             if (_formKey.currentState!.validate()) {
//               MobileAppSalesInvoiceDetails newItem =
//                   MobileAppSalesInvoiceDetails(
//                 productName: selectedItem ?? '',
//                 quantity: double.parse(qtyController.text) ?? 0,
//                 foc: double.parse(focController.text) ?? 0.0,
//                 srtQty: double.parse(srtController.text) ?? 0.0,
//                 totalRate: double.parse(totalController.text),
//                 siNo: index,
//                 /*selectedItemData['siNo']??0,*/
//                 productId: selectedItemData['productId'],
//                 partNumber: selectedItemData['partNumber'],
//                 packingDescription: selectedItemData['packingDescription'],
//                 packingId: selectedItemData['packingId'],
//                 packingName: selectedItemData['packingName'],
//                 totalQty: double.parse(totalController.text) ?? 0.0,
//                 unitRate: double.parse(sellingController.text) ?? 0.0,
//               );
//               print(details.length);
//               setState(() {
//                 details.add(newItem);
//                 totalController.text = '0.0';
//                 totalController.text = '0.0';
//                 srtController.text = '0.0';
//               });
//               print(details.length);
//             }
//
//             Navigator.pop(context);
//           },
//           child: const Text("Add", style: TextStyle(color: Colors.green)),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LastInvoiceBloc, LastInvoiceState>(
//       builder: (context, state) {
//         if (state is LastInvoiceLoading) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state is LastInvoiceLoaded) {
//           final result = state.invoice;
//           details = List.from(state.invoice.mobileAppSalesInvoiceDetails);
//           return Scaffold(
//             backgroundColor: Colour.pBackgroundBlack,
//             appBar: AppBar(
//               centerTitle: true,
//               backgroundColor: Colour.pDeepLightBlue,
//               title: Text(
//                 result.vehicleNo.isNotEmpty
//                     ? result.vehicleNo
//                     : "No Vehicle Info",
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ),
//             body: Column(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   color: Colour.pDeepLightBlue,
//                   child: Column(
//                     spacing: 5,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         spacing: 6,
//                         children: [
//                           Text("Branch: ${result.vehicleNo}",
//                               style: const TextStyle(color: Colors.white)),
//                           const Text(
//                             '/',
//                             style: TextStyle(color: Colour.pWhite),
//                           ),
//                           Text(
//                               "Driver Name: ${result.driverName.isNotEmpty ? result.driverName : 'N/A'}",
//                               style: const TextStyle(color: Colors.white)),
//                         ],
//                       ),
//                       Text("Invoice No: ${result.invoiceNo}",
//                           style: const TextStyle(color: Colors.white)),
//                       Text("Invoice Date: ${result.invoiceDate}",
//                           style: const TextStyle(color: Colors.white)),
//
//                       Row(
//                         children: [
//                           const Text(
//                             "Discount: ",
//                             style: TextStyle(color: Colour.pWhite),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           // CustomDiscountTextField(controller: discountPercentage, label: "%"),
//                           CustomDiscountTextField(
//                             controller: discountAmount,
//                             label: "amount",
//                             onChanged: (value) {
//                               if (value.trim().isNotEmpty) {
//                                 // widget.invoiceModel
//                                 //     .copyWith(discountAmount: double.parse(value));
//                                 _calculateTotalNet(details);
//                               }
//                             },
//                           )
//                         ],
//                       ),
//                       // Row(children: [
//                       //   const Text("Paid Amount:"), CustomDiscountTextField(controller: paidAmount, label: "amount"),
//                       // ],),
//                       Row(
//                         children: [
//                           const Text(
//                             "Payment type:",
//                             style: TextStyle(color: Colour.pWhite),
//                           ),
//                           _buildRadioButton("Cash"),
//                           _buildRadioButton("Bank"),
//                           _buildRadioButton("Credit"),
//                         ],
//                       ),
//                       Text(
//                         "Net Total: ₹${totalNet.toStringAsFixed(2)}",
//                         style: const TextStyle(color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: details.length,
//                     itemBuilder: (context, index) {
//                       final detail = details[index];
//                       return ItemTile(
//                         detail: detail,
//                         onEdit: (updatedDetail) =>
//                             editItem(index, updatedDetail),
//                         onDelete: () {
//                           deleteItem(detail);
//                           Navigator.pop(context);
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(16),
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colour.pDeepLightBlue,
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                     ),
//                     onPressed: () => saveOrder(
//                       context,details, result.discountAmount
//                     ),
//                     child: const Text("Save Invoice",
//                         style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         } else if (state is LastInvoiceError) {
//           return Center(
//             child: Text("Something Went Wrong"),
//           );
//         } else {
//           return Container();
//         }
//       },
//     );
//   }
// }
// //
// // class ItemTile extends StatelessWidget {
// //   final MobileAppSalesInvoiceDetails detail;
// //   final Function(MobileAppSalesInvoiceDetails) onEdit;
// //   final VoidCallback onDelete;
// //
// //   const ItemTile({
// //     super.key,
// //     required this.detail,
// //     required this.onEdit,
// //     required this.onDelete,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //       padding: const EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.grey[900],
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Expanded(
// //                 child: Text(
// //                   "Product: ${detail.productName}",
// //                   style: const TextStyle(color: Colors.white, fontSize: 16),
// //                 ),
// //               ),
// //               Text(
// //                 "Code: ${detail.partNumber}",
// //                 style: const TextStyle(color: Colors.white70),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 8),
// //           Row(
// //             children: [
// //               _buildDetailColumn("Qty", detail.quantity.toStringAsFixed(2)),
// //               const SizedBox(width: 10),
// //               _buildDetailColumn("FOC", detail.foc.toStringAsFixed(2)),
// //               const SizedBox(width: 10),
// //               _buildDetailColumn("SRT", detail.srtQty.toStringAsFixed(2)),
// //               const SizedBox(width: 10),
// //               _buildDetailColumn("UOM", detail.packingName),
// //               const SizedBox(width: 10),
// //               _buildDetailColumn(
// //                   "Unit Rate", detail.unitRate.toStringAsFixed(2)),
// //               const SizedBox(width: 10),
// //               Expanded(
// //                   child: _buildDetailColumn(
// //                       "Total", formatRupees(detail.totalRate))),
// //             ],
// //           ),
// //           const SizedBox(height: 8),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.end,
// //             children: [
// //               IconButton(
// //                 icon: const Icon(Icons.edit, color: Colors.white),
// //                 onPressed: () async {
// //                   final updatedItem =
// //                       await showDialog<MobileAppSalesInvoiceDetails>(
// //                     context: context,
// //                     builder: (context) => _EditItemDialog(item: detail),
// //                   );
// //                   if (updatedItem != null) onEdit(updatedItem);
// //                 },
// //               ),
// //               IconButton(
// //                 icon: const Icon(Icons.delete, color: Colors.red),
// //                 onPressed: () {
// //                   showCustomAlert(
// //                     context: context,
// //                     button1Text: 'No',
// //                     button2Text: 'Yes',
// //                     onButton1Press: () => Navigator.pop(context),
// //                     onButton2Press: onDelete,
// //                   );
// //                 },
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDetailColumn(String label, String value) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label,
// //             style: const TextStyle(color: Colors.white70, fontSize: 12)),
// //         Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
// //       ],
// //     );
// //   }
// // }
// //
// // class _EditItemDialog extends StatefulWidget {
// //   final MobileAppSalesInvoiceDetails item;
// //
// //   const _EditItemDialog({super.key, required this.item});
// //
// //   @override
// //   __EditItemDialogState createState() => __EditItemDialogState();
// // }
// //
// // class __EditItemDialogState extends State<_EditItemDialog> {
// //   late TextEditingController quantityController;
// //   late TextEditingController unitRateController;
// //   late TextEditingController focController;
// //   late TextEditingController srtController;
// //   late TextEditingController packingNameController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     quantityController =
// //         TextEditingController(text: widget.item.quantity.toString());
// //     unitRateController =
// //         TextEditingController(text: widget.item.unitRate.toString());
// //     focController = TextEditingController(text: widget.item.foc.toString());
// //     srtController = TextEditingController(text: widget.item.srtQty.toString());
// //     packingNameController =
// //         TextEditingController(text: widget.item.packingName);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return AlertDialog(
// //       title: const Text("Edit Item",
// //           style: TextStyle(color: Colour.pDeepDarkBlue)),
// //       content: SingleChildScrollView(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             TextField(
// //               controller: quantityController,
// //               decoration: const InputDecoration(labelText: "Quantity"),
// //               keyboardType: TextInputType.number,
// //               onChanged: (value) {
// //                 double quantity = double.tryParse(value) ??
// //                     1; // Defaults to 1 if null/invalid
// //                 if (quantity < 1) {
// //                   quantity = 1; // Ensure quantity is at least 1
// //                   quantityController.text =
// //                       '1'; // Update the text field with valid value
// //                   quantityController.selection = TextSelection.fromPosition(
// //                     TextPosition(offset: quantityController.text.length),
// //                   );
// //                 }
// //
// //                 // final totalRate = quantity * double.parse(widget.item.unitRate.toString());
// //                 // unitRateController.text = totalRate.toStringAsFixed(2);
// //               },
// //             ),
// //             TextField(
// //               controller: focController,
// //               decoration: const InputDecoration(labelText: "FOC"),
// //               keyboardType: TextInputType.number,
// //             ),
// //             TextField(
// //               controller: srtController,
// //               decoration: const InputDecoration(labelText: "SRT"),
// //               keyboardType: TextInputType.number,
// //               onChanged: (value) {
// //                 if (value.isNotEmpty) {
// //                   double quantity = double.tryParse(value) ??
// //                       0; // Defaults to 1 if null/invalid
// //                   if (quantity < 0) {
// //                     quantity = 0; // Ensure quantity is at least 1
// //                     srtController.text =
// //                         '0'; // Update the text field with valid value
// //                     srtController.selection = TextSelection.fromPosition(
// //                       TextPosition(offset: srtController.text.length),
// //                     );
// //                   }
// //                 } else {
// //                   srtController.text = '0';
// //                 }
// //               },
// //             ),
// //             TextField(
// //               controller: packingNameController,
// //               decoration: const InputDecoration(labelText: "UOM"),
// //             ),
// //             TextField(
// //               controller: unitRateController,
// //               decoration: const InputDecoration(labelText: "Unit Rate"),
// //               keyboardType: TextInputType.number,
// //             ),
// //           ],
// //         ),
// //       ),
// //       actions: [
// //         TextButton(
// //           onPressed: () => Navigator.pop(context),
// //           child: const Text("Cancel",
// //               style: TextStyle(color: Colour.pDeepDarkBlue)),
// //         ),
// //         TextButton(
// //           onPressed: () {
// //             final updatedItem = widget.item.copyWith(
// //                 quantity: double.parse(quantityController.text),
// //                 foc: double.parse(focController.text),
// //                 packingName: packingNameController.text,
// //                 unitRate: double.parse(unitRateController.text),
// //                 totalRate: (double.parse(quantityController.text) *
// //                         double.parse(unitRateController.text)) -
// //                     (double.parse(srtController.text) *
// //                         double.parse(unitRateController.text)),
// //                 srtQty: double.parse(srtController.text));
// //             Navigator.pop(context, updatedItem);
// //           },
// //           child:
// //               const Text("Save", style: TextStyle(color: Colour.pDeepDarkBlue)),
// //         ),
// //       ],
// //     );
// //   }
// // }
// class ItemTile extends StatelessWidget {
//   final MobileAppSalesInvoiceDetails detail;
//   final Function(MobileAppSalesInvoiceDetails) onEdit;
//   final VoidCallback onDelete;
//
//   const ItemTile({
//     super.key,
//     required this.detail,
//     required this.onEdit,
//     required this.onDelete,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[900],
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   "Product: ${detail.productName}",
//                   style: _textStyle(16, Colors.white),
//                 ),
//               ),
//               Text(
//                 "Code: ${detail.partNumber}",
//                 style: _textStyle(14, Colors.white70),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               _buildDetailColumn("Qty", detail.quantity),
//               _buildDetailColumn("FOC", detail.foc),
//               _buildDetailColumn("SRT", detail.srtQty),
//               _buildDetailColumn("UOM", detail.packingName),
//               _buildDetailColumn("Unit Rate", detail.unitRate),
//               Expanded(
//                   child: _buildDetailColumn("Total", detail.totalRate,
//                       isCurrency: true)),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.edit, color: Colors.white),
//                 onPressed: () async {
//                   final updatedItem =
//                   await _showEditDialog(context, detail);
//                   if (updatedItem != null) onEdit(updatedItem);
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete, color: Colors.red),
//                 onPressed: () {
//                   showCustomAlert(
//                     context: context,
//                     button1Text: 'No',
//                     button2Text: 'Yes',
//                     onButton1Press: () => Navigator.pop(context),
//                     onButton2Press: onDelete,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   TextStyle _textStyle(double size, Color color) {
//     return TextStyle(color: color, fontSize: size);
//   }
//
//   Widget _buildDetailColumn(String label, dynamic value, {bool isCurrency = false}) {
//     String displayValue = isCurrency ? formatRupees(value) : value.toString();
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: _textStyle(12, Colors.white70)),
//         Text(displayValue, style: _textStyle(14, Colors.white)),
//       ],
//     );
//   }
//
//   Future<MobileAppSalesInvoiceDetails?> _showEditDialog(
//       BuildContext context, MobileAppSalesInvoiceDetails item) {
//     return showDialog<MobileAppSalesInvoiceDetails>(
//       context: context,
//       builder: (context) => _EditItemDialog(item: item),
//     );
//   }
// }
//
// class _EditItemDialog extends StatefulWidget {
//   final MobileAppSalesInvoiceDetails item;
//
//   const _EditItemDialog({super.key, required this.item});
//
//   @override
//   __EditItemDialogState createState() => __EditItemDialogState();
// }
//
// class __EditItemDialogState extends State<_EditItemDialog> {
//   late TextEditingController quantityController;
//   late TextEditingController unitRateController;
//   late TextEditingController focController;
//   late TextEditingController srtController;
//   late TextEditingController packingNameController;
//
//   @override
//   void initState() {
//     super.initState();
//     quantityController = TextEditingController(text: widget.item.quantity.toString());
//     unitRateController = TextEditingController(text: widget.item.unitRate.toString());
//     focController = TextEditingController(text: widget.item.foc.toString());
//     srtController = TextEditingController(text: widget.item.srtQty.toString());
//     packingNameController = TextEditingController(text: widget.item.packingName);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text("Edit Item", style: TextStyle(color: Colour.pDeepDarkBlue)),
//       content: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             _buildNumberField("Quantity", quantityController),
//             _buildNumberField("FOC", focController),
//             _buildNumberField("SRT", srtController),
//             _buildTextField("UOM", packingNameController),
//             _buildNumberField("Unit Rate", unitRateController),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel", style: TextStyle(color: Colour.pDeepDarkBlue)),
//         ),
//         TextButton(
//           onPressed: () {
//             final updatedItem = widget.item.copyWith(
//               quantity: _parseInput(quantityController.text),
//               foc: _parseInput(focController.text),
//               srtQty: _parseInput(srtController.text),
//               packingName: packingNameController.text,
//               unitRate: _parseInput(unitRateController.text),
//               totalRate: (_parseInput(quantityController.text) *
//                   _parseInput(unitRateController.text)) -
//                   (_parseInput(srtController.text) *
//                       _parseInput(unitRateController.text)),
//             );
//             Navigator.pop(context, updatedItem);
//           },
//           child: const Text("Save", style: TextStyle(color: Colour.pDeepDarkBlue)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildNumberField(String label, TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(labelText: label),
//       keyboardType: TextInputType.number,
//       onChanged: (value) {
//         setState(() {
//           if (value.isEmpty || double.tryParse(value) == null || double.parse(value) < 0) {
//             controller.text = '0';
//             controller.selection = TextSelection.fromPosition(
//               TextPosition(offset: controller.text.length),
//             );
//           }
//         });
//       },
//     );
//   }
//
//   Widget _buildTextField(String label, TextEditingController controller) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(labelText: label),
//     );
//   }
//
//   double _parseInput(String value) {
//     return double.tryParse(value) ?? 0.0;
//   }
// }
