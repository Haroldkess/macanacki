import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/form.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/gift_ware.dart';
import '../../../../../services/controllers/payment_controller.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/params.dart';
import '../../../../widgets/loader.dart';
// import 'package:macanacki/services/middleware/plan_ware.dart';
// import 'package:macanacki/services/middleware/user_profile_ware.dart';
// import 'package:provider/provider.dart';

giveDiamondsModal(BuildContext cont, String name,
    {String naration = ""}) async {
  bool pay = true;
  TextEditingController amount = TextEditingController();
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
            child: SingleChildScrollView(
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
                          //  color: HexColor(diamondColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AppText(
                          text: "Give Diamond",
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 18),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       SizedBox(
                  //         width: Get.width * 0.7,
                  //         child: AppFormAmount(
                  //           borderRad: 5.0,
                  //           backColor: Colors.transparent,
                  //           hint: "\$ Enter Amount",
                  //           hintColor: HexColor("#C0C0C0"),
                  //           controller: amount,
                  //           fontSize: 13,
                  //           textInputType: TextInputType.number,
                  //           max: 200,
                  //           min: 0,
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //           onTap: () {
                  //             if (amount.text.isNotEmpty) {
                  //               GiftWare.instance.doTransferOfDiamondsFromApi(
                  //                   name, amount.text, naration, cont);
                  //             }
                  //           },
                  //           child: Row(
                  //             children: [
                  //               Padding(
                  //                 padding:
                  //                     const EdgeInsets.only(right: 10, top: 5),
                  //                 child: Container(
                  //                     width: 32,
                  //                     height: 32,
                  //                     decoration: ShapeDecoration(
                  //                       color: Colors.white,
                  //                       shape: RoundedRectangleBorder(
                  //                         borderRadius:
                  //                             BorderRadius.circular(32),
                  //                       ),
                  //                     ),
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.all(3.0),
                  //                       child: Center(
                  //                         child: SvgPicture.asset(
                  //                           "assets/icon/Send.svg",
                  //                         ),
                  //                       ),
                  //                     )),
                  //               ),
                  //             ],
                  //           ))
                  //     ],
                  //   ),
                  // ),
               
               
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    color: Color(0xFFF5F2F8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ObxValue((load) {
                        return load.value
                            ? Visibility(
                                visible: load.value,
                                child: Loader(color: HexColor(primaryColor)),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  children: buy
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 105,
                                                  height: 44,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      AppText(
                                                        text: '${e.diamonds}',
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        size: 17,
                                                      ),
                                                      SizedBox(
                                                        width: 2,
                                                      ),
                                                      SvgPicture.asset(
                                                        "assets/icon/diamond.svg",
                                                        height: 13,
                                                        width: 13,
                                                        // color:
                                                        //     HexColor(diamondColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      GiftWare.instance
                                                          .doTransferOfDiamondsFromApi(
                                                              name,
                                                              e.diamonds!,
                                                              naration,
                                                              cont);
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 8),
                                                            child: Container(
                                                              width: 105,
                                                              height: 44,
                                                              decoration:
                                                                  ShapeDecoration(
                                                                color: Color(
                                                                    0xFFFC72A6),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: AppText(
                                                                  text:
                                                                      '\$${convertToCurrency(e.amount!)}',
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  size: 17,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Positioned(
                                                          right: -0,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 15,
                                                                      top: 5),
                                                              child: Container(
                                                                  width: 32,
                                                                  height: 32,
                                                                  decoration:
                                                                      ShapeDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              32),
                                                                    ),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            3.0),
                                                                    child:
                                                                        Center(
                                                                      child: SvgPicture
                                                                          .asset(
                                                                        "assets/icon/Send.svg",
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                              );
                      }, GiftWare.instance.loadTransfer),
                    ),
                  )
                ],
              ),
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
  BuyModel(diamonds: "50", amount: "1"),
  BuyModel(diamonds: "250", amount: "5"),
  BuyModel(diamonds: "500", amount: "10"),
  BuyModel(diamonds: "2500", amount: "50"),
  BuyModel(diamonds: "5000", amount: "100"),
];
