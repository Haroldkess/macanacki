import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/widgets/text.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402,
      height: 70,
      color: HexColor(backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppText(
            text: "Logout",
            color: HexColor("#0C0C0C"),
            fontWeight: FontWeight.w400,
            size: 16,
          )
        ],
      ),
    );
  
  }
}
