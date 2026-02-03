import 'dart:developer';

import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/product_master.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/widget/custom_button.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/widget/custom_dropdown.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/widget/custom_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/color.dart';
import 'bloc/add_item_bloc.dart';
import 'model/addItem_model.dart';

class AddItemScreen extends StatefulWidget {
  final bool isEditScreen;
  final ProductMaster? items;
  final int? updateIndex;
  const AddItemScreen({super.key,required this.isEditScreen,this.items,this.updateIndex});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController qtyController = TextEditingController(text:'1');
  final TextEditingController focController = TextEditingController(text: '0');
  final TextEditingController sellingController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController srtController = TextEditingController();

  String? selectedItem;
  String? selectedUOM;
  String? uomInitialValue;
  String? itemInitialValue;
  List<String> uomItems = [];
  late ProductMaster selectedItemData;

  String? packingDescription;
  String? packingId;
  String? packingName;
  String? partNumber;
  String? productId;

  @override
  void initState() {
    super.initState();
    context.read<AddItemBloc>().add(FetchItems());

    qtyController.text= widget.isEditScreen ? widget.items!.quantity.toString() : '1';
    focController.text= widget.isEditScreen ? widget.items!.foc.toString() : '0';
    srtController.text= widget.isEditScreen ? widget.items!.srt.toString() : '0';
    sellingController.text= widget.isEditScreen ? widget.items!.sellingPrice.toString() : '';
    totalController.text= widget.isEditScreen ? widget.items!.totalRate.toString() : '';
    if (widget.isEditScreen) {
      itemInitialValue = widget.items!.productName;
      uomInitialValue = widget.items!.packingName;
      uomItems = [widget.items!.packingName];
      packingDescription = widget.items!.packingDescription;
      packingId = widget.items!.packingId.toString();
      packingName  = widget.items!.packingName;
      partNumber  = widget.items!.partNumber.toString();
      packingId  = widget.items!.productId.toString();
    }

  }

  @override
  void dispose() {
    qtyController.dispose();
    focController.dispose();
    sellingController.dispose();
    totalController.dispose();
    srtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colour.pBackgroundBlack,
      appBar: AppBar(
        backgroundColor: Colour.pBackgroundBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colour.mediumGray2),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEditScreen ? "Edit item": "Add Item",
          style: const TextStyle(
            color: Colour.SilverGrey,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<AddItemBloc, AddItemState>(
                  builder: (context, state) {
                    if (state is ItemsFetchedState) {
                      
                      final items = state.items;
                      final itemNames =
                          items.map((item) => item.productName.toString()).toList();

                      return ReusableDropdown(
                        label: "Item",
                        hintText: "Select Item",
                        initialValue: itemInitialValue,
                        items: itemNames,
                        onChanged: (value) {
                          if (selectedItem != value) {
                            setState(() {
                              selectedItem = value;
                              selectedItemData = items.firstWhere(
                                    (item) => item.productName == value,
                                //orElse: () => null, // Optional: handle not found case
                              );

                              sellingController.text =
                                  selectedItemData.sellingPrice.toString() ?? '0';
                              totalController.text = sellingController.text;
                              uomInitialValue =
                                  selectedItemData.packingName.toString() ?? 'N/A';
                              uomItems = [uomInitialValue!];

                              log(sellingController.text);
                            });
                          }
                        },
                      );
                    } else if (state is ItemsFetchErrorState) {
                      return Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ReusableVoucherTextField(
                        keyboardType: TextInputType.number,
                        label: "Quantity",
                        hintText: "Enter Qty",
                        controller: qtyController,
                        onChanged: (qt) {
                          int srtCount = int.tryParse(srtController.text) ?? 0;
                          double totalPrice =
                              (double.tryParse(sellingController.text) ?? 0) * (double.tryParse(qt) ?? 0)-(srtCount*(double.tryParse(sellingController.text)??0));
                          totalController.text = totalPrice.toStringAsFixed(2);

                          // double totalPrice =
                          //     (double.tryParse(qt) ?? 0) * (double.tryParse(sellingController.text) ?? 0);
                          // totalController.text = totalPrice.toStringAsFixed(2);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$'))
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter quantity';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ReusableVoucherTextField(
                        label: "FOC",
                        hintText: "Enter FOC",
                        keyboardType: TextInputType.number,
                        controller: focController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$'))
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter FOC';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
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
                  hintText: "0",
                  controller:srtController ,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9][0-9]*$'))
                  ],

                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ReusableDropdown(
                        label: "UOM",
                        hintText: "Select UOM",
                        initialValue: uomInitialValue,
                        items: uomItems,
                        onChanged: (value) => selectedUOM = value,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ReusableVoucherTextField(
                        keyboardType: TextInputType.number,
                        label: "Selling Price",
                        hintText: "Enter Selling",
                        controller: sellingController,
                        onChanged: (price) {
                          int srtCount = int.tryParse(srtController.text) ?? 0;
                          double totalPrice =
                              (double.tryParse(qtyController.text) ?? 0) * (double.tryParse(price) ?? 0)-(srtCount*(double.tryParse(price)??0));
                          totalController.text = totalPrice.toStringAsFixed(2);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter selling price';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ReusableVoucherTextField(
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  label: "Total Price",
                  hintText: "Enter total",
                  controller: totalController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Center(
                  child: BlocConsumer<AddItemBloc, AddItemState>(
                    listener: (context, state) {
                      if (state is ItemAddedState) {
                           if (state.isAlreadyExists) {
                              ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text(state.message,)),
                         );
                           }
                        qtyController.clear();
                        focController.clear();
                        sellingController.clear();
                        totalController.clear();
                        srtController.clear();
                        selectedItem = null;
                        selectedUOM = null;

                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ProductMaster item = ProductMaster(
                              foc: int.tryParse(focController.text) ?? 0,
                              srt:int.tryParse(srtController.text) ?? 0,
                              productName: selectedItem ?? itemInitialValue ?? '',
                              quantity: int.tryParse(qtyController.text) ?? 0,
                              sellingPrice: double.tryParse(sellingController.text) ?? 0,
                              totalRate: double.parse(totalController.text),
                              //pa: selectedUOM ?? uomInitialValue ?? '',
                              packingDescription:
                                  selectedItemData.packingDescription?? packingDescription ?? '',
                              packingId: int.tryParse(selectedItemData.packingId.toString() ?? packingId ?? '0') ?? 0,
                              packingName: selectedItemData.packingName ?? packingName ??'',
                              partNumber: selectedItemData.partNumber ?? partNumber ?? '',
                              productId: int.tryParse(selectedItemData.productId.toString() ?? productId ?? '0') ?? 0,

                              basePackingId: 0,
                              buyyingPrice: 0,
                              categoryId: 0,
                              categoryName: '',
                              companyId: 1,
                              isActive: 'Y',
                              mrp: double.tryParse(sellingController.text) ?? 0,
                              packingOrder: 1,
                              packMultiplyQty: 1,
                              wholeSalePrice: 0,
                              siNo: 1

                            );

                            if (widget.isEditScreen) {
                              context.read<AddItemBloc>().add(UpdateItem(item: item, index: widget.updateIndex!));
                            } else {
                              context.read<AddItemBloc>().add(SubmitAddItem(item: item));
                            }

                          }
                        },
                        B_text: widget.isEditScreen ? 'Update item' : 'Add item',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
