import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../../../services/middleware/ads_ware.dart';
import '../../../../allNavigation.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/text.dart';

List duration = ["1-5 days", "1-10 days"];

durationOptionModal(BuildContext context) async {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: HexColor(backgroundColor),
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
                          text: "Select Duration",
                          color: textWhite,
                          size: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                    children: duration
                        .map((e) => InkWell(
                              onTap: () async {
                                Provider.of<AdsWare>(context, listen: false)
                                    .addDuration(e);
                                PageRouting.popToPage(context);
                              },
                              child: SizedBox(
                                height: 30,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    AppText(
                                      text: e,
                                      color: textPrimary,
                                      size: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ));
}
