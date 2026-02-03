// import 'package:flutter/material.dart';
//
// import '../../../../../../core/constants/textthemes.dart';
// import '../../../../../route/presentation/widgets/colourProfile.dart';
//
// class VoucherListTile extends StatelessWidget {
//
//   final String title;
//   final String subtitle;
//   final String invoiceNo;
//   final String invoiceDate;
//   final int paidAmount;
//
//
//   // final String price;
//   final VoidCallback? onTap;
//
//   const VoucherListTile({
//     super.key,
//
//     required this.title,
//     required this.subtitle,
//
//     // required this.price,
//     this.onTap,
//     required this.invoiceNo,
//     required this.invoiceDate,
//     required this.paidAmount,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return ListTile(
//       leading: coutomColorProfile(fullName: title),
//       title: Text(title,style: AppTextThemes.h2,),
//       subtitle: Column(
//         spacing: 3,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(subtitle,style: AppTextThemes.h5,),
//               Text("$paidAmount",style: AppTextThemes.h5,),
//             ],
//           ),
//           Text(invoiceNo,style: AppTextThemes.h5,),
//           Text(invoiceDate,style: AppTextThemes.h5,),
//         ],
//       ),
//       trailing:  Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//
//           const SizedBox(width: 10),
//           // const Icon(Icons.location_on_outlined, size: 20),
//           const SizedBox(width: 10),
//           const Icon(Icons.arrow_forward_ios, size: 22),
//         ],
//       ),
//       onTap: onTap, // Handle tap event
//     );
//   }
// }
import 'package:Yadhava/core/util/format_rupees.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/constants/textthemes.dart';
import '../../../../../route/presentation/widgets/colourProfile.dart';

class VoucherListTile extends StatelessWidget {
  final String voucherType;
  final String title;
  final String subtitle;
  final String invoiceNo;
  final String invoiceDate;
  final double paidAmount;
  final VoidCallback? onTap;

  const VoucherListTile({
    Key? key,
    required this.voucherType,
    required this.title,
    required this.subtitle,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.paidAmount,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: coutomColorProfile(fullName: title),
      title: Text(title, style: AppTextThemes.h2),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First row: pay mode and amount
          Text(subtitle, style: AppTextThemes.h5),
          // Voucher number
          // Voucher date
          Row(
            spacing: 3,
            children: [
              Text(invoiceDate, style: AppTextThemes.h5),
              Text("|", style: AppTextThemes.h5),

              Text(voucherType, style: AppTextThemes.h5),
            ],
          ),
        ],
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        children:  [
          Text('${formatRupees(paidAmount)}', style: AppTextThemes.h5),
          Text(invoiceNo, style: AppTextThemes.h5),
        ],
      ),
      onTap: onTap, // Handle tap if needed
    );
  }
}
