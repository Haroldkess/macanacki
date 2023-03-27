import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:makanaki/model/reg_email_model.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/screens/home/tab_screen.dart';
import 'package:makanaki/presentation/screens/onboarding/login_screen.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/middleware/login_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:provider/provider.dart';

class LoginController {
  static Future<void> loginUserController(BuildContext context, String email,
      String password, bool isSplash) async {
    SendLoginModel data = SendLoginModel(userName: email, password: password);
    LoginWare ware = Provider.of<LoginWare>(context, listen: false);
    Temp temp = Provider.of<Temp>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .loginUserFromApi(data)
        .whenComplete(() => log("can now navigate to home"));

    if (isDone) {
      ware.isLoading(false);
      await temp.addEmailTemp(email);
      await temp.addPasswordTemp(password);
      await temp.addIsLoggedInTemp(true);
      log("removing all previous screens");
      // ignore: use_build_context_synchronously
      PageRouting.removeAllToPage(context, const TabScreen());
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast(context, ware.message, Colors.red);
      if (isSplash) {
        // ignore: use_build_context_synchronously
        PageRouting.pushToPage(context, const LoginScreen());
      }
    }
  }
}
