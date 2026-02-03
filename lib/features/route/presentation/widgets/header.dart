import 'package:flutter/material.dart';

import '../../../../core/constants/textthemes.dart';

class AdminSectionHeader extends StatelessWidget {
  final String title;
  const AdminSectionHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextThemes.h3,
    );
  }
}