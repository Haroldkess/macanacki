import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';

class EditAboutMe extends StatelessWidget {
  EditAboutMe({super.key, required this.about});
  TextEditingController about;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 30),
          child: Row(
            children: [
              AppText(
                text: "About Me",
                fontWeight: FontWeight.w600,
                size: 17,
                color: textPrimary,
              )
            ],
          ),
        ),
        Container(
          height: 99,

          //width: 383,
          decoration: BoxDecoration(
              color: HexColor(backgroundColor),
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(0))),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: TextFormField(
              controller: about,
              maxLength: 120,
              cursorColor: textPrimary,
              keyboardType: TextInputType.text,
              maxLines: null,
              style: GoogleFonts.roboto(
                color: textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
                decorationThickness: 0,
              ),
              decoration: InputDecoration(
                hintText: "     Say something about yourself...",
                hintStyle: GoogleFonts.roboto(
                    color: textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                suffixIcon: null,
                prefixIcon: null,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
