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
  final String? msg;
  const ScanningPerimeter({super.key, this.msg});

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

            endRadius: 120.0,
            duration: Duration(milliseconds: 800),
            glowColor: HexColor(primaryColor),
            child: Avatar(image: temp.dp, radius: 40)),
        const SizedBox(
          height: 24,
        ),
        AppText(
          text: widget.msg ?? "Finding people near you...",
          fontWeight: FontWeight.w400,
          size: 14,
          align: TextAlign.center,
          color: HexColor("#8B8B8B"),
        )
      ],
    );
  }
}
