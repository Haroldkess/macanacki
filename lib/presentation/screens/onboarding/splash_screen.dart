import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/operations.dart';
import 'package:makanaki/presentation/widgets/app_icon.dart';

import 'first_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(primaryColor),
      body: const Center(
        child: AppIcon(
          height: 31,
          width: 22.9,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Operations.delayScreen(context,const FirstScreen());
  }
}
