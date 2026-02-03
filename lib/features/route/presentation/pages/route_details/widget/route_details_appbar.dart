import 'package:flutter/material.dart';

class RouteDetailsAppBar extends StatelessWidget

    implements PreferredSizeWidget {
  final String routeDate;
  final String routeday;
  const RouteDetailsAppBar({super.key, required this.routeDate, required this.routeday});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff703BF7),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            routeday,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Text(
            routeDate,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
