// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../../../../../../core/constants/color.dart';
//
// class ReusableVoucherTextField extends StatelessWidget {
//   final String label;
//   final String hintText;
//   final TextInputType? keyboardType;
//   final TextEditingController controller;
//   final Function(String)? onChanged;
//   final List<TextInputFormatter>? inputFormatters;
//   final String? Function(String?)? validator;
//   final bool readOnly;
//
//   const ReusableVoucherTextField({
//     super.key,
//     required this.label,
//     required this.hintText,
//     required this.controller,
//     this.keyboardType,
//     this.onChanged,
//     this.inputFormatters,
//     this.validator,
//     this.readOnly = false
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(color: Colour.pWhite, fontSize: 14),
//         ),
//         const SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           keyboardType: keyboardType,
//           readOnly: readOnly,
//            inputFormatters:inputFormatters,
//           style: const TextStyle(color: Colors.white),
//           decoration: InputDecoration(
//             enabledBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(color: Colour.blackgery)),
//             focusedBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(color: Colour.blackgery)),
//             hintText: hintText,
//             hintStyle: const TextStyle(color: Colour.darkgrey),
//             filled: true,
//             fillColor: Colour.lightblack,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(6.0),
//               borderSide: const BorderSide(color: Colour.blackgery),
//             ),
//           ),
//           onChanged: onChanged,
//           validator: validator,
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/constants/color.dart';

class ReusableVoucherTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap; // Optional onTap callback

  const ReusableVoucherTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
    this.validator,
    this.readOnly = false,
    this.onTap, // Accepting onTap function
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colour.blackgery, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          inputFormatters: inputFormatters,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colour.blackgery)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colour.blackgery)),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colour.darkgrey),
            filled: true,
            fillColor: Colour.mediumGray,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: Colour.blackgery),
            ),
          ),
          onChanged: onChanged,
          validator: validator,
          onTap: onTap, // Adding the optional onTap functionality
        ),
      ],
    );
  }
}
