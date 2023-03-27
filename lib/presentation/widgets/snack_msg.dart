import 'package:flutter/material.dart';

Future<void> showToast(
    BuildContext context, String message, Color textColor) async {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style:  TextStyle(
          color: textColor.withOpacity(0.6), fontWeight: FontWeight.w400, fontSize: 16.0),
    ),
    elevation: 20,
    
    behavior: SnackBarBehavior.floating,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    width: MediaQuery.of(context).size.width * 0.8,
    
    backgroundColor: Colors.white,
  ));
}
