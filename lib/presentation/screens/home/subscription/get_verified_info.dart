import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/widgets/buttons.dart';
import 'package:makanaki/presentation/widgets/text.dart';

import '../../../allNavigation.dart';
import '../../../constants/params.dart';
import '../../../widgets/custom_paint.dart';

class VerifiedInfo extends StatelessWidget {
  const VerifiedInfo({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: HexColor(darkColor),
      appBar: AppBar(
        backgroundColor: HexColor(darkColor),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () => {
              PageRouting.popToPage(context),
            },
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 1.0,
                        color: HexColor("#8B8B8B"),
                        style: BorderStyle.solid)),
                child: Icon(
                  Icons.clear_outlined,
                  color: HexColor("#8B8B8B"),
                )),
          ),
          const SizedBox(
            width: 22.67,
          )
        ],
      ),
      body: Stack(children: [
        Center(
          child: Container(
            height: height * 0.7,
            width: width * 0.9,
            decoration: BoxDecoration(
                color: HexColor(backgroundColor),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(buttonCurves * 3)),
            child: Stack(
              children: [
                SizedBox(
                  height: height * 0.5,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      CustomPaint(
                        size: Size((width).toDouble(), (width * 1).toDouble()),
                        painter: RPSCustomPainter(),
                      ),
                      Container(
                        height: height * 0.25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                AppText(
                                  text: "Get Verified",
                                  size: 32,
                                  fontWeight: FontWeight.w700,
                                  color: HexColor(backgroundColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: buttonCurves * 5),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: SvgPicture.asset(
                                    "assets/icon/verifypink.svg"),
                              ),
                            ),
                            // SizedBox(
                            //   height: 5,
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: height * 0.45,
                    width: width * 0.8,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: verificationInfo
                              .map(
                                (e) => ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: CircleAvatar(
                                      radius: 3,
                                      backgroundColor: HexColor("#5F5F5F"),
                                    ),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: AppText(
                                      text: e,
                                      fontWeight: FontWeight.w400,
                                      color: HexColor("#5F5F5F"),
                                      size: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        AppButton(
                            width: 0.7,
                            height: 0.06,
                            color: primaryColor,
                            text: "Continue",
                            backColor: primaryColor,
                            curves: buttonCurves * 5,
                            textColor: backgroundColor,
                            onTap: () {
                              // PageRouting.pushToPage(
                              //     context, const SubSuccessfull());
                            }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
