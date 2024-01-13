import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/widgets/form.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/gift_ware.dart';
import 'package:provider/provider.dart';
import '../../../../../services/controllers/buy_followers_controller.dart';
import '../../../../../services/controllers/payment_controller.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/params.dart';
import '../../../../widgets/loader.dart';
// import 'package:macanacki/services/middleware/plan_ware.dart';
// import 'package:macanacki/services/middleware/user_profile_ware.dart';
// import 'package:provider/provider.dart';

buyFollowersModal(BuildContext cont) async {
  bool pay = true;
  TextEditingController amount = TextEditingController();
  return showModalBottomSheet(
      context: cont,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: HexColor(backgroundColor),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        // PlanWare stream = context.watch<PlanWare>();
        UserProfileWare buyFollowers = context.watch<UserProfileWare>();
        // PlanWare action = Provider.of<PlanWare>(context,listen: false);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.clear,
                            color: textPrimary,
                          ))
                    ],
                  ),
                  Container(
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(
                        //   "assets/icon/diamond.svg",
                        //   height: 30,
                        //   width: 30,
                        //   //  color: HexColor(diamondColor),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        AppText(
                          text: "Buy Followers",
                          size: 17,
                          fontWeight: FontWeight.w400,
                          color: textWhite,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 300,
                          child: AppText(
                            text:
                                "Get more for you account. Reach users accross macanacki with increased visibility. ",
                            size: 13,
                            fontWeight: FontWeight.w400,
                            align: TextAlign.center,
                            color: textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  buyFollowers.isLoadPromote
                      ? Loader(color: textWhite)
                      : Container(
                          color: HexColor(backgroundColor),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: buy
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: InkWell(
                                              onTap: () async {
                                                await BuyFollowersController
                                                    .buyFollowers(
                                                        context, e.diamonds);
                                              },
                                              child: Container(
                                                height: 70,
                                                decoration: BoxDecoration(
                                                    color: backgroundSecondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AppText(
                                                        text:
                                                            "${e.amount} Followers",
                                                        color: textWhite,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        size: 17,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/icon/diamond.svg",
                                                            height: 13,
                                                            width: 13,
                                                            // color:
                                                            //     HexColor(diamondColor),
                                                          ),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          AppText(
                                                            text:
                                                                '${convertToCurrency(e.diamonds!)}',
                                                            color: textWhite,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            size: 17,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              )),
                        )
                ],
              ),
            ),
          ),
        );
      });
}

class BuyFollowersModel {
  String? diamonds;
  String? amount;
  BuyFollowersModel({required this.diamonds, required this.amount});
}

List<BuyFollowersModel> buy = [
  BuyFollowersModel(diamonds: "1000", amount: "10k"),
  BuyFollowersModel(diamonds: "2500", amount: "25k"),
  BuyFollowersModel(diamonds: "4500", amount: "50k"),
  BuyFollowersModel(diamonds: "7500", amount: "100k"),
];
