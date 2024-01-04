import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macanacki/presentation/constants/colors.dart';

class AppIcon extends StatelessWidget {
  final double? height;
  final double? width;
  const AppIcon({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icon/logo2.svg",
      color: textWhite,
      width: width == null ? null : width!,
      height: height == null ? null : height!,
    );
    // return Container();
  }
}
