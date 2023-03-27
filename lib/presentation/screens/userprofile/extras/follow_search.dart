import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../constants/colors.dart';

class FollowSearch extends StatelessWidget {
  const FollowSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      //width: 383,
      decoration: BoxDecoration(
          color: HexColor(backgroundColor),
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(8.0))),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: " Search",
          hintStyle:
              GoogleFonts.spartan(color: HexColor("#C0C0C0"), fontSize: 14),
          border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: const BorderSide(color: Colors.transparent)),
          disabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: BorderSide(color: HexColor("#F5F2F9"))),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: BorderSide(color: HexColor(primaryColor))),
        ),
      ),
    );
  }
}
