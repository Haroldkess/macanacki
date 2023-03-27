import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/operations.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../uiproviders/screen/gender_provider.dart';
import '../../../../widgets/text.dart';

showMeOptionModal(BuildContext context) async {
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
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        AppText(
                          text: "Show me",
                          color: HexColor(darkColor),
                          size: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: context
                        .watch<GenderProvider>()
                        .showMe
                        .map((e) => ListTile(
                              onTap: () => Operations.selectShowMeOption(
                                  context, e.id, true),
                              title: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: AppText(
                                  text: e.title,
                                  color: e.isSelected
                                      ? HexColor("#6339BA")
                                      : HexColor(darkColor),
                                  size: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              trailing: e.isSelected
                                  ? Icon(
                                      Icons.done,
                                      color: HexColor("#6339BA"),
                                    )
                                  : null,
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          ));
}
