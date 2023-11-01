import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/home/subscription/plan_box.dart';
import 'package:macanacki/presentation/screens/home/subscription/sub_successful.dart';
import 'package:macanacki/presentation/screens/onboarding/business/success.dart';
import 'package:macanacki/presentation/screens/onboarding/login_screen.dart';
import 'package:macanacki/presentation/widgets/buttons.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/payment_controller.dart';
import 'package:macanacki/services/middleware/plan_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/pay_ext.dart';
import '../../../../config/pay_wall.dart';
import '../../../../model/plan_model.dart';
import '../../../../services/temps/temps_id.dart';
import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../constants/params.dart';
import '../../../uiproviders/screen/tab_provider.dart';
import '../../../widgets/custom_paint.dart';
import '../../../widgets/dialogue.dart';
import '../../../widgets/screen_loader.dart';
import '../../../widgets/text.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../splash_screen.dart';

class SubscriptionPlansBusiness extends StatefulWidget {
  final bool isBusiness;
  final String isSubmiting;
  const SubscriptionPlansBusiness(
      {super.key, required this.isBusiness, required this.isSubmiting});

  @override
  State<SubscriptionPlansBusiness> createState() =>
      _SubscriptionPlansBusinessState();
}

class _SubscriptionPlansBusinessState extends State<SubscriptionPlansBusiness> {
  var publicKey = 'pk_test_66374a59ec66f6c94391ed9b6a405cbf94432d5f';

  @override
  void initState() {
    // dotenv.get('PUBLIC_KEY').toString()
    super.initState();
    //  plugin.initialize(publicKey: dotenv.get('PUBLIC_KEY').toString());
    Operations.controlSystemColor();
  }
  // dotenv.get('PUBLIC_KEY').toString()

  PlanData? myPlan;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TabProvider provide = Provider.of<TabProvider>(context, listen: false);
    PlanWare plans = context.watch<PlanWare>();

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
          height: height,
          width: width * 0.9,
          decoration: BoxDecoration(
              color: HexColor(backgroundColor),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(buttonCurves * 3)),
          child: Stack(
            children: [
              Container(
                // color: Colors.amber,
                //height: 320,
                child: Stack(
                  //  alignment: Alignment.topCenter,
                  children: [
                    CustomPaint(
                      size: Size((width).toDouble(), (300).toDouble()),
                      painter: RPSCustomPainter(),
                    ),
                    Container(
                      height: 130,
                      alignment: Alignment.topCenter,
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
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  //  color: Colors.amber,
                  height: 420,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0, top: 10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: width * 0.8,
                            alignment: Alignment.center,
                            child: Column(
                              //  crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppText(
                                      text: widget.isBusiness
                                          ? "Verified Businesses have blue checkmarks"
                                          : "Verified accounts have blue checkmarks",
                                      color: HexColor(darkColor),
                                      size: 12,
                                      fontWeight: FontWeight.w700,
                                      align: TextAlign.start,
                                    ),

                                    // SvgPicture.asset("assets/icon/.svg")
                                  ],
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                AppText(
                                  text:
                                      "1. Premium access to exclusive features .",
                                  color: HexColor(darkColor),
                                  size: 12,
                                  fontWeight: FontWeight.w400,
                                  align: TextAlign.start,
                                ),
                                AppText(
                                  text: "2. Easier access to account support",
                                  color: HexColor(darkColor),
                                  size: 12,
                                  fontWeight: FontWeight.w400,
                                  align: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 1,
                                  itemBuilder: ((context, index) {
                                    PlanData plan = plans.plans[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 100),
                                      child: PlanBox2(
                                        plans: plan,
                                        index: index,
                                      ),
                                    );
                                  }),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              AppButton(
                                  width: 0.7,
                                  height: 0.06,
                                  color: primaryColor,
                                  text: "Continue",
                                  backColor: primaryColor,
                                  curves: buttonCurves * 5,
                                  textColor: backgroundColor,
                                  onTap: () async {
                                    setState(() {
                                      myPlan = plans.plans[0];
                                    });
                                    //mmmmmmmmmmmmm
                                    payModal(
                                        context,
                                        myPlan!,
                                        widget.isBusiness,
                                        widget.isSubmiting == "pay"
                                            ? true
                                            : false);
                                  }),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                      text: "Not You? ", color: Colors.black),
                                  InkWell(
                                    onTap: () async {
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        duration: const Duration(seconds: 5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        elevation: 10.0,
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 0,
                                            left: 15,
                                            right: 3),
                                        content: Row(
                                          children: [
                                            Container(
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 200),
                                                child: AppText(
                                                    text:
                                                        "This action will log you out?",
                                                    color: Colors.white,
                                                    size: 15,
                                                    fontWeight: FontWeight.w600,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis))
                                          ],
                                        ),
                                        backgroundColor: HexColor(primaryColor)
                                            .withOpacity(.9),
                                        action: SnackBarAction(
                                            label: "Yes",
                                            textColor: Colors.white,
                                            onPressed: () async {
                                              progressIndicator(context,
                                                  message:
                                                      "Logging you out...");
                                              await Future.delayed(
                                                  const Duration(seconds: 3));
                                              await pref.remove(isLoggedInKey);
                                              await pref.remove(tokenKey);
                                              await pref.remove(passwordKey);
                                              await pref.remove(emailKey);
                                              await pref.remove(dobKey);
                                              await pref.remove(isFirstTimeKey);
                                              await pref.remove(photoKey);
                                              await pref.remove(userNameKey);

                                              await pref.clear();

                                              // ignore: use_build_context_synchronously
                                              await removeProviders(context);

                                              // ignore: use_build_context_synchronously
                                              PageRouting.removeAllToPage(
                                                  context, const Splash());
                                              Restart.restartApp();
                                              // PageRouting.popToPage(
                                              //     cont);
                                            }),
                                      ));
                                    },
                                    child: AppText(
                                      text: "Switch Account",
                                      color: HexColor(primaryColor),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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

payModal(BuildContext context, PlanData plan, bool? isBusiness, bool isPayOnly,
    [String? id]) async {

  List<Package> verificationPackages = await PayExt.fetchPackagesFromOfferings(identifier: 'verification');
  if(!context.mounted) return;
  await showModalBottomSheet(
    useRootNavigator: true,
    isDismissible: true,
    isScrollControlled: true,
    backgroundColor: Colors.brown,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.9,
              child: Paywall(
                showTermAndConditions: true,
                showTermsOfUse: true,
                title: "Verification Packages",
                description: "Unlock the full verification experience",
                packages: verificationPackages,
                onError: (String e){

                  showToast2(context, "Payment not verified try again", isError: true);
                  Navigator.pop(context);

                },
                onSucess: (){
                  PaymentController.verifyOnServerExt(context, isBusiness, isPayOnly);
                },

              ),
            );
          });
    },
  );
}
