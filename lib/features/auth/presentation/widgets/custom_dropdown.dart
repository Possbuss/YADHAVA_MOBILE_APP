import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';

class CustomDropdown extends StatefulWidget {
  final String label;
  final String hint;
  final List<String> options;
  final ValueChanged<String?>? onChanged;
  const CustomDropdown({
    Key? key,
    required this.label,
    required this.hint,
    required this.options, this.onChanged,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButton<String>(

          value: selectedValue,
          hint: Text(widget.hint, style: const TextStyle(color: Colour.pGray)),
          isExpanded: true,
          dropdownColor: Colour.blackgery,
          items: widget.options
              .toSet()
              .map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue;
            });
            if(widget.onChanged!=null){
              widget.onChanged!(newValue);
            }
          },
        ),
      ],
    );
  }
}
