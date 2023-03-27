
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';

class HexagonAvatar extends StatelessWidget {
  final double w;
  final String url;
  VoidCallback? onTap;
   HexagonAvatar({super.key, required this.url, required this.w, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: HexagonWidget.pointy(
        
        width: w,
        elevation: 0.0,
        color: HexColor(primaryColor),
        //    cornerRadius: 20.0,
        child: AspectRatio(
          aspectRatio: HexagonType.POINTY.ratio,
          child: Image.network(
            url,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
