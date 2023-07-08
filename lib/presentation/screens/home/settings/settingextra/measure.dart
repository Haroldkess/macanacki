import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/option_measure_kilo.dart';
import 'package:macanacki/presentation/widgets/text.dart';

class MeasureDistanceSelect extends StatelessWidget {
  const MeasureDistanceSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402,
      color: HexColor(backgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: "Measure Distance in",
                  color: HexColor("#0C0C0C"),
                  size: 14,
                  fontWeight: FontWeight.w400,
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: AppText(
                    text: "Choose your preferred meaurement Unit",
                    color: HexColor("#818181"),
                    size: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.2,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(24),
                    color: HexColor(primaryColor),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            AppText(
                              text: "Km.",
                              color: HexColor(backgroundColor),
                              size: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.2,
                            ),
                            AppText(
                              text: "Kilometers",
                              color: HexColor("#818181"),
                              size: 9,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.2,
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: HexColor(backgroundColor)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.done,
                              color: HexColor(
                                primaryColor,
                              ),
                              size: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => measureOptionModal(context),
                  child: Container(
                    width: 130,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(24),
                        color: HexColor(backgroundColor),
                        border: Border.all(
                            color: HexColor("#979797"),
                            style: BorderStyle.solid)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              AppText(
                                text: "Mi.",
                                color: HexColor("#979797"),
                                size: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.2,
                              ),
                              AppText(
                                text: "Miles",
                                color: HexColor("#979797"),
                                size: 9,
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.2,
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor(backgroundColor)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              // child: Icon(
                              //   Icons.done,
                              //   color: HexColor(
                              //     primaryColor,
                              //   ),
                              //   size: 16,
                              // ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
