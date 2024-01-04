import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/account_settings.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/age_range.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/app_settings.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/community.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/control_sight.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/delete_account.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/discovery_settings.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/help_support.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/logout.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/manage_payment.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/measure.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/privacy.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/setting_logo.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/show_me.dart';
import 'package:macanacki/presentation/screens/home/settings/settingextra/verification_status.dart';
import 'package:macanacki/presentation/widgets/text.dart';

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: const [
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
                Logout(),
                SizedBox(
                  height: 16,
                ),
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
