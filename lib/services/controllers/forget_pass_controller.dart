import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/screens/onboarding/forget_pass/forget_email.dart';
import 'package:macanacki/services/middleware/registeration_ware.dart';
import 'package:provider/provider.dart';

import '../../presentation/screens/onboarding/forget_pass/new_password.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../../presentation/widgets/snack_msg.dart';

class ForgetPasswordController {
  static Future<void> sendOtp(
      BuildContext context, String email, String otp, String password) async {
    RegisterationWare ware =
        Provider.of<RegisterationWare>(context, listen: false);

    ware.forgetLoad(true);

    bool isDone = await ware
        .changePasswordFromApi(email, otp, password)
        .whenComplete(
            () => emitter("everything from api and provider is done"));
    if (isDone) {
      showToast2(context, ware.optMsg, isError: false);
      ware.forgetLoad(false);
      Get.close(2);
    } else {
      ware.forgetLoad(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.optMsg, isError: true);
    }
    ware.forgetLoad(false);
  }

  static Future<void> resetPass(BuildContext context, String email) async {
    RegisterationWare ware =
        Provider.of<RegisterationWare>(context, listen: false);

    ware.isLoadSendOtp(true);

    bool isDone = await ware.sendForgetOtpFromApi(email).whenComplete(
        () => emitter("everything from api and provider is done"));

    if (isDone) {
      ware.isLoadSendOtp(false);
      showToast2(context, ware.optMsg, isError: false);
      PageRouting.pushToPage(
          context,
          ResetPassScreen(
            email: email,
          ));
    } else {
      ware.isLoadSendOtp(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.optMsg, isError: true);
    }
    ware.isLoadSendOtp(false);
  }
}
