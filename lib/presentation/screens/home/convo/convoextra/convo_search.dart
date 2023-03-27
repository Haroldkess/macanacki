import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';

class ConvoSearch extends StatelessWidget {
  const ConvoSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      //width: 383,
      decoration: BoxDecoration(
          color: HexColor(backgroundColor),
          shape: BoxShape.rectangle,
          border: Border.all(
              width: 1.0, color: HexColor("#E8E6EA"), style: BorderStyle.solid),
          borderRadius: const BorderRadius.all(Radius.circular(8.0))),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "  Search Conversations",
          hintStyle: GoogleFonts.spartan(
              color: Color.fromRGBO(0, 0, 0, 0.4), fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              "assets/icon/searchicon.svg",
              height: 5,
              width: 5,
              color: Color.fromRGBO(0, 0, 0, 0.4),
            ),
          ),
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
      ),
    
    
    );
  }
}
