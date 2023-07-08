import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';

import '../constants/params.dart';

class AppButton extends StatelessWidget {
  final double width;
  final double height;
  final String color;
  final String text;
  final String backColor;
  VoidCallback onTap;
  final String textColor;
  final double curves;
  AppButton(
      {super.key,
      required this.width,
      required this.height,
      required this.color,
      required this.text,
      required this.backColor,
      required this.onTap,
      required this.curves,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor:
                backColor != "null" ? HexColor(backColor) : Colors.transparent,
            fixedSize: Size(_width * width, _height * height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(curves),
            ),
            side: BorderSide(
                color: HexColor(color), width: 1.0, style: BorderStyle.solid)),
        onPressed: onTap,
        child: AppText(
          text: text,
          scaleFactor: 0.8,
          color: HexColor(textColor),
          fontWeight: FontWeight.w500,
        ));
  }
}
