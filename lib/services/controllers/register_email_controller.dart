import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:makanaki/model/reg_email_model.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/screens/verification/otp_screen.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/middleware/registeration_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:provider/provider.dart';

class RegisterEmailController {
  static Future<void> registerationController(
      BuildContext context, String email) async {
    SendEmailModel data = SendEmailModel(email: email);
    RegisterationWare ware =
        Provider.of<RegisterationWare>(context, listen: false);
    Temp temp = Provider.of<Temp>(context, listen: false);
    await temp.addEmailTemp(email);

    ware.isLoading(true);

    bool isDone = await ware
        .registerEmailFromApi(data)
        .whenComplete(() => log("can now navigate to otp page"));

    if (isDone) {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      PageRouting.pushToPage(
          context,
          EmailOtp(
            email: email,
          ));
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast(context, ware.message, Colors.red);
      //print("something went wrong");
    }
  }
}
