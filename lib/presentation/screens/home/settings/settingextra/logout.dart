import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/main.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restart_app/restart_app.dart';
import '../../../../../config/pay_ext.dart';
import '../../../../widgets/screen_loader.dart';
import '../../../onboarding/splash_screen.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        // await PlanController.retrievPlanController(context, true);
        // PageRouting.pushToPage(
        //     context, const SubscriptionPlansBusiness());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 10.0,
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 3),
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
          backgroundColor: HexColor(backgroundColor).withOpacity(.9),
          action: SnackBarAction(
              label: "Yes",
              textColor: Colors.white,
              onPressed: () async {
                progressIndicator(context, message: "Logging you out...");
                PayExt.logoutUser();
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
                  try {
                    // Phoenix.rebirth(context);
                    Restart.restartApp();
                  } catch (e) {
                    //     Restart.restartApp();
                  }
                }

                // PageRouting.popToPage(
                //     cont);
              }),
        ));
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
              text: "Logout",
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
