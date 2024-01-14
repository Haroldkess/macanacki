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
import '../../../../../services/middleware/gift_ware.dart';
import '../../../../widgets/screen_loader.dart';
import '../../../onboarding/splash_screen.dart';
import '../../diamond/balance/diamond_balance_screen.dart';

class WalletAccess extends StatelessWidget {
  const WalletAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          GiftWare.instance.getWalletFromApi();
          GiftWare.instance.getGiftFromApi();
          GiftWare.instance.getBankLocally();
        });
        PageRouting.pushToPage(context, const DiamondBalanceScreen());
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
              text: "Account balance",
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
