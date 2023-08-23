import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/services/middleware/ads_ware.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/params.dart';
import '../../../../widgets/text.dart';

priceOptionModal(BuildContext context) async {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //   height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        AppText(
                          text: "Select budget",
                          color: HexColor(darkColor),
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
                    // mainAxisSize: MainAxisSize.min,
                    children: context
                        .watch<AdsWare>()
                        .adsPrice
                        .map((e) => InkWell(
                              onTap: () async {
                                Provider.of<AdsWare>(context, listen: false)
                                    .selectCat(e);
                                PageRouting.popToPage(context);
                              },
                              child: SizedBox(
                                height: 30,
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      AppText(
                                        text:
                                            "Price: N${convertToCurrency(e.price.toString())}",
                                        fontWeight: FontWeight.w500,
                                        size: 14,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      AppText(
                                        text:
                                            "Reach: ${convertToCurrency(e.reach.toString())}",
                                        fontWeight: FontWeight.w500,
                                        size: 14,
                                      ),
                                    ],
                                  ),
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
