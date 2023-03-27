import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/onboarding/dob_screen.dart';
import 'package:makanaki/presentation/widgets/buttons.dart';
import 'package:makanaki/presentation/widgets/text.dart';

import '../../allNavigation.dart';
import '../../constants/params.dart';

class VerificationSuccess extends StatelessWidget {
  final File image;
  const VerificationSuccess({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 3;
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: SizedBox(
          child: Column(
        children: [
          Container(
            height: height * 0.4,
            //  color: Colors.amber,
            child: HexagonWidget.pointy(
              width: w,
              elevation: 0.0,
              color: HexColor("#0597FF"),
              cornerRadius: 20.0,
              child: AspectRatio(
                aspectRatio: HexagonType.POINTY.ratio,
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
              child: SizedBox(
            width: width / 1.3,
            child: AppText(
              text: "Face Verification Successful!",
              color: HexColor("#0597FF"),
              fontWeight: FontWeight.w600,
              size: 24,
              align: TextAlign.center,
              maxLines: 2,
            ),
          )),
          AppButton(
              width: 0.7,
              height: 0.06,
              color: primaryColor,
              text: "Continue",
              backColor: backgroundColor,
              curves: buttonCurves * 5,
              textColor: primaryColor,
              onTap: () {
                PageRouting.pushToPage(context, const DobScreen());
              }),
          Container(
            height: height * 0.2,
            //    color: Colors.red,
            //.  child: ,
          ),
        ],
      )),
    );
  }
}
