import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/text.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/params.dart';
// import 'package:macanacki/services/middleware/plan_ware.dart';
// import 'package:macanacki/services/middleware/user_profile_ware.dart';
// import 'package:provider/provider.dart';

buyDiamondsModal(
  BuildContext cont,
) async {
  bool pay = true;
  return showModalBottomSheet(
      context: cont,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        // PlanWare stream = context.watch<PlanWare>();
        // UserProfileWare user = context.watch<UserProfileWare>();
        // PlanWare action = Provider.of<PlanWare>(context,listen: false);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icon/diamond.svg",
                        height: 30,
                        width: 30,
                        color: HexColor(diamondColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AppText(
                        text: "Buy Diamond",
                        size: 17,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 202,
                        child: AppText(
                          text:
                              "Diamonds are gift sent to creators to show appreciation for their content.",
                          size: 13,
                          fontWeight: FontWeight.w400,
                          align: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 38,
                ),
                Container(
                  color: Color(0xFFF5F2F8),
                  child: Column(
                    children: buy
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 105,
                                    height: 44,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppText(
                                          text: '${e.diamonds}',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          size: 17,
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        SvgPicture.asset(
                                          "assets/icon/diamond.svg",
                                          height: 13,
                                          width: 13,
                                          color: HexColor(diamondColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 105,
                                    height: 44,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFFC72A6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: AppText(
                                        text:
                                            '\$${convertToCurrency(e.amount!)}',
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                        size: 17,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        );
      });
}

class BuyModel {
  String? diamonds;
  String? amount;
  BuyModel({required this.diamonds, required this.amount});
}

List<BuyModel> buy = [
  BuyModel(diamonds: "50", amount: "1.00"),
  BuyModel(diamonds: "50", amount: "1.00"),
  BuyModel(diamonds: "50", amount: "1.00")
];
