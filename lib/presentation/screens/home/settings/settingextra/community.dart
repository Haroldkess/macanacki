import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/widgets/text.dart';

import '../../../../constants/colors.dart';

class CoumunityHandles extends StatelessWidget {
  const CoumunityHandles({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 30),
          child: Row(
            children: [
              AppText(
                text: "Community",
                fontWeight: FontWeight.w400,
                size: 20,
                color: HexColor("#0C0C0C"),
              )
            ],
          ),
        ),
        Container(
          //     height: 87,
          width: 402,
          color: HexColor(backgroundColor),
          alignment: Alignment.center,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: socialHandles
                    .map((e) => ListTile(
                          leading: SvgPicture.asset(e.iconPath),
                          title: AppText(
                            text: e.title,
                            fontWeight: FontWeight.w400,
                            size: 16,
                            color: HexColor("#0C0C0C"),
                          ),
                        ))
                    .toList(),
              )),
        ),
      ],
    );
  }
}
