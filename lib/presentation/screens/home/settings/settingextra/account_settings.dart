import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../constants/colors.dart';
import '../../../../widgets/text.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 30),
          child: Row(
            children: [
              AppText(
                text: "Account Settings",
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
                            text: "Phone Number",
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
                                  "Verity  phone number to secure your account",
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
                          AppText(
                            text: "+23450696 6695",
                            color: HexColor("#7A7A7A"),
                            size: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            child: AppText(
                              text: "Verify",
                              color: HexColor(primaryColor),
                              size: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          )
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
                            text: "Email",
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
                              text:
                                  "Verity  phone number to secure your account",
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
                          AppText(
                            text: "Maggidestinforyou@gmail.com",
                            color: HexColor("#7A7A7A"),
                            size: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          AppText(
                            text: "Update",
                            color: HexColor(primaryColor),
                            size: 12,
                            fontWeight: FontWeight.w400,
                          )
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
