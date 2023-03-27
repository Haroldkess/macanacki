import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/operations.dart';
import 'package:makanaki/presentation/screens/kyc/verification_successful.dart';
import 'package:makanaki/presentation/screens/onboarding/dob_screen.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/middleware/facial_ware.dart';
import 'package:provider/provider.dart';

import '../../allNavigation.dart';
import '../../constants/params.dart';
import '../../widgets/buttons.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool tapToStart = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 1.5;
    FacialWare facial = context.watch<FacialWare>();

    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: SizedBox(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.15,
              child: Center(
                child: AppText(
                  text: "Identity Verification",
                  size: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppText(
                  text: "Face the camera",
                  size: 22,
                  fontWeight: FontWeight.w800,
                ),
                Stack(
                  children: [
                    HexagonWidget.pointy(
                      width: w,
                      elevation: 30.0,
                      color: Colors.white,
                      cornerRadius: 20.0,
                      child: AspectRatio(
                        aspectRatio: HexagonType.POINTY.ratio,
                        // child: Image.asset(
                        //   'assets/tram.jpg',
                        //   fit: BoxFit.fitWidth,
                        // ),
                      ),
                    ),
                    HexagonWidget.pointy(
                      width: w,
                      elevation: 30.0,
                      color: HexColor("#5F5F5F"),
                      padding: 10,
                      cornerRadius: 20.0,
                      child: InkWell(
                        onTap: () => Operations.verifyFaceCamera(context),
                        child: facial.loadStatus
                            ? const Loader(color: Colors.white)
                            : AspectRatio(
                                aspectRatio: HexagonType.POINTY.ratio,
                                child: Center(
                                  child: AppText(
                                    text: "Tap to start",
                                    color: HexColor(backgroundColor),
                                  ),
                                )),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    facial.loadStatus
                        ? TweenAnimationBuilder(
                            curve: Curves.fastOutSlowIn,
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: Duration(seconds: 6),
                            onEnd: () async {
                              facial.isLoading(false);
                              PageRouting.pushToPage(
                                  context,
                                  VerificationSuccess(
                                    image: facial.facial!,
                                  ));
                            },
                            builder: (context, double value, child) => Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                        color: Colors.white,
                                        style: BorderStyle.solid),
                                  ),
                                  width: 300,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: LinearProgressIndicator(
                                      backgroundColor: HexColor("#FFC1D6"),
                                      value: value,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          HexColor(primaryColor)),
                                    ),
                                  ),
                                ),
                                AppText(
                                  text: value > 0.9 ? "Done" : "Processing...",
                                  color: Colors.white,
                                )
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      height: 20,
                    ),
                    AppButton(
                        width: 0.7,
                        height: 0.06,
                        color: "#F5F2F9",
                        text: "Cancel",
                        backColor: "#F5F2F9",
                        curves: buttonCurves * 5,
                        textColor: "#8B8B8B",
                        onTap: () {
                          PageRouting.popToPage(context);
                          // PageRouting.pushToPage(
                          //     context, const VerificationSuccess());
                        }),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
