import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/color.dart';
import '../../../domain/invoice_repo.dart';
import '../../bloc/inovice_bloc/invoice_bloc.dart';
import '../customer_details/widget/custom_button.dart';


class CreateInvoicePage extends StatelessWidget {
  const CreateInvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InvoiceBloc(InvoiceRepo()),
      child: Scaffold(
        backgroundColor: Colour.pBackgroundBlack,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colour.pDeepLightBlue,
          title: const Text(
            "Create Invoice",
            style: TextStyle(
              color: Colour.SilverGrey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Invoice Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildTextField("Branch Name"),
              const SizedBox(height: 16),
              _buildTextField("Salesman Name"),
              const SizedBox(height: 16),
              _buildTextField("Invoice Type"),
              const SizedBox(height: 16),
              _buildTextField("Invoice No"),
              const SizedBox(height: 16),
              _buildTextField("Invoice Date"),
              const SizedBox(height: 16),
              _buildTextField("Net Total", keyboardType: TextInputType.number),
              const SizedBox(height: 24),
              Center(
                child:
               CustomButton(onPressed: () {
                 // context.read<InvoiceBloc>().add(CreateInvoiceEvent(/* Pass invoice details here */));

               } , B_text: "Create Invoice")
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colour.mediumGray),
        filled: true,
        fillColor: Colour.lightblack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colour.pDeepLightBlue),
        ),
      ),
    );
  }
}
