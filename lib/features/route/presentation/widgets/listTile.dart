import 'package:flutter/material.dart';

import '../../../../core/constants/textthemes.dart';
import 'colourProfile.dart';

class AdminShopListTile extends StatelessWidget {
  
  final String title;
  final String subtitle;

  // final String price;
  final VoidCallback? onTap;

  const AdminShopListTile({
    super.key,
    
    required this.title,
    required this.subtitle,
   
    // required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    
    return ListTile(
      leading: coutomColorProfile(fullName: title),
      title: Text(title,style: AppTextThemes.h2,),
      subtitle: Text(subtitle,style: AppTextThemes.h5,),
      trailing:  Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        
          const SizedBox(width: 10),
          // const Icon(Icons.location_on_outlined, size: 20),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward_ios, size: 22),
        ],
      ),
      onTap: onTap, // Handle tap event
    );
  }
}