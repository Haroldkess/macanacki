import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/delete_account.dart';

import 'package:macanacki/presentation/screens/home/settings/settingextra/logout.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/wallet.dart';

import 'package:macanacki/presentation/widgets/text.dart';

import 'settingextra/buy_follows.dart';
import 'settingextra/verify_acct.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: AppText(
            text: 'Settings',
            fontWeight: FontWeight.w400,
            size: 24,
            color: textWhite),
        centerTitle: true,
        backgroundColor: HexColor(backgroundColor),
        elevation: 0,
        leading: BackButton(color: textWhite),
      ),
      body: Container(
        height: height,
        width: width,
        color: backgroundSecondary,
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                // VerificationSettings(),
                // SizedBox(
                //   height: 16,
                // ),
                // AccountSettings(),
                // SizedBox(
                //   height: 16,
                // ),
                // DiscoverySettings(),
                // SizedBox(
                //   height: 16,
                // ),
                // ShowMeSettings(),
                // SizedBox(
                //   height: 16,
                // ),
                // AgeRangeSettings(),
                // SizedBox(
                //   height: 16,
                // ),
                // ControlSight(),
                // SizedBox(
                //   height: 16,
                // ),
                // AppSettingsNotification(),
                // SizedBox(
                //   height: 16,
                // ),
                // MeasureDistanceSelect(),
                // SizedBox(
                //   height: 16,
                // ),
                // ManagePayment(),
                // SizedBox(
                //   height: 16,
                // ),
                // CoumunityHandles(),
                // SizedBox(
                //   height: 16,
                // ),
                // HelpAndSupport(),
                // SizedBox(
                //   height: 16,
                // ),
                // Privacy(),
                SizedBox(
                  height: 16,
                ),
                WalletAccess(),
                SizedBox(
                  height: 16,
                ),
                BuyFollows(),
                SizedBox(
                  height: 16,
                ),
                VerifyAccount(),

                SizedBox(
                  height: 16,
                ),
                Logout(),

                // SettingLogo(),
                SizedBox(
                  height: 16,
                ),
                DeleteAccount(),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
