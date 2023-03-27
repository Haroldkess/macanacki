import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/text.dart';

class EditStudies extends StatelessWidget {
  const EditStudies({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 30),
          child: Row(
            children: [
              AppText(
                text: "Studies",
                fontWeight: FontWeight.w400,
                size: 20,
                color: HexColor("#0C0C0C"),
              )
            ],
          ),
        ),
        Stack(
          children: [
            Container(
              height: 99,

              //width: 383,
              decoration: BoxDecoration(
                  color: HexColor(backgroundColor),
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(0))),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                child: TextFormField(
                  style: GoogleFonts.overpass(
                      color: HexColor("#D9D9D9"),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: "    Where did you study?...",
                    hintStyle: GoogleFonts.overpass(
                        color: HexColor("#8B8B8B"),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    suffixIcon: null,
                    prefixIcon: null,
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide:
                            const BorderSide(color: Colors.transparent)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10.1,
              right: 10.1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        color: HexColor(primaryColor),
                        shape: BoxShape.rectangle,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      child: AppText(
                        text: "Add School",
                        color: HexColor(backgroundColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
