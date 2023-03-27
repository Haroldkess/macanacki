import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../../constants/colors.dart';
import '../../../../../model/ui_model.dart';
import '../../../../../widgets/text.dart';

chatOptionModal(BuildContext context) async {
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
                    height: 10,
                  ),
                  Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: chatOption
                        .map((e) => ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: AppText(
                                  text: e.name,
                                  color: HexColor(darkColor),
                                  size: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          ));
}