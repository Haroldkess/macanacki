import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macanacki/model/reg_email_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/screens/onboarding/select_gender.dart';
import 'package:macanacki/presentation/screens/verification/otp_screen.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/middleware/registeration_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/screens/onboarding/dob_screen.dart';

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
      PageRouting.pushToPage(context, const DobScreen());
    } else {
      ware.isLoading2(false);
      // ignore: use_build_context_synchronously
      showToast2(context, "something went wrong. pls try again", isError: true);

      //print("something went wrong");
    }
  }
}
