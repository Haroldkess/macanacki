import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:provider/provider.dart';

import '../../../../services/temps/temp.dart';
import '../../../constants/params.dart';
import '../../../uiproviders/screen/find_people_provider.dart';
import '../../../widgets/avatar.dart';

class ScanningPerimeter extends StatefulWidget {
  const ScanningPerimeter({super.key});

  @override
  State<ScanningPerimeter> createState() => _ScanningPerimeterState();
}

class _ScanningPerimeterState extends State<ScanningPerimeter> {
  @override
  Widget build(BuildContext context) {
    Temp temp = Provider.of<Temp>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AvatarGlow(
            endRadius: 141.0,
            glowColor: HexColor(primaryColor),
            child: Avatar(image: temp.dp, radius: 50)),
        const SizedBox(
          height: 24,
        ),
        AppText(
          text: "Finding people near you...",
          fontWeight: FontWeight.w400,
          size: 14,
          align: TextAlign.center,
          color: HexColor("#8B8B8B"),
        )
      ],
    );
  }
}
