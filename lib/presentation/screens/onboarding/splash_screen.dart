import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macanacki/presentation/widgets/app_icon.dart';
import 'package:macanacki/services/controllers/location_controller.dart';
import 'package:macanacki/services/controllers/network_controller.dart';

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
      body: Center(
        child: SvgPicture.asset("assets/icon/crown.svg",
            color: Colors.white, height: 50, width: 50),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    CheckConnect.networkCheck();
    LocationController.getAndSaveLatLong(context);
  }
}
