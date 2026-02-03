import 'package:flutter/material.dart';

import '../../../../../../core/constants/color.dart';


class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String B_text;
 final Color color;

 const  CustomButton({required this.onPressed, super.key, required this.B_text, this.color = Colour.pDeepLightBlue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 327,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:color,
          borderRadius: BorderRadius.circular(8),
        ),
        child:  Text(
          B_text,
          style: TextStyle(
            color: Colour.pWhite,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
