import 'dart:io';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/logout.dart';
import 'package:macanacki/presentation/screens/onboarding/business/business_info.dart';
import 'package:macanacki/presentation/screens/onboarding/business/business_verification.dart';
import 'package:macanacki/presentation/screens/onboarding/splash_screen.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/dialogue.dart';
import 'package:macanacki/presentation/widgets/screen_loader.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/user_profile_controller.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/gender_model.dart';
import '../../services/controllers/plan_controller.dart';
import '../../services/middleware/user_profile_ware.dart';
import '../../services/temps/temps_id.dart';
import '../screens/onboarding/business/sub_plan.dart';

class DrawerSide extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafKey;
  const DrawerSide({super.key, required this.scafKey});

  @override
  State<DrawerSide> createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      UserProfileController.retrievProfileController(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProfileWare user = context.watch<UserProfileWare>();
    return Drawer(
      backgroundColor: HexColor(primaryColor),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              ListTile(
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  // await PlanController.retrievPlanController(context, true);
                  // PageRouting.pushToPage(
                  //     context, const SubscriptionPlansBusiness());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    elevation: 10.0,
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 3),
                    content: Row(
                      children: [
                        Container(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: AppText(
                                text: "Sure you want to log out?",
                                color: Colors.white,
                                size: 15,
                                fontWeight: FontWeight.w600,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis))
                      ],
                    ),
                    backgroundColor: HexColor(primaryColor).withOpacity(.9),
                    action: SnackBarAction(
                        label: "Yes",
                        textColor: Colors.white,
                        onPressed: () async {
                          progressIndicator(context,
                              message: "Logging you out...");
                          await Future.delayed(const Duration(seconds: 3));
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
                          PageRouting.removeAllToPage(context, const Splash());
                          if (Platform.isAndroid) {
                            Restart.restartApp();
                          } else {
                            Phoenix.rebirth(context);
                          }

                          // PageRouting.popToPage(
                          //     cont);
                        }),
                  ));
                },
                title: AppText(
                  text: "Logout",
                  color: HexColor(backgroundColor),
                  fontWeight: FontWeight.w400,
                  size: 16,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () async {
                  GenderList gender =
                      GenderList(id: 2, name: "Business", selected: true);
                  PlanController.retrievPlanController(context, true);
                  if (user.userProfileModel.gender == "Business" &&
                      user.userProfileModel.verified == 0 &&
                      user.userProfileModel.verification == null) {
                    PageRouting.pushToPage(
                        context,
                        BusinessInfo(
                          data: gender,
                          action: "both",
                        ));

                    // ignore: use_build_context_synchronously
                    // PageRouting.pushToPage(
                    //     context, const SubscriptionPlansBusiness());
                  } else if (user.userProfileModel.gender != "Business" &&
                      user.userProfileModel.verified == 0 &&
                      user.userProfileModel.verification == null) {
                    PageRouting.pushToPage(
                        context,
                        BusinessVerification(
                          gender: gender,
                          isBusiness: false,
                          action: "both",
                        ));
                  } else if (user.userProfileModel.gender != "Business" &&
                      user.userProfileModel.verified == 2 &&
                      user.userProfileModel.verification != null) {
                    emitter("upload without payment");
                    PageRouting.pushToPage(
                        context,
                        BusinessVerification(
                          gender: gender,
                          isBusiness: false,
                          action: "upload",
                        ));
                    //upload without payment
                  } else if (user.userProfileModel.gender == "Business" &&
                      user.userProfileModel.verified == 2 &&
                      user.userProfileModel.verification != null) {
                    //upload without payment
                    PageRouting.pushToPage(
                        context,
                        BusinessInfo(
                          data: gender,
                          action: "upload",
                        ));
                    emitter("upload without payment");
                  } else if (user.userProfileModel.gender == "Business" &&
                      user.userProfileModel.verified == 1 &&
                      user.userProfileModel.activePlan == sub) {
                    // payment only
                    emitter("payment only");
                    PageRouting.pushToPage(
                        context,
                        const SubscriptionPlansBusiness(
                          isBusiness: true,
                          isSubmiting: "pay",
                        ));
                  } else if (user.userProfileModel.gender != "Business" &&
                      user.userProfileModel.verified == 1 &&
                      user.userProfileModel.activePlan == sub) {
                    // payment only
                    PageRouting.pushToPage(
                        context,
                        const SubscriptionPlansBusiness(
                          isBusiness: false,
                          isSubmiting: "pay",
                        ));
                    emitter("payment only");
                  } else {
                    if (user.userProfileModel.verified == 1 &&
                        user.userProfileModel.activePlan != sub) {
                      Get.back();
                      Get.dialog(
                        verifiedDialog(
                            title: "Congratulations",
                            message: "Your account has been verified.",
                            confirmText: "Okay",
                            cancelText: "Go back",
                            onPressedCancel: () {
                              Get.back();
                            },
                            onPressed: () {
                              Get.back();
                            }),
                      );
                    } else {
                      Get.back();
                      Get.dialog(confirmationDialog(
                          title: "Verification",
                          message:
                              "Your documenets are under review. This will take 48 hours or 5 working days to be confirmed.",
                          confirmText: "Okay",
                          cancelText: "Go back",
                          onPressedCancel: () {
                            Get.back();
                          },
                          onPressed: () {
                            Get.back();
                          }));
                    }
                  }
                },
                title: AppText(
                  text: "Verify account",
                  color: HexColor(backgroundColor),
                  fontWeight: FontWeight.w400,
                  size: 16,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    elevation: 10.0,
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 3),
                    content: Row(
                      children: [
                        AppText(
                          text: "Sure you want to proceed ?",
                          color: Colors.white,
                          size: 15,
                          fontWeight: FontWeight.w600,
                        )
                      ],
                    ),
                    backgroundColor: HexColor(primaryColor).withOpacity(.9),
                    action: SnackBarAction(
                        label: "Yes",
                        textColor: Colors.white,
                        onPressed: () async {
                          UserProfileController.deleteUserProfile(context);
                          // PageRouting.popToPage(
                          //     cont);
                        }),
                  ));
                },
                title: AppText(
                  text: "Delete account",
                  color: HexColor(backgroundColor),
                  fontWeight: FontWeight.w400,
                  size: 16,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 15,
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
