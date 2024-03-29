import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';

class NoSearchFound extends StatelessWidget {
  const NoSearchFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 44,
          ),
          // SvgPicture.asset(
          //   "assets/icon/nouser.svg",
          //   // color: Colors.red,
          // ),

          Icon(
            Icons.warning,
            color: Colors.red,
            size: 50,
          ),
          const SizedBox(
            height: 15,
          ),
          AppText(
            text: "No Username Found",
            fontWeight: FontWeight.w600,
            size: 24,
            color: HexColor("#8B8B8B"),
          ),
          // const SizedBox(
          //   height: 40,
          // ),
          // AppText(
          //   text: "Please enter a valid username ",
          //   fontWeight: FontWeight.w400,
          //   size: 16,
          //   color: textPrimary,
          // ),
        ],
      ),
    );
  }
}
