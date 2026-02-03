import 'package:flutter/material.dart';

class RouteSearchBar extends StatelessWidget {
  const RouteSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
          color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      cursorColor: const Color(0xffC3A6FF),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 30, right: 5),
          child: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        hintText: "Search by day...",
        hintStyle: const TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
        filled: true,
        fillColor: const Color(0xff23202A),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: const BorderSide(
              color: Color(0xffC3A6FF),
              width: 1,
            )),
      ),
    );
  }
}
