import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/kyc/camera_screen.dart';
import 'package:makanaki/presentation/widgets/custom_paint.dart';
import 'dart:ui' as ui;

import 'package:makanaki/presentation/widgets/text.dart';

import '../../allNavigation.dart';
import '../../widgets/buttons.dart';

class KycNotification extends StatelessWidget {
  const KycNotification({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: HexColor(darkColor),
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
                                  text: "Just a moment...",
                                  size: 20,
                                  fontWeight: FontWeight.w400,
                                  color: HexColor(backgroundColor),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                AppText(
                                  text: "Verify That You Are Real",
                                  size: 20,
                                  fontWeight: FontWeight.w700,
                                  color: HexColor(backgroundColor),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: buttonCurves * 5),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: SvgPicture.asset("assets/icon/face.svg"),
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
                        Column(
                          children: info
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: ListTile(
                                    leading: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 35),
                                      child: CircleAvatar(
                                        radius: 13,
                                        backgroundColor: HexColor(primaryColor),
                                        child: Icon(
                                          Icons.done,
                                          size: 20,
                                          color: HexColor(backgroundColor),
                                        ),
                                      ),
                                    ),
                                    title: AppText(
                                      text: e.title,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    subtitle: AppText(text: e.subTitle),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(
                          height: 35,
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
                              PageRouting.pushToPage(
                                  context, const CameraScreen());
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
