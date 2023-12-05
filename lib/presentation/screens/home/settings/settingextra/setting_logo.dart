import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';

class SettingLogo extends StatelessWidget {
  const SettingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/icon/crown-latest.svg",
          width: 42.77,
          height: 28.48,
          //  color: HexColor(primaryColor),
        ),
        const SizedBox(
          height: 10,
        ),
        // AppText(
        //   text: "Version 1.322",
        //   color: HexColor("#A8A8A8"),
        //   size: 16,
        //   fontWeight: FontWeight.w400,
        // )
      ],
    );
  }
}
