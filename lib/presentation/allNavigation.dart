
import 'package:flutter/material.dart';



class PageRouting {
  static void pushToPage(BuildContext context, Widget page) {
 
 
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  static void popToPage(BuildContext context) {
    Navigator.pop(context);
  }

  static void removePreviousToPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static void removeAllToPage(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page), (route) => false);
  }
}
