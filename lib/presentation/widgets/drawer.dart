import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/settings/settingextra/logout.dart';
import 'package:makanaki/presentation/screens/onboarding/splash_screen.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/temps/temps_id.dart';

class DrawerSide extends StatefulWidget {
  final GlobalKey<ScaffoldState> scafKey;
  const DrawerSide({super.key, required this.scafKey});

  @override
  State<DrawerSide> createState() => _DrawerSideState();
}

class _DrawerSideState extends State<DrawerSide> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: HexColor(primaryColor),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              ListTile(
                onTap: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();

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
                  Restart.restartApp();
                },
                title: AppText(
                  text: "Logout",
                  color: HexColor(backgroundColor),
                  fontWeight: FontWeight.w400,
                  size: 16,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 15,
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
