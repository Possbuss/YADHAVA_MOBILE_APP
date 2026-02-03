import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/color.dart';
import 'build_appbar.dart';

Widget buildLoadingScreen(context) {
  return Scaffold(
    backgroundColor: Colour.pBackgroundBlack,
    appBar: buildAppBar(context),
    body: const Center(child: CircularProgressIndicator()),
  );
}
