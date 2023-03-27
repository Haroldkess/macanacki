import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/model/ui_model.dart';

import '../../../constants/params.dart';

class NotificationImage extends StatelessWidget {
  final AppNotification item;
  const NotificationImage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 3;
    return Container(
      height: 100,
      // color: Colors.amber,
      width: 60,
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          HexagonWidget.pointy(
            width: w,
            elevation: 2.0,
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
            elevation: 0.0,
            color: item.isRequest || item.isVerify
                ? HexColor(backgroundColor)
                : HexColor("#5F5F5F"),
            padding: 2,
            cornerRadius: 20.0,
            child: AspectRatio(
                aspectRatio: HexagonType.POINTY.ratio,
                child: Center(
                    child: item.isRequest
                        ? SvgPicture.asset(
                            item.image,
                            color: HexColor(primaryColor),
                          )
                        : item.isVerify
                            ? SvgPicture.asset(
                                item.image,
                                color: HexColor(primaryColor),
                              )
                            : Image.network(item.image))),
          ),
        ],
      ),
    );
  }
}
