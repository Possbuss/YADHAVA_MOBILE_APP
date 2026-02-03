import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constants/color.dart';

class VoucherCustomDropDown extends StatelessWidget {
  final List<String> items;
  final String selectedValue;
  final Function(String) onChanged;
  final String label;
  final String? Function(String?) validator;

  const VoucherCustomDropDown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged, required this.label,
    required this.validator
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,
          style:  TextStyle(color: Colour.pWhite, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colour.lightblack,
            border: Border.all(color: Colour.blackgery, width: 2), // Updated border color
            borderRadius: BorderRadius.circular(8),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent, // Removes dropdown background
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                
                validator:validator ,
                dropdownColor: Colour.blackgery,
                focusColor: Colour.blackgery,
                value: items.contains(selectedValue) ? selectedValue : null,
                hint: Text(
                  selectedValue,
                  style: const TextStyle(color: Colors.white), // Updated hint text color
                ),
                icon: const Icon(Icons.arrow_drop_down, color: Colour.blackgery), // Updated icon color
                style: const TextStyle(fontSize: 16, color: Colour.blackgery), // Updated selected text color
                isExpanded: true,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onChanged(newValue); // Call function to pass value
                  }
                },
                items: items.map<DropdownMenuItem<String>>((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(color: Colour.darkgrey), // Ensuring dropdown items text is white
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
