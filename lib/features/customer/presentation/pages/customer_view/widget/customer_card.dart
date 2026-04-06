import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerCard extends StatelessWidget {
  final String name;
  final int? sortOrder;
  final String phoneNumber;
  final String hotelName;
  final String location;
  final String currentBalance;
  final String isActive;
  final String createdDate;
  final double? latitude;
  final double? longitude;
  final String avatarUrl;
  final String profileImageUrl;
  final bool profileImageIsLocal;
  final bool isUploadingImage;
  final VoidCallback onTap1;
  final VoidCallback onTap2;
  final VoidCallback onTap3;
  final VoidCallback onProfileTap;
  final String salesManName;

  const CustomerCard({
    required this.name,
    required this.sortOrder,
    required this.phoneNumber,
    required this.hotelName,
    required this.location,
    required this.currentBalance,
    required this.isActive,
    required this.createdDate,
    required this.latitude,
    required this.longitude,
    required this.avatarUrl,
    required this.profileImageUrl,
    required this.profileImageIsLocal,
    required this.isUploadingImage,
    super.key,
    required this.onTap1,
    required this.onTap2,
    required this.onTap3,
    required this.onProfileTap,
    required this.salesManName,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      padding: EdgeInsets.symmetric(
        vertical: height * 0.015,
        horizontal: width * 0.015,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xff703BF7),
            Color(0xffC3A6FF),
          ],
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          SizedBox(height: height * 0.01),
          _buildRow(
            "assets/icon/Shop.png",
            "$hotelName [ $createdDate ]",
            width,
          ),
          GestureDetector(
            onTap: onTap3,
            child: _buildRow("assets/icon/Location.png", location, width),
          ),
          Visibility(
            visible: salesManName.isNotEmpty,
            child: _buildRow("assets/icon/Profile.png", salesManName, width),
          ),
          const Divider(color: Colors.white, thickness: 1),
          _buildBalanceRow(),
          SizedBox(height: height * 0.01),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                sortOrder == null ? name : "$name [$sortOrder]",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              if (phoneNumber.isNotEmpty)
                Text(
                  phoneNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
            ],
          ),
        ),
        if (latitude == 0.0 || longitude == 0.0) ...[
          const SizedBox(width: 6),
          _buildCircleAction(
            color: Colors.red,
            icon: Icons.location_off_outlined,
            onPressed: () {},
          ),
        ],
        if (phoneNumber.isNotEmpty) ...[
          const SizedBox(width: 6),
          _buildCircleAction(
            color: Colors.blue,
            icon: Icons.phone,
            onPressed: () => _makePhoneCall(phoneNumber),
          ),
        ],
        const SizedBox(width: 6),
        _buildCircleAction(
          color: isActive == 'Y' ? Colors.green : Colors.red,
          icon: Icons.edit_outlined,
          onPressed: onTap2,
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: onProfileTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildAvatarImage(),
              if (isUploadingImage)
                Container(
                  color: Colors.black26,
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (profileImageUrl.isNotEmpty) {
      if (profileImageIsLocal) {
        return Image.file(
          File(profileImageUrl),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildInitialsAvatar(),
        );
      }

      return Image.network(
        profileImageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildInitialsAvatar(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      );
    }

    return _buildInitialsAvatar();
  }

  Widget _buildInitialsAvatar() {
    return Container(
      color: const Color(0xFFF4F1FF),
      alignment: Alignment.center,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          'No Image',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF4B2BBE),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleAction({
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
        iconSize: 20,
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri uri = Uri.parse('tel:$cleanedNumber');

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Dialer not available: $e');
    }
  }

  Widget _buildRow(String img, String text, double width) {
    return Row(
      children: [
        Image.asset(
          img,
          width: width * 0.05,
          height: width * 0.05,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: onTap1,
          icon: const Icon(Icons.receipt_long, color: Colors.white),
          label: const Text(
            'Statement',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Text(
          currentBalance,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
