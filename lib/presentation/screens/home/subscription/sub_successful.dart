import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/screens/home/subscription/get_verified_info.dart';

import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../constants/params.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/text.dart';

class SubSuccessfull extends StatelessWidget {
  const SubSuccessfull({super.key});

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
            child: CircleAvatar(
              radius: 37,
              backgroundColor: HexColor(primaryColor),
              child: SvgPicture.asset(
                "assets/icon/crown.svg",
                width: 43,
                height: 33.31,
                color: HexColor(backgroundColor),
              ),
            ),
          ),
          Expanded(
              child: Column(
            children: [
              AppText(
                text: "Premium Subscription",
                color: HexColor("#222222"),
                fontWeight: FontWeight.w400,
                size: 16,
                align: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(
                height: 5,
              ),
              AppText(
                text: "Successfull",
                color: HexColor(primaryColor),
                fontWeight: FontWeight.w400,
                size: 32,
                align: TextAlign.center,
                maxLines: 2,
              ),
              const SizedBox(
                height: 120,
              ),
              Column(
                children: [
                  AppText(
                    text: "You have just purchased MacaNacki",
                    color: HexColor("#222222"),
                    fontWeight: FontWeight.w400,
                    size: 16,
                    align: TextAlign.center,
                    maxLines: 2,
                  ),
                  AppText(
                    text: " Premuim Subscription",
                    color: HexColor("#222222"),
                    fontWeight: FontWeight.w400,
                    size: 16,
                    align: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              )
            ],
          )),
          AppButton(
              width: 0.7,
              height: 0.06,
              color: primaryColor,
              text: "Explore",
              backColor: backgroundColor,
              curves: buttonCurves * 5,
              textColor: primaryColor,
              onTap: () {
                PageRouting.pushToPage(context, const VerifiedInfo());
              }),
          Container(
            height: height * 0.08,
            //    color: Colors.red,
            //.  child: ,
          ),
        ],
      )),
    );
  }
}
