import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:shimmer/shimmer.dart';

import 'loader.dart';

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
        elevation: 10.0,
        color: Colors.transparent,
        padding: 3,
        cornerRadius: 2.0,
        child: AspectRatio(
          aspectRatio: HexagonType.POINTY.ratio,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.pink,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                    )),
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: HexColor(primaryColor),
            ),
          ),
        ),
      ),
    );
  }
}


            //            Center(
            //         child: Loader(
            //   color: HexColor(primaryColor).withOpacity(.7),
            // )),