import 'package:Yadhava/core/util/format_rupees.dart';
import 'package:Yadhava/features/customer/presentation/pages/customer_details/model/addItem_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/constants/color.dart';
import '../../../../../home/data/stockStsModel.dart';

class ItemCard extends StatefulWidget {
  final String name;
  final String code;
  String quantity;
  String foc;
  String srt;
  String uom;
  String sellingPrice;
  double totalAmount;
  int productId;
  String packingDescription;
  String packingName;
  int packingId;

  final Function(ProductItem) onUpdate;

  ItemCard({
    super.key,
    required this.totalAmount,
    required this.name,
    required this.code,
    required this.quantity,
    required this.foc,
    required this.srt,
    required this.sellingPrice,
    required this.uom,
    required this.onUpdate,
    required this.productId,
    required this.packingName,
    required this.packingDescription,
    required this.packingId,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController focController = TextEditingController();
  final TextEditingController srtController = TextEditingController();
  final TextEditingController uomController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    qtyController.text = widget.quantity;
    focController.text = widget.foc;
    srtController.text = widget.srt;
    uomController.text = widget.uom;
    priceController.text = widget.sellingPrice;
    totalPriceController.text = widget.totalAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        _showEditDialog(context);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colour.lightblack,
          border: Border.all(color: Colour.blackgery, width: 1.0),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(color: Colour.mediumGray, fontSize: 12),
                  ),
                  Row(
                    children: [
                      const Text(
                        "Code: ",
                        style: TextStyle(
                          color: Colour.mediumGray,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        widget.code,
                        style: const TextStyle(
                          color: Colour.SilverGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),

              /// Name
              Text(
                widget.name,
                style: const TextStyle(color: Colour.SilverGrey, fontSize: 16),
              ),
              const SizedBox(height: 8),

              /// Divider
              Container(color: Colour.blackgery, height: 1.0),
              const SizedBox(height: 8),

              /// Details Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildColumn("Qty", widget.quantity),
                  _buildColumn("Foc", widget.foc),
                  _buildColumn("Srt", widget.srt),
                  _buildColumn("Uom", widget.uom),
                  _buildColumn("Selling", widget.sellingPrice),
                  _buildColumn("Total", widget.totalAmount.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumn(String title, String value) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(color: Colour.mediumGray, fontSize: 12)),
        Text(
          value,
          style: const TextStyle(color: Colour.SilverGrey, fontSize: 12),
        ),
      ],
    );
  }


  void _showEditDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // Form key for validation

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: Colour.blackgery,
          backgroundColor: Colour.pWhite,
          title: const Text("Edit Item", style: TextStyle(color: Colour.blackgery)),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey, // Assign form key
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Quantity Field
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*$')),
                    ],
                    validator: (value) => value == null || value.isEmpty ? "Quantity is required" : null,
                    onChanged: (value) {
                      setState(() {
                        double qtyValue = double.tryParse(value) ?? 0.0;
                        double srtValue = double.tryParse(srtController.text) ?? 0.0;
                        double priceValue = double.tryParse(priceController.text) ?? 0.0;

                        totalPrice = (qtyValue - srtValue) * priceValue;
                        totalPriceController.text = totalPrice.toStringAsFixed(2);
                      });
                    },
                    style: const TextStyle(color: Colour.blackgery),
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// Foc Field
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                    ],
                    validator: (value) => value == null || value.isEmpty ? "FOC is required" : null,
                    style: const TextStyle(color: Colour.mediumGray),
                    controller: focController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Foc',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// Srt Field
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*$')),
                    ],
                    validator: (value) => value == null || value.isEmpty ? "SRT is required" : null,
                    onChanged: (value) {
                      setState(() {
                        double srtValue = double.tryParse(value) ?? 0.0;
                        double qtyValue = double.tryParse(qtyController.text) ?? 0.0;
                        double priceValue = double.tryParse(priceController.text) ?? 0.0;

                        totalPrice = (qtyValue - srtValue) * priceValue;
                        totalPriceController.text = totalPrice.toStringAsFixed(2);
                      });
                    },
                    style: const TextStyle(color: Colour.blackgery),
                    controller: srtController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Srt',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// Selling Price Field
                  TextFormField(
                    validator: (value) => value == null || value.isEmpty ? "Selling Price is required" : null,
                    onChanged: (value) {
                      setState(() {
                        double qtyValue = double.tryParse(qtyController.text) ?? 0.0;
                        double srtValue = double.tryParse(srtController.text) ?? 0.0;
                        double priceValue = double.tryParse(value) ?? 0.0;

                        totalPrice = (qtyValue - srtValue) * priceValue;
                        totalPriceController.text = totalPrice.toStringAsFixed(2);
                      });
                    },
                    style: const TextStyle(color: Colour.blackgery),
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Selling Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// Total Price (Read-Only)
                  TextFormField(
                    readOnly: true,
                    style: const TextStyle(color: Colour.blackgery),
                    controller: totalPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Total Price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    widget.quantity = qtyController.text;
                    widget.sellingPrice = priceController.text;
                    widget.totalAmount = double.tryParse(totalPriceController.text) ?? 0;
                    widget.foc = focController.text;
                    widget.srt = srtController.text;
                    widget.uom = uomController.text;
                  });

                  widget.onUpdate(
                    ProductItem(
                      productName: widget.name,
                      partNumber: widget.code,
                      quantity: int.tryParse(widget.quantity.toString()) ?? 0,
                      fac: int.tryParse(widget.foc.toString()) ?? 0,
                      srt: int.tryParse(widget.srt.toString()) ?? 0,
                      sell: widget.sellingPrice.toString(),
                      uom: widget.uom,
                      totalRate: (widget.totalAmount as num?)?.toDouble() ?? 0.0,
                      productId: (widget.productId as num?)?.toInt() ?? 0,
                      packingDescription: widget.packingDescription,
                      packingName: widget.packingName,
                      packingId: (widget.packingId as num?)?.toInt() ?? 0,
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

}
