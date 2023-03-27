import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/model/otp_model.dart';
import 'package:makanaki/model/reg_email_model.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/onboarding/user_name.dart';
import 'package:makanaki/presentation/screens/verification/otp_screen.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/middleware/registeration_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';

import '../middleware/otp_ware.dart';

class VerifyEmailController {
  static Future<void> verifyEmailController(
      BuildContext context, String otp) async {
    late String myEmail;

    OtpWare ware = Provider.of<OtpWare>(context, listen: false);
    Temp temp = Provider.of<Temp>(context, listen: false);
    await temp
        .initPref()
        .whenComplete(() => myEmail = temp.pref.getString(emailKey)!);
    log(myEmail + otp);

    ware.isLoading(true);
    OtpModel data = OtpModel(email: myEmail, otp: otp);
    bool isDone = await ware
        .verifyOtpFromApi(data)
        .whenComplete(() => log("can now navigate to username page"));

    if (isDone) {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast(context, ware.message, HexColor(primaryColor));
      await Future.delayed(const Duration(seconds: 2)).whenComplete(
          () => PageRouting.pushToPage(context, const SelectUserName()));
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast(context, ware.message, Colors.red);
      //print("something went wrong");
    }
  }
}
