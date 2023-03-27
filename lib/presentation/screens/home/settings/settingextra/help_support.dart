import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/text.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 87,
      width: 402,
      color: HexColor(backgroundColor),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Align(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: "Help and Support",
                    color: HexColor("#0C0C0C"),
                    size: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AppText(
                    text: "Visit the help and support center",
                    color: HexColor("#818181"),
                    size: 10,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [SvgPicture.asset("assets/icon/fowardarrow.svg")],
              )
            ],
          ),
        ),
      ),
    );
  
  }
}