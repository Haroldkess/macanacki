import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../operations.dart';
import '../../../../uiproviders/screen/gender_provider.dart';
import '../../../../widgets/text.dart';

class DiscoverySettings extends StatefulWidget {
  const DiscoverySettings({super.key});

  @override
  State<DiscoverySettings> createState() => _DiscoverySettingsState();
}

class _DiscoverySettingsState extends State<DiscoverySettings> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 30),
          child: Row(
            children: [
              AppText(
                text: "Discovery Settings",
                fontWeight: FontWeight.w400,
                size: 20,
                color: HexColor("#0C0C0C"),
              )
            ],
          ),
        ),
        Container(
          // height: 330,
          color: HexColor(backgroundColor),
          child: Column(
            children: [
              Container(
                height: 180,
                //   color: Colors.amber,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: context
                      .watch<GenderProvider>()
                      .locationSetting
                      .map((e) => e.isSelected
                          ? ListTile(
                              onTap: () {
                                Operations.selectDescoveryOption(
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
                                Operations.selectDescoveryOption(
                                    context, e.id, true);
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
                              text: "Global Location",
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
                                text: "See People around the world",
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
                              value: false,
                              onChanged: (val) {},
                              // title: AppText(text: "Don’t show my Distance"),
                            ),
                          ],
                        )
                      ],
                    ),
                  
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: "Maximum Distance",
                              color: HexColor("#0C0C0C"),
                              size: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            AppText(
                              text: "50 Kil",
                              color: HexColor("#0C0C0C"),
                              size: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Slider(
                            activeColor: HexColor(primaryColor),
                            inactiveColor: HexColor("#DADADA"),
                            min: 0,
                            max: 100,
                            value: 50.00,
                            onChanged: (value) {})
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: "Show only people within this range",
                              color: HexColor("#818181"),
                              size: 10,
                              fontWeight: FontWeight.w400,
                            ),
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
      ],
    );
  }
}
