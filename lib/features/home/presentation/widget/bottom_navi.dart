import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/icons.dart'; // Ensure Colour class is defined here.

class BottomNavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  BottomNavBar({this.activeIndex = 0, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomAppBar(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                image: icons.home,
                label: 'Home',
                isActive: activeIndex == 0,
                onTap: () => onTap(0),
              ),
              _buildNavItem(
                image: icons.customer,
                label: 'Customer',
                isActive: activeIndex == 1,
                onTap: () => onTap(1),
              ),
              _buildNavItem(
                image: icons.route,
                label: 'Route',
                isActive: activeIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String image,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              fit: BoxFit.contain,
              width: 25,
              height: 25,
              color: isActive ? Colour.pDeepLightBlue : Colour.SoftGray,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colour.pDeepLightBlue : Colour.SoftGray,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
