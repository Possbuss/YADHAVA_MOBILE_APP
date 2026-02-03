import 'package:Yadhava/core/constants/color.dart';
import 'package:flutter/material.dart';

class CustomDiscountTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator; // Validator function


  const CustomDiscountTextField(
      {super.key, required this.controller, required this.label,this.onChanged, this.validator});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100, // Small width
      height: 50, // Small height
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: controller,
          maxLength: 5, // Restricts to 5 letters
          style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 255, 255, 255)), // Small font size
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2)),
            disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2)),
            labelText: label,
            labelStyle: const TextStyle(
                fontSize: 16,
                color: Colour.pWhite), // Small font size
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            counterText: "", // Hides character count
          ),
          onChanged: onChanged,
          validator: validator
        ),
      ),
    );
  }
}
