import 'package:flutter/material.dart';

import '../../../../../../core/constants/color.dart';

class ReusableDropdown extends StatelessWidget {
  final String label;
  final String hintText;
  final List<String> items;
  final void Function(String?) onChanged;
  final String? initialValue;

  const ReusableDropdown({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.onChanged,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(

          isExpanded: true,
          value: initialValue,
          dropdownColor: Colour.lightblack,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colour.blackgery)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colour.blackgery)),
            filled: true,
            fillColor: Colour.mediumGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colour.blackgery),
            ),
          ),
          hint: Text(
            hintText,
            style: const TextStyle(color: Colour.darkgrey),
          ),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(color: Colour.SoftGray),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
