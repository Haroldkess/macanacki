import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/services/controllers/search_controller.dart';

import '../../../../constants/colors.dart';

class GlobalSearchBar extends StatelessWidget {
  TextEditingController x;

  GlobalSearchBar({
    super.key,
    required this.x,
  });

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
        controller: x,
        cursorColor: HexColor(primaryColor),
        enableSuggestions: false,
        autocorrect: false,
        onChanged: (value) async {
          // if (value.isEmpty) {
          //   return;
          // }
          await Future.delayed(const Duration(milliseconds: 900)).whenComplete(
              () =>
                  SearchController.retrievSearchUserController(context, value));
        },
        decoration: InputDecoration(
          hintText: " Search",
          hintStyle:
              GoogleFonts.spartan(color: HexColor("#C0C0C0"), fontSize: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
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
