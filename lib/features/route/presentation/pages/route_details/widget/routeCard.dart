// import 'package:flutter/material.dart';
//
// class RouteCard extends StatelessWidget {
//  final Map<String, String> route;
//  final String number;
//  final bool isLast;
//   const RouteCard({
//     super.key,
//     required this.number,
//     required this.route,
//     this.isLast = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Column(
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width*.15,
//               height: MediaQuery.of(context).size.height*.08,
//               decoration: const BoxDecoration(
//                 color: Color.fromRGBO(41, 29, 70, 1),
//                 shape: BoxShape.circle,
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 number,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color:  Color.fromARGB(255, 139, 99, 241),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             if (!isLast)
//             Container(
//               width: MediaQuery.of(context).size.width*.01,
//               height: MediaQuery.of(context).size.height*.08,
//               color: const Color.fromARGB(255, 139, 99, 241),
//             ),
//           ],
//         ),
//          SizedBox(width: MediaQuery.of(context).size.width*.03,),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 route["title"]?? "",
//                 style: const TextStyle(
//                   fontSize: 5,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 route["subtitle"]?? "",
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const ImageIcon(
//           AssetImage("assest/icon/Location.png"),
//           color: Colors.white,
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../model/route_detailsModel.dart';

class RouteCard extends StatelessWidget {
  final RouteDetailsModel route;
  final String number;
  final bool isLast;

  const RouteCard({
    super.key,
    required this.number,
    required this.route,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(41, 29, 70, 1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: const Color.fromARGB(255, 139, 99, 241),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                route.customerName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                route.contactPersonName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
         Padding(
          padding: const EdgeInsets.only(top: 8),
          child: GestureDetector(
            onTap: () async {
              final String latitude = route.latitude?.toString() ?? "0";
              final String longitude =
                  route.longitude?.toString() ?? "0";

              if (latitude.isNotEmpty && longitude.isNotEmpty) {
                final String googleMapsUrl =
                    "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

                if (await canLaunch(googleMapsUrl)) {
                  await launch(googleMapsUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Unable to open Google Maps")),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid coordinates")),
                );
              }
            },
            child: const ImageIcon(
              AssetImage("assets/icon/Location.png"),
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
