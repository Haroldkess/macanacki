import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/text.dart';

class AppSettingsNotification extends StatefulWidget {
  const AppSettingsNotification({super.key});

  @override
  State<AppSettingsNotification> createState() =>
      _AppSettingsNotificationState();
}

class _AppSettingsNotificationState extends State<AppSettingsNotification> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 30),
          child: Row(
            children: [
              AppText(
                text: "App Settings",
                fontWeight: FontWeight.w400,
                size: 20,
                color: HexColor("#0C0C0C"),
              )
            ],
          ),
        ),
        Container(
          height: 160,
          width: 402,
          color: HexColor(backgroundColor),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                            text: "Email ",
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
                              text: "Receive notifications via email",
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
                          Checkbox(
                              activeColor: HexColor(primaryColor),
                              value: true,
                              onChanged: (val) {})
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
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
                            text: "Push Notifications",
                            color: HexColor("#0C0C0C"),
                            size: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: AppText(
                              text: "Receive inapp notifications",
                              color: HexColor("#818181"),
                              size: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Checkbox(
                              activeColor: HexColor(primaryColor),
                              value: true,
                              onChanged: (val) {})
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
