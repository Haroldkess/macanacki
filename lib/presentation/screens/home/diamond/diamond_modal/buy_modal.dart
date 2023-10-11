import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/text.dart';

import '../../../../../services/controllers/payment_controller.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/params.dart';
import '../../../../widgets/form.dart';
import '../../../../widgets/snack_msg.dart';
// import 'package:macanacki/services/middleware/plan_ware.dart';
// import 'package:macanacki/services/middleware/user_profile_ware.dart';
// import 'package:provider/provider.dart';

buyDiamondsModal(BuildContext cont, rate) async {
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
                          text: "Buy Diamond",
                          size: 17,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.width * 0.7,
                          child: AppFormAmount(
                            borderRad: 5.0,
                            backColor: Colors.transparent,
                            hint: "\$Enter Amount",
                            hintColor: HexColor("#C0C0C0"),
                            controller: amount,
                            fontSize: 13,
                            textInputType: TextInputType.number,
                            max: 1000,
                            min: 0,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              if (amount.text.isNotEmpty) {
                                if (int.tryParse(amount.text)! < 10) {
                                  showToast2(context, "Minimum is \$10");
                                  return;
                                } else {
                                  buyGiftPaystackModal(
                                      context, rate, amount.text);
                                }
                              }
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10, top: 5),
                                  child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            "assets/icon/Send.svg",
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    color: Color(0xFFF5F2F8),
                    child: Column(
                      children: buy
                          .map((e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                            // color: HexColor(diamondColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        buyGiftPaystackModal(
                                            context, rate, e.amount!);
                                      },
                                      child: Container(
                                        width: 105,
                                        height: 44,
                                        decoration: ShapeDecoration(
                                          color: Color(0xFFFC72A6),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
          ),
        );
      });
}

buyGiftPaystackModal(BuildContext context, rate, String money,
    [String? id]) async {
  var width = MediaQuery.of(context).size.width;
  return showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        // PlanWare action = Provider.of<PlanWare>(context,listen: false);
        return Container(
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      text: "Payment Method",
                      color: HexColor(darkColor),
                      size: 17,
                      fontWeight: FontWeight.w700,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          fixedSize: Size(width * 0.49, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          side: BorderSide(
                              color: HexColor("#C0C0C0"),
                              width: 1.0,
                              style: BorderStyle.solid)),
                      onPressed: () async {
                        int amount =
                            (double.tryParse(rate.toString())!.toInt() *
                                    double.tryParse(money)!.toInt()) *
                                100;
                        await PaymentController.chargeForDiamonds(
                          context,
                          amount,
                        );
                      },
                      child: SvgPicture.asset("assets/icon/P.svg")),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          fixedSize: Size(width * 0.49, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          side: BorderSide(
                              color: HexColor("#C0C0C0"),
                              width: 1.0,
                              style: BorderStyle.solid)),
                      onPressed: () {
                        showToast2(context, "Coming soon");
                      },
                      child: Platform.isAndroid
                          ? SvgPicture.asset("assets/icon/G.svg")
                          : SvgPicture.asset("assets/icon/A.svg")),
                ],
              )
            ],
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
  BuyModel(diamonds: "500", amount: "10.00"),
  BuyModel(diamonds: "1000", amount: "20.00"),
  BuyModel(diamonds: "2500", amount: "50.00")
];
