import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/operations.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../uiproviders/screen/gender_provider.dart';
import '../../../../widgets/text.dart';

measureOptionModal(BuildContext context) async {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Row(
                      children: [
                        AppText(
                          text: "Measure in Kilometers",
                          color: HexColor(darkColor),
                          size: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: Row(
                      children: [
                        AppText(
                          text: "Change your measurement unit to Kilometers?",
                          color: HexColor(darkColor),
                          size: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 130,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: 205,
                      height: 41,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppText(
                            text: "Yes",
                            color: HexColor("#6339BA"),
                            size: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          AppText(
                            text: "No",
                            color: HexColor(darkColor),
                            size: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
}
