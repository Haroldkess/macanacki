import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/onboarding/splash_screen.dart';
import 'package:macanacki/services/provider_init.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  dotenv.load(fileName: "secret.env");
  // await Database.initDatabase();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: HexColor(backgroundColor)));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: InitProvider.providerInit(),
        child: OverlaySupport(
          toastTheme: ToastThemeData(alignment: Alignment.center),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Macanacki',
            theme: ThemeData(
              primaryColor: HexColor(primaryColor),
              brightness: Brightness.light,
            ),
            home: const Splash(),
          ),
        ));
  }
}
