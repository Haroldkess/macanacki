import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';

class MyWebsite extends StatelessWidget {
  MyWebsite({super.key, required this.phone});
  TextEditingController phone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 30),
          child: Row(
            children: [
              AppText(
                  text: "Website",
                  fontWeight: FontWeight.w600,
                  size: 17,
                  color: textPrimary)
            ],
          ),
        ),
        Container(
          height: 50,
          width: 383,
          decoration: BoxDecoration(
              color: HexColor(backgroundColor),
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextFormField(
              controller: phone,
              maxLength: 11,
              cursorColor: textPrimary,
              keyboardType: TextInputType.name,
              // maxLines: null,
              style: GoogleFonts.roboto(
                color: textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.none,
                decorationThickness: 0,
              ),
              decoration: InputDecoration(
                hintText: "    Website",
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
