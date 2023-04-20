import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/widgets/text.dart';

class MyPhone extends StatelessWidget {
  MyPhone({super.key, required this.phone});
  TextEditingController phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 400,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16, left: 30),
            child: Row(
              children: [
                AppText(
                  text: "Phone Number",
                  fontWeight: FontWeight.w600,
                  size: 17,
                  color: HexColor("#0C0C0C"),
                )
              ],
            ),
          ),
          Container(
            height: 70,
            width: 383,
            decoration: BoxDecoration(
                color: HexColor(backgroundColor),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(0))),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: phone,
                maxLength: 11,
                cursorColor: HexColor(primaryColor),
                keyboardType: TextInputType.phone,
                // maxLines: null,
                style: GoogleFonts.overpass(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.none,
                  decorationThickness: 0,
                ),
                decoration: InputDecoration(
                  hintText: "    Phone",
                  hintStyle: GoogleFonts.overpass(
                      color: HexColor("#8B8B8B"),
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
      ),
    );
  }
}
