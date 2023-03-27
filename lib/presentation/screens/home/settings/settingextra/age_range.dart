import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/text.dart';

class AgeRangeSettings extends StatefulWidget {
  const AgeRangeSettings({super.key});

  @override
  State<AgeRangeSettings> createState() => _AgeRangeSettingsState();
}

class _AgeRangeSettingsState extends State<AgeRangeSettings> {
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
                    text: "Age Range",
                    color: HexColor("#0C0C0C"),
                    size: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AppText(
                    text: "Show only people within this range",
                    color: HexColor("#818181"),
                    size: 10,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(25),
                      color: HexColor("#EFEFEF"),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 7),
                      child: Row(
                        children: [
                          AppText(
                            text: "18 - 25",
                            color: HexColor(darkColor),
                            size: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Switch(
                    value: true,
                    activeColor: HexColor(primaryColor),
                    onChanged: (val) {},
                    // title: AppText(text: "Don’t show my Distance"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
