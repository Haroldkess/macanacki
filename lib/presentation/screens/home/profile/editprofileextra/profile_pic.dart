import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';

import '../../../../constants/params.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 3;
    return Container(
        height: 200,
        color: HexColor(backgroundColor),
        child: Center(
          child: Stack(
            children: [
              HexagonWidget.pointy(
                width: w,
                elevation: 10.0,
                color: Colors.white,
                cornerRadius: 20.0,
                child: AspectRatio(
                  aspectRatio: HexagonType.POINTY.ratio,
                  // child: Image.asset(
                  //   'assets/tram.jpg',
                  //   fit: BoxFit.fitWidth,
                  // ),
                ),
              ),
              HexagonWidget.pointy(
                width: w,
                elevation: 10.0,
                color: HexColor("#5F5F5F"),
                padding: 10,
                cornerRadius: 20.0,
                child: AspectRatio(
                    aspectRatio: HexagonType.POINTY.ratio,
                    child: Center(child: Image.network(url))),
              ),
            ],
          ),
        ));
  }
}
