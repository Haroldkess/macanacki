import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:macanacki/model/reg_email_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/screens/verification/otp_screen.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/middleware/registeration_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
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
      showToast2(context, ware.message, isError: true);
      //print("something went wrong");
    }
  }
}
