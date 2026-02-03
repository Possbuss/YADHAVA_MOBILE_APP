import 'package:flutter/material.dart';

import '../constants/color.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final leading;
  final action;
  final leadingontap;
  const CustomAppbar(
      {super.key,
      required this.title,
      this.leading,
      this.action,
      this.leadingontap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colour.pDeepLightBlue,
      leading: IconButton(onPressed: leadingontap, icon: leading),
      actions: [action],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
