import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/text.dart';

import '../../../../constants/colors.dart';

class ManagePayment extends StatelessWidget {
  const ManagePayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 30),
          child: Row(
            children: [
              AppText(
                text: "Manage Payment Account",
                fontWeight: FontWeight.w400,
                size: 20,
                color: HexColor("#0C0C0C"),
              )
            ],
          ),
        ),
        Container(
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
                        text: "Active Payment Account",
                        color: HexColor("#0C0C0C"),
                        size: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      AppText(
                        text: "Google Pay",
                        color: HexColor("#818181"),
                        size: 10,
                        fontWeight: FontWeight.w400,
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [SvgPicture.asset("assets/icon/fowardarrow.svg")],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
