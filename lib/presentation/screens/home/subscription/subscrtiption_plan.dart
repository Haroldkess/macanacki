import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/screens/home/subscription/plan_box.dart';
import 'package:macanacki/presentation/screens/home/subscription/sub_successful.dart';
import 'package:macanacki/presentation/widgets/buttons.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/payment_controller.dart';
import 'package:macanacki/services/middleware/plan_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';
import '../../../../model/plan_model.dart';
import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../constants/params.dart';
import '../../../uiproviders/screen/tab_provider.dart';
import '../../../widgets/custom_paint.dart';
import '../../../widgets/text.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SubscriptionPlans extends StatefulWidget {
  const SubscriptionPlans({super.key});

  @override
  State<SubscriptionPlans> createState() => _SubscriptionPlansState();
}

class _SubscriptionPlansState extends State<SubscriptionPlans> {
  var publicKey = 'pk_test_66374a59ec66f6c94391ed9b6a405cbf94432d5f';

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: dotenv.get('PUBLIC_KEY').toString());
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TabProvider provide = Provider.of<TabProvider>(context, listen: false);
    PlanWare plans = context.watch<PlanWare>();

    UserProfileWare user = context.watch<UserProfileWare>();

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
      body: Center(
        child: Container(
          height: height * 0.9,
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
                      height: height * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: .1,
                          ),
                          Column(
                            children: [
                              AppText(
                                text: "Subscription Plan",
                                size: 17,
                                fontWeight: FontWeight.w700,
                                color: HexColor(backgroundColor),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: buttonCurves),
                            child: CircleAvatar(
                              radius: 25,
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
              Positioned.fill(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50.0,
                        ),
                        // SizedBox(
                        //   width: width * 0.7,
                        //   child: AppText(
                        //     text: "Subscribe to Premium. Cancel Anytime",
                        //     color: HexColor(darkColor),
                        //     size: 17,
                        //     fontWeight: FontWeight.w700,
                        //     align: TextAlign.center,
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 15.0,
                        // ),
                        Container(
                          width: width * 0.8,
                          alignment: Alignment.center,
                          child: Column(
                            //  crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppText(
                                text: "1. Send messages to unfollowed account.",
                                color: HexColor(darkColor),
                                size: 12,
                                fontWeight: FontWeight.w400,
                                align: TextAlign.start,
                              ),
                              AppText(
                                text: "2. Download videos and images",
                                color: HexColor(darkColor),
                                size: 12,
                                fontWeight: FontWeight.w400,
                                align: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: plans.plans.length,
                              itemBuilder: ((context, index) {
                                PlanData plan = plans.plans[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: PlanBox(
                                    plans: plan,
                                    index: index,
                                  ),
                                );
                              }),
                            )),
                        const SizedBox(
                          height: 40,
                        ),
                        AppButton(
                            width: 0.7,
                            height: 0.06,
                            color: primaryColor,
                            text: "Continue",
                            backColor: primaryColor,
                            curves: buttonCurves * 5,
                            textColor: backgroundColor,
                            onTap: () async {
                              payModal(context);
                              // PlanWare plan =
                              //     Provider.of<PlanWare>(context, listen: false);
                              // if (plan.amount == 0) {
                              //   showToast2(context,
                              //       "Kindly select a subscription plan");
                              //   return;
                              // } else {
                              //   int amount = plan.amount * 100;
                              //   await PaymentController.chargeCard(
                              //       context, amount);

                              //   plans.addAmount(0);
                              // }

                              // PageRouting.pushToPage(
                              //     context, const SubSuccessfull());
                            }),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

payModal(BuildContext context) async {
  var width = MediaQuery.of(context).size.width;
  return showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        PlanWare stream = context.watch<PlanWare>();
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
                        PlanWare plan =
                            Provider.of<PlanWare>(context, listen: false);
                        if (plan.amount == 0) {
                          showToast2(
                              context, "Kindly select a subscription plan");
                          return;
                        } else {
                          int amount = plan.amount * 100;
                          await PaymentController.chargeCard(context, amount);

                          plan.addAmount(0);
                        }

                        // ignore: use_build_context_synchronously
                        // PageRouting.pushToPage(
                        //     context, const SubSuccessfull());
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
