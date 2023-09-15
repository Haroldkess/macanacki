import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/operations.dart';

class ConvoSearch extends StatelessWidget {
  TextEditingController controller;
  ConvoSearch({super.key, required this.controller});

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
        controller: controller,
        onChanged: (val) {
          Operations.searchInConversations(context, val);
        },
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: "  Search Conversations",
          hintStyle: GoogleFonts.leagueSpartan(
              color: Color.fromRGBO(0, 0, 0, 0.4), fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              "assets/icon/searchicon.svg",
              height: 5,
              width: 5,
              color: Color.fromRGBO(0, 0, 0, 0.4),
            ),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
