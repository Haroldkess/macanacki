import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/onboarding/splash_screen.dart';

import 'package:makanaki/presentation/uiproviders/buttons/button_state.dart';
import 'package:makanaki/services/provider_init.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: InitProvider.providerInit(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Makanaki',
          theme: ThemeData(primaryColor: HexColor(primaryColor)),
          home: const Splash(),
        ));
  }
}
