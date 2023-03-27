import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../constants/colors.dart';

class ChatForm extends StatelessWidget {
  const ChatForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 10,
      shadowColor: HexColor("#D8D1F4"),
      child: Container(
        height: 58,
        width: 379,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: HexColor(backgroundColor),
            shape: BoxShape.rectangle,
            border: Border.all(
                width: 1.0,
                color: HexColor("#E8E6EA"),
                style: BorderStyle.solid),
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: "  Your message",
            hintStyle:
                GoogleFonts.spartan(color: HexColor("#8B8B8B"), fontSize: 14),
            contentPadding: EdgeInsets.only(top: 15),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                "assets/icon/sticker.svg",
                height: 5,
                width: 5,
                color: const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                "assets/icon/Send.svg",
                height: 5,
                width: 5,
                color: const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            ),
            border: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: const BorderSide(color: Colors.transparent)),
          ),
        ),
      ),
    );
  
  
  }
}
