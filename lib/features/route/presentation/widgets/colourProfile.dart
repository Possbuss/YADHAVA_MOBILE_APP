import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/constants/textthemes.dart';

Widget coutomColorProfile({required String fullName}){
  return CircleAvatar(
    radius: 25,
      backgroundColor:generateRandomColor() ,
      child: Text(fullName[0].toUpperCase(),style: AppTextThemes.appbarHomeHeading,)
     );
}

Color generateRandomColor() {
  final Random random = Random();
  return Color.fromRGBO(
    random.nextInt(256), // Red value (0-255)
    random.nextInt(256), // Green value (0-255)
    random.nextInt(256), // Blue value (0-255)
    1.0, // Fully opaque
  );
}