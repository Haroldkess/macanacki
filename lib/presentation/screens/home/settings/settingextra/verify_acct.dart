import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/main.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../../config/pay_ext.dart';
import '../../../../../model/gender_model.dart';
import '../../../../../services/controllers/plan_controller.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../constants/params.dart';
import '../../../../widgets/debug_emitter.dart';
import '../../../../widgets/dialogue.dart';
import '../../../../widgets/screen_loader.dart';
import '../../../onboarding/business/business_info.dart';
import '../../../onboarding/business/business_verification.dart';
import '../../../onboarding/business/sub_plan.dart';
import '../../../onboarding/splash_screen.dart';

class VerifyAccount extends StatelessWidget {
  const VerifyAccount({super.key});

  @override
  Widget build(BuildContext context) {
    UserProfileWare user = context.watch<UserProfileWare>();
    return InkWell(
      onTap: () async {
        GenderList gender = GenderList(id: 2, name: "Business", selected: true);
        PlanController.retrievPlanController(context, true);
        // PageRouting.pushToPage(
        //     context,
        //     const SubscriptionPlansBusiness(
        //       isBusiness: true,
        //       isSubmiting: "pay",
        //     ));

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
      child: Container(
        width: 402,
        height: 70,
        color: HexColor(backgroundColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppText(
              text: "Verify account ",
              color: textPrimary,
              fontWeight: FontWeight.w400,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
