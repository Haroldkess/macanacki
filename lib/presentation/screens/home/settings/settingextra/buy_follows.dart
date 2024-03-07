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
import '../../profile/buy_followers/plan_modal.dart';

class BuyFollows extends StatelessWidget {
  const BuyFollows({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        buyFollowersModal(context);
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
              text: "Buy followers",
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
