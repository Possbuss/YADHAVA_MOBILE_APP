import 'dart:convert';

import 'package:Yadhava/core/constants/color.dart';
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
  final Function() onTap1;
  final Function() onTap2;
  final Function() onTap3;
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
    super.key,
    required this.onTap1,
    required this.onTap2,
    required this.onTap3,
    required this.salesManName
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      padding: EdgeInsets.symmetric(
          vertical: height * 0.015, horizontal: width * 0.015),
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
        spacing: 6,
        children: [
          _buildHeader(width,context),
          SizedBox(
            height: height * 0.01,
          ),
          _buildRow("assets/icon/Shop.png",
              //(hotelName +' '+(isActive + ' ['+createdDate+']')),
              "$hotelName [ $createdDate ]",
              width),
          GestureDetector(
             onTap:onTap3,
              child: _buildRow("assets/icon/Location.png", location, width)),
          Visibility(
            visible: salesManName.isNotEmpty,
            child: _buildRow("assets/icon/Profile.png", salesManName, width),
          ),
          const Divider(color: Colors.white, thickness: 1),
          _buildBalanceRow(),
          SizedBox(
            height: height * 0.01,
          ),
        ],
      ),
    );
  }


  Widget _buildHeader(double width, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 🟣 Avatar Circle
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              avatarUrl.isNotEmpty
                  ? avatarUrl.substring(0, 1).toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff703BF7),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // 🧾 Name + Phone
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$name",
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

        const SizedBox(width: 6),

        // 📍 Location Status
        Visibility(
          visible: latitude == 0.0 || longitude == 0.00,
          child: Container(
            decoration: BoxDecoration(
              color: (latitude != 0.0 || longitude != 0.00)
                  ? Colors.green
                  : Colors.red,
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
              onPressed: () {},
              icon: const Icon(
                Icons.location_off_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // 📞 Phone Call Icon
        if (phoneNumber.isNotEmpty) ...[
          const SizedBox(width: 6),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              boxShadow: [
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
              onPressed: () => _makePhoneCall(phoneNumber),
              icon: const Icon(
                Icons.phone,
                color: Colors.white,
              ),
            ),
          ),
        ],

        const SizedBox(width: 6),

        // 🟢🔴 Status Bubble Icon
        Container(
          decoration: BoxDecoration(
            color: isActive == 'Y' ? Colors.green : Colors.red,
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
            onPressed: onTap2,
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildHeaderQQQQQ(double width, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 🟣 Avatar Circle
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              avatarUrl.isNotEmpty
                  ? avatarUrl.substring(0, 1).toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff703BF7),
              ),
            ),
          ),
        ),

        const SizedBox(width: 8),

        // 🧾 Name + Phone (this will flex/shrink properly)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$name [$sortOrder]",
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

        const SizedBox(width: 6),

        Visibility(
          visible: latitude == 0.0 || longitude == 0.00,
          child: Container(
            decoration: BoxDecoration(
              color: (latitude != 0.0 || longitude != 0.00) ? Colors.green : Colors.red,
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
              onPressed: () {
              },
              icon: const Icon(
                Icons.location_off_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),


        const SizedBox(width: 6),

        // 🟢🔴 Status Bubble Icon
        Container(
          decoration: BoxDecoration(
            color: isActive == 'Y' ? Colors.green : Colors.red,
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
            onPressed: onTap2,
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
            ),
          ),
        ),


      ],
    );
  }






  Widget _buildHeader111(double width,BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Text(
              avatarUrl.isNotEmpty
                  ? avatarUrl.substring(0, 1).toUpperCase()
                  : '?', // fallback character
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff703BF7),
              ),
            ),
          ),

          // child: Center(
          //     child: Text(
          //   avatarUrl.substring(0, 1).toUpperCase(),
          //   style: const TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.bold,
          //       color: Color(0xff703BF7)),
          // )),
        ),
        SizedBox(width: width * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                "$name [$sortOrder]",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),


              if (phoneNumber.isNotEmpty) ...[
                const SizedBox(width: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
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
                    onPressed: () {
                      _makePhoneCall(phoneNumber);
                    },
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],

            ],
          ),
        ),
        SizedBox(width: 5,),
        const Spacer(
        ),

        Container(
          decoration: BoxDecoration(
            color: isActive == 'ACTIVE' ? Colors.green : Colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: onTap2,
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri uri = Uri.parse('tel:$cleanedNumber');

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Dialer not available: $e');
    }
  }


  Future<void> _makePhoneCall1(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }


  Widget _buildRow(String img, String text, double width) {
    return Row(
      children: [
        Image.asset(
          img,
          color: Colors.white,
          height: 20,
          width: 20,
        ),
        SizedBox(width: width * 0.015),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Current Balance",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        InkWell(
          onTap: onTap1,
          child: Row(
            spacing: 8,
            children: [
              Text(
                currentBalance,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white, // Red underline
                  decorationThickness: 1,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
