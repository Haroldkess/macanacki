import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: non_constant_identifier_names
floatToast(String msg, Color color) {
  return Fluttertoast.showToast(
      msg: msg,
      backgroundColor: color,
      gravity: ToastGravity.TOP);
}
