import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/screens/home/diamond/diamond_modal/add_bank.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/gift_ware.dart';
import '../../../../../services/controllers/payment_controller.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/params.dart';
import '../../../../widgets/loader.dart';
// import 'package:macanacki/services/middleware/plan_ware.dart';
// import 'package:macanacki/services/middleware/user_profile_ware.dart';
// import 'package:provider/provider.dart';

bankModal(
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
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SvgPicture.asset(
                      //   "assets/icon/bank.svg",
                      //   height: 30,
                      //   width: 30,
                      //   color: HexColor(diamondColor),
                      // ),

                      SizedBox(
                        height: 10,
                      ),
                      AppText(
                        text: "Select your bank",
                        size: 17,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   width: 202,
                      //   child: AppText(
                      //     text: "",
                      //     size: 13,
                      //     fontWeight: FontWeight.w400,
                      //     align: TextAlign.center,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 38,
                ),
                Container(
                  color: Color(0xFFF5F2F8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: GiftWare.instance.banks.value.data!
                          .map((e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    PageRouting.popToPage(context);
                                    addBankModal(
                                        context, e.id!, e.name!, e.shortName!);
                                  },
                                  child: Container(
                                    height: 50,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AppText(
                                              text: e.shortName!,
                                              size: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            AppText(
                                              text: e.name!,
                                              size: 13,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}

myBankModal(
  BuildContext cont,
) async {
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
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SvgPicture.asset(
                      //   "assets/icon/bank.svg",
                      //   height: 30,
                      //   width: 30,
                      //   color: HexColor(diamondColor),
                      // ),

                      SizedBox(
                        height: 10,
                      ),
                      AppText(
                        text: "My bank",
                        size: 17,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Container(
                      //   width: 202,
                      //   child: AppText(
                      //     text: "",
                      //     size: 13,
                      //     fontWeight: FontWeight.w400,
                      //     align: TextAlign.center,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 38,
                ),
                Container(
                  color: Color(0xFFF5F2F8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                PageRouting.popToPage(context);
                                bankModal(cont);
                              },
                              child: AppText(
                                text: "Change",
                                size: 18,
                                fontWeight: FontWeight.w700,
                                color: HexColor(primaryColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 160,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                  stops: [
                                    0,
                                    1,
                                    1,
                                    1
                                  ],
                                  colors: [
                                    Colors.black,
                                    Colors.black,
                                    Colors.black,
                                    Colors.grey,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomLeft)),
                          child: ObxValue((bank) {
                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            AppText(
                                              text: bank.value.accountNumber!,
                                              size: 24,
                                              fontWeight: FontWeight.w700,
                                              color: HexColor(backgroundColor),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            AppText(
                                              text: bank.value.name!,
                                              size: 16,
                                              fontWeight: FontWeight.w700,
                                              color: HexColor(backgroundColor),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            AppText(
                                              text: bank.value.bankName!,
                                              size: 14,
                                              fontWeight: FontWeight.w700,
                                              color: HexColor(backgroundColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Stack(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                          ),
                                          Positioned(
                                            bottom: -7,
                                            left: 5,
                                            child: SvgPicture.asset(
                                                "assets/icon/crown.svg",
                                                color: Colors.white,
                                                height: 30,
                                                width: 30),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }, GiftWare.instance.myLocalBank),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      });
}
