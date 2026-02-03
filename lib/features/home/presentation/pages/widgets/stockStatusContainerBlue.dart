// import 'package:flutter/material.dart';
// import 'package:posbuss_milk/core/constants/color.dart';
// import 'package:posbuss_milk/core/constants/textthemes.dart';

// class StockStatusContainerBlue extends StatelessWidget {
//   const StockStatusContainerBlue({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//  width: double.infinity,
//    height: 149,
//    decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(10),
//     gradient: LinearGradient(colors: [Colour.pContainerLightBlue, Colour.pContainerDarkBlue],begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,)
//    ),
//    child:  Padding(
//      padding: const EdgeInsets.all(18),
//      child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Name',
//                         style:AppTextThemes.h5
//                       ),
//                       Text(
//                         'Code : 10001',
//                         style: AppTextThemes.h5
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     'Red Milk 500',
//                     style: AppTextThemes.h6
//                   ),
//                   SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Quantity',
//                             style:AppTextThemes.h5
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             '10 pkt',
//                             style: AppTextThemes.h7
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Price',
//                             style: AppTextThemes.h5
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             '₹28',
//                             style: AppTextThemes.h7
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Value',
//                             style: AppTextThemes.h5
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             '280',
//                             style:AppTextThemes.h7
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//    ),
//     );
//   }
// }