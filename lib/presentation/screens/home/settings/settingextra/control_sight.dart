import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/uiproviders/screen/gender_provider.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:provider/provider.dart';

import '../../../../operations.dart';

class ControlSight extends StatefulWidget {
  const ControlSight({super.key});

  @override
  State<ControlSight> createState() => _ControlSightState();
}

class _ControlSightState extends State<ControlSight> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //  height: 394,
      width: 403,
      color: HexColor(backgroundColor),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 30, top: 20),
              child: Row(
                children: [
                  AppText(
                    text: "Control who you see",
                    fontWeight: FontWeight.w400,
                    size: 20,
                    color: HexColor("#2C2C2C"),
                  )
                ],
              ),
            ),
            Container(
              height: 220,
              //   color: Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: context
                    .watch<GenderProvider>()
                    .sightSettings
                    .map((e) => e.isSelected
                        ? ListTile(
                            onTap: () {
                              Operations.selectSightOption(
                                  context, e.id, false);
                            },
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                    border: Border.all(
                                        width: e.isSelected ? 5 : 1,
                                        color: e.isSelected
                                            ? HexColor(primaryColor)
                                            : HexColor("#C0C0C0"),
                                        style: BorderStyle.solid)),
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: AppText(
                                text: e.title,
                                color: HexColor("#0C0C0C"),
                                size: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: AppText(
                              text: e.subtitle,
                              fontWeight: FontWeight.w400,
                              size: 10,
                              color: HexColor("#818181"),
                            ),
                          )
                        : ListTile(
                            onTap: () {
                              Operations.selectSightOption(context, e.id, true);
                            },
                            leading: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: e.isSelected ? 5 : 1,
                                        color: e.isSelected
                                            ? HexColor(primaryColor)
                                            : HexColor("#C0C0C0"),
                                        style: BorderStyle.solid)),
                              ),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: AppText(
                                text: e.title,
                                color: HexColor("#0C0C0C"),
                                size: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            subtitle: AppText(
                              text: e.subtitle,
                              fontWeight: FontWeight.w400,
                              size: 10,
                              color: HexColor("#818181"),
                            ),
                          ))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: "Show me on MacaNacki",
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
                              text:
                                  "While off, People you liked or matched with will still and chat with you.",
                              color: HexColor("#818181"),
                              size: 10,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.2,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
