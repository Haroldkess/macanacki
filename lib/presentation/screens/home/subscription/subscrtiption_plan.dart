import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/home/subscription/plan_box.dart';
import 'package:makanaki/presentation/screens/home/subscription/sub_successful.dart';
import 'package:makanaki/presentation/widgets/buttons.dart';
import 'package:provider/provider.dart';

import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../constants/params.dart';
import '../../../uiproviders/screen/tab_provider.dart';
import '../../../widgets/custom_paint.dart';
import '../../../widgets/text.dart';

class SubscriptionPlans extends StatelessWidget {
  const SubscriptionPlans({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TabProvider provide = Provider.of<TabProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: HexColor(darkColor),
      appBar: AppBar(
        backgroundColor: HexColor(darkColor),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () => {
              provide.changeIndex(0),
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
            height: height * 0.8,
            width: width * 0.9,
            decoration: BoxDecoration(
                color: HexColor(backgroundColor),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(buttonCurves * 3)),
            child: Stack(
              children: [
                SizedBox(
                  height: height * 0.6,
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
                                  text: "Subscription Plan",
                                  size: 24,
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
                                child: SvgPicture.asset("assets/icon/key.svg"),
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
                    height: height * 0.52,
                    width: width * 0.8,
                    child: Column(
                      children: [
                        SizedBox(
                          width: width * 0.7,
                          child: AppText(
                            text: "Subscribe to active account. Cancel Anytime",
                            color: HexColor(darkColor),
                            size: 20,
                            fontWeight: FontWeight.w700,
                            align: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: subs.length,
                              itemBuilder: ((context, index) {
                                SubPlans plans = subs[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                  child: PlanBox(plans: plans),
                                );
                              }),
                            )),
                        const SizedBox(
                          height: 55,
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
                                  context, const SubSuccessfull());
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
