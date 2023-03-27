import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makanaki/model/reg_email_model.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/screens/onboarding/select_gender.dart';
import 'package:makanaki/presentation/screens/verification/otp_screen.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/middleware/registeration_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUsernameController {
  static Future<void> usernameController(
      BuildContext context, String userName) async {
    RegisterationWare ware =
        Provider.of<RegisterationWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    SendUserNameModel data =
        SendUserNameModel(email: pref.getString(emailKey), userName: userName);

    ware.isLoading2(true);

    bool isDone = await ware
        .registerUsernameFromApi(data)
        .whenComplete(() => log("can now navigate to gender page"));

    if (isDone) {
      ware.isLoading2(false);
      // ignore: use_build_context_synchronously
      PageRouting.pushToPage(context, const SelectGender());
    } else {
      ware.isLoading2(false);
      // ignore: use_build_context_synchronously
      showToast(context, "something went wrong. pls try again", Colors.red);
      //print("something went wrong");
    }
  }
}
