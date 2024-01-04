import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../uiproviders/screen/find_people_provider.dart';

class FollowSearch extends StatelessWidget {
  TextEditingController controller;
  FollowSearch({super.key, required this.controller, required this.onChanged});
  final Function(String value) onChanged;

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
        controller: controller,
        cursorColor: textPrimary,
        // onChanged: (val) {
        //   FindPeopleProvider search =
        //       Provider.of<FindPeopleProvider>(context, listen: false);
        //   search.search(val);
        // },
        style: GoogleFonts.roboto(color: HexColor("#C0C0C0"), fontSize: 14),

        onChanged: onChanged,
        decoration: InputDecoration(
            hintText: " Search",
            hintStyle:
                GoogleFonts.roboto(color: HexColor("#C0C0C0"), fontSize: 14),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: BorderSide(color: textPrimary)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: BorderSide(color: textPrimary)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: BorderSide(color: textPrimary))
            // disabledBorder: UnderlineInputBorder(
            //     borderRadius: BorderRadius.circular(2.0),
            //     borderSide: BorderSide(color: HexColor("#F5F2F9"))),
            // focusedBorder: OutlineInputBorder(
            //     borderRadius: BorderRadius.circular(2.0),
            //     borderSide: BorderSide(color: textPrimary)),
            ),
      ),
    );
  }
}
