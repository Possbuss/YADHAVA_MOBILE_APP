import 'dart:developer';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/product_master.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Yadhava/core/constants/color.dart';
import 'package:Yadhava/features/customer/model/InvoiceModel.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/widget/custom_dropdown.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/widget/custom_feild.dart';

import '../../customer_details/bloc/add_item_bloc.dart';

class AddItemPopup extends StatefulWidget {
  @override
  State<AddItemPopup> createState() => _AddItemPopupState();
}

class _AddItemPopupState extends State<AddItemPopup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController qtyController = TextEditingController(text: '1');
  final TextEditingController focController = TextEditingController(text: '0');
  final TextEditingController srtController = TextEditingController(text: '0');
  final TextEditingController unitRateController = TextEditingController(text: '0');
  final TextEditingController sellingController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  String? selectedItem;
  String? selectedUOM;
  String? uomInitialValue;
  List<String> uomItems = [];
  ProductMaster? selectedItemData;

  @override
  void initState() {
    super.initState();
    context.read<AddItemBloc>().add(FetchItems());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colour.pBackgroundBlack,
      title: const Text("Add Item", style: TextStyle(color: Colour.SilverGrey)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<AddItemBloc, AddItemState>(
                builder: (context, state) {
                  if (state is ItemsFetchedState) {
                    final items = state.items.map((item) => item.productName.toString()).toList();
                    return ReusableDropdown(
                      label: "Item",
                      hintText: "Select Item",
                      items: items,
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value;
                          selectedItemData = state.items.firstWhere(
                            (item) => item.productName == value,
                          );
                          sellingController.text = selectedItemData!.sellingPrice.toString();
                          totalController.text = sellingController.text;
                          uomInitialValue = selectedItemData!.packingName ?? 'N/A';
                          uomItems = [uomInitialValue!];
                          log(sellingController.text);
                        });
                      },
                    );
                  } else if (state is ItemsFetchErrorState) {
                    return Text(state.error, style: const TextStyle(color: Colors.red));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(height: 16),
              ReusableVoucherTextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$'))
                ],
                onChanged: (qt){
                  int srtCount = int.tryParse(srtController.text) ?? 0;
                  double totalPrice =
                      (double.tryParse(sellingController.text) ?? 0) * (double.tryParse(qt) ?? 0)-(srtCount*(double.tryParse(sellingController.text)??0));
                  totalController.text = totalPrice.toStringAsFixed(2);
                },
                keyboardType: TextInputType.number,
                label: "Quantity",
                controller: qtyController,
                validator: (value) => value!.isEmpty ? 'Please enter quantity' : null, hintText: '',
              ),
              const SizedBox(height: 16),
              ReusableVoucherTextField(
                keyboardType: TextInputType.number,
                label: "FOC",
                controller: focController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$'))
                ],
                validator: (value) => value!.isEmpty ? 'Please enter FOC' : null, hintText: '',
              ),
              const SizedBox(height: 16),
              ReusableVoucherTextField(
                onChanged: (srt){
                  int quantity = int.tryParse(qtyController.text) ?? 0;
                  double totalPrice =
                      ( (double.tryParse(sellingController.text) ?? 0) * quantity)-((double.tryParse(sellingController.text)??0)*(double.tryParse(srt)??0));
                  totalController.text = totalPrice.toStringAsFixed(2);

                },
                keyboardType: TextInputType.number,
                label: "SRT",
                controller: srtController,
                validator: (value) => value!.isEmpty ? 'Please enter SRT' : null, hintText: '',
              ), const SizedBox(height: 16),
              ReusableVoucherTextField(
                onChanged: (price) {
                  int srtCount = int.tryParse(srtController.text) ?? 0;
                  double totalPrice =
                      (double.tryParse(qtyController.text) ?? 0) * (double.tryParse(price) ?? 0)-(srtCount*(double.tryParse(price)??0));
                  totalController.text = totalPrice.toStringAsFixed(2);
                },

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$'))
                ],
                keyboardType: TextInputType.number,
                label: "Unit Rate",
                controller: sellingController,
                validator: (value) => value!.isEmpty ? 'Please enter Unit Price' : null, hintText: '',
              ),
              ReusableVoucherTextField(
                onChanged: (srt){
                  int quantity = int.tryParse(qtyController.text) ?? 0;
                  double totalPrice =
                      ( (double.tryParse(sellingController.text) ?? 0) * quantity)-((double.tryParse(sellingController.text)??0)*(double.tryParse(srt)??0));
                  totalController.text = totalPrice.toStringAsFixed(2);

                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$'))
                ],
                keyboardType: TextInputType.number,
                label: "Total",
                controller: totalController,
                validator: (value) => value!.isEmpty ? 'Please enter SRT' : null, hintText: '',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (selectedItemData == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select an item before adding.'),
                  ),
                );
                return;
              }

              MobileAppSalesInvoiceDetails newItem = MobileAppSalesInvoiceDetails(
                productName: selectedItem ?? '',
                quantity: double.parse(qtyController.text),
                foc: double.parse(focController.text),
                srtQty: double.parse(srtController.text),
                totalRate: double.parse(totalController.text),
                siNo: selectedItemData!.siNo,
                productId: selectedItemData!.productId,
                partNumber: selectedItemData!.partNumber,
                packingDescription: selectedItemData!.packingDescription,
                packingId: selectedItemData!.packingId,
                packingName: selectedItemData!.packingName,
                totalQty: 0.0,
                unitRate: 0.0,
                clientId: 0,
                companyId: 1,
              );
              Navigator.pop(context, newItem);
            }
          },
          child: const Text("Add", style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }
}
