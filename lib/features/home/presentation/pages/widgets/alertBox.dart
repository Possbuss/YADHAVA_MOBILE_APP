import 'package:flutter/material.dart';

import '../../../../../core/constants/color.dart';
import '../../../../../core/constants/textthemes.dart';

Future<dynamic> alertBox(
    {BuildContext? context,
    String? title,
    Widget? content,
    String? leftBtnName,
    String? rightBtnName,
    VoidCallback? leftBtnTap,
    VoidCallback? rightBtnTap}) {
  return showDialog(
    barrierColor: const Color.fromARGB(72, 0, 0, 0),
    context: context!,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colour.lightblack,
      contentTextStyle: const TextStyle(
          color: Colors.white70, fontWeight: FontWeight.w400, fontSize: 16),
      shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Colour.SilverGrey, width: 2),
          borderRadius: BorderRadius.circular(20)),
      title: Text(
        title!,
        style: AppTextThemes.appbarHomeHeading
      ),
      content: content,
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: const Color.fromARGB(255, 48, 47, 47),
              ),
              child: ElevatedButton(
                  onPressed: leftBtnTap,
                  child: Text(leftBtnName!,
                      style: AppTextThemes.h8)),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        width: 2, color: Colour.SilverGrey)),
                onPressed: rightBtnTap,
                child: Text(
                  rightBtnName!,
                  style:AppTextThemes.h4
                ),
              ),
            ),
          ],
        ),

        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: OutlinedButton(
        //     style: OutlinedButton.styleFrom(
        //         side: const BorderSide(
        //             width: 2, color: Color.fromARGB(255, 3, 118, 22))),
        //     onPressed: leftBtnTap,
        //     child: Text(
        //       leftBtnName!,
        //       style: const TextStyle(
        //           color: Color.fromARGB(255, 0, 0, 0),
        //           fontWeight: FontWeight.w600),
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   width: 10,
        // ),
        // Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(18),
        //     color: Color.fromARGB(255, 48, 47, 47),
        //   ),
        //   child: ElevatedButton(
        //       onPressed: rightBtnTap,
        //       child: Text(rightBtnName!,
        //           style: const TextStyle(
        //               color: Color.fromARGB(255, 0, 0, 0),
        //               fontWeight: FontWeight.w600))),
        // ),
      ],
    ),
  );
}