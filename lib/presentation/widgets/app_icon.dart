import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcon extends StatelessWidget {
  final double? height;
  final double? width;
  const AppIcon({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      "assets/icon/makanakiicon.svg",
      width: width == null ? null : width!,
      height: height == null ? null : height!,
    );
  }
}
