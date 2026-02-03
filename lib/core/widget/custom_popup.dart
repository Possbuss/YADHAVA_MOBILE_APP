import 'package:flutter/material.dart';

class CustomPopup extends StatelessWidget {
  final String message;
  const CustomPopup({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child:Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize:MainAxisSize.min ,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            const Icon(Icons.check_circle,color: Colors.green,size: 100,),
            Text(message, style: const TextStyle(fontSize: 20),)
          ],
        ),
      ) ,
    );
  }
}
