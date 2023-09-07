import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/onboarding/splash_screen.dart';
import 'package:macanacki/services/provider_init.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  dotenv.load(fileName: "secret.env");
  // await Database.initDatabase();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: HexColor(backgroundColor)));
  runApp( Phoenix(child: const  MyApp() ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: InitProvider.providerInit(),
        child: OverlaySupport(
          toastTheme: ToastThemeData(alignment: Alignment.center),
          child: GetMaterialApp (
            debugShowCheckedModeBanner: false,
            title: 'Macanacki',
            theme: ThemeData(
              primaryColor: HexColor(primaryColor),
              brightness: Brightness.light,
            ),
            home: UpgradeAlert(
                  upgrader: Upgrader(dialogStyle: Platform.isIOS ? UpgradeDialogStyle.cupertino :
                UpgradeDialogStyle.material,debugLogging:  false),child: const Splash()),
          ),
        ));
  }
}
                   