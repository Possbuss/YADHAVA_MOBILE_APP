import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';
import '../../../home/presentation/pages/home_page.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const LoginButton({
    super.key, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(

        onPressed:onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colour.pDeepDarkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 135,
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 16,color: Colour.pWhite),
        ),
      ),
    );
  }
}
