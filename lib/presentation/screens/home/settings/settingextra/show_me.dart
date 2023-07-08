import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/show_me_option.dart';
import 'package:macanacki/presentation/widgets/text.dart';

import '../../../../constants/colors.dart';

class ShowMeSettings extends StatelessWidget {
  const ShowMeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showMeOptionModal(context),
      child: Container(
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
                      text: "Show Me",
                      color: HexColor("#0C0C0C"),
                      size: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    AppText(
                      text: "All",
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
      ),
    );
  }
}
