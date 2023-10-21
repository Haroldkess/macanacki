import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/screens/home/subscription/get_verified_info.dart';
import 'package:macanacki/services/controllers/user_profile_controller.dart';

import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../constants/params.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/text.dart';

class SubSuccessfull extends StatefulWidget {
  const SubSuccessfull({super.key});

  @override
  State<SubSuccessfull> createState() => _SubSuccessfullState();
}

class _SubSuccessfullState extends State<SubSuccessfull> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      UserProfileController.retrievProfileController(context, true);
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   UserProfileController.retrievProfileController(context, true);
    // });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 3;
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
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
                  text: "Verification request",
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
                    SizedBox(
                      width: 300,
                      child: AppText(
                        text:
                            "Your information has been submitted, and will be reviewed within 48 hours or 5 working days. ",
                        color: HexColor("#222222"),
                        fontWeight: FontWeight.w400,
                        size: 14,
                        align: TextAlign.center,
                        maxLines: 5,
                      ),
                    ),
                    // AppText(
                    //   text: "You have just purchased Macanacki",
                    //   color: HexColor("#222222"),
                    //   fontWeight: FontWeight.w400,
                    //   size: 16,
                    //   align: TextAlign.center,
                    //   maxLines: 2,
                    // ),
                    // AppText(
                    //   text: " Premuim Subscription",
                    //   color: HexColor("#222222"),
                    //   fontWeight: FontWeight.w400,
                    //   size: 16,
                    //   align: TextAlign.center,
                    //   maxLines: 2,
                    // ),
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
                  PageRouting.popToPage(context);
                  PageRouting.popToPage(context);
                  //PageRouting.popToPage(context);
                  // PageRouting.popToPage(context);
                  // PageRouting.pushToPage(context, const VerifiedInfo());
                }),
            Container(
              height: height * 0.08,
              //    color: Colors.red,
              //.  child: ,
            ),
          ],
        )),
      ),
    );
  }
}
