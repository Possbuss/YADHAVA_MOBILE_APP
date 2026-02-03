import 'package:flutter/material.dart';

import '../../../../../../../core/constants/color.dart';

class SaveButton extends StatelessWidget {
  final Function () onPress;
  const SaveButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 76),
      child: ElevatedButton(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
              fixedSize: const Size(427, 48),
              backgroundColor: Colour.pDeepLightBlue),
          child: const Text(
            "Save",
            style: TextStyle(
                color: Colour.pWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          )),
    );
  }
}
