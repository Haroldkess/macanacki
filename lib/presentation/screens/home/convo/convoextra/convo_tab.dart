import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/widgets/buttons.dart';
import 'package:makanaki/presentation/widgets/text.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/params.dart';

class ConvoTab extends StatefulWidget {
  const ConvoTab({super.key});

  @override
  State<ConvoTab> createState() => _ConvoTabState();
}

class _ConvoTabState extends State<ConvoTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      width: 386,
      decoration: BoxDecoration(
          color: HexColor("#F5F2F9"),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          shape: BoxShape.rectangle),
      child: Row(
        children: [
          const SizedBox(
            width: 11,
          ),
          AppButton(
              width: 0.3,
              height: 0.05,
              color: primaryColor,
              text: "Matches",
              backColor: backgroundColor,
              curves: buttonCurves * 5,
              textColor: primaryColor,
              onTap: () {
                //  PageRouting.pushToPage(context, const VerifiedInfo());
              }),
          const SizedBox(
            width: 30,
          ),
          Container(
            width: 130,
            child: Row(
              children: [
                AppText(
                  text: "New Request",
                  color: HexColor("#5F5F5F"),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: HexColor(primaryColor), shape: BoxShape.circle),
                  child: Padding(    
                    padding: const EdgeInsets.all(5.0),
                    child: AppText(
                      text: "2",
                      color: HexColor(backgroundColor),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
