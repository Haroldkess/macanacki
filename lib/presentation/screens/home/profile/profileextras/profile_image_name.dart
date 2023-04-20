import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';

class ProfileImageAndName extends StatelessWidget {
  const ProfileImageAndName({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 3.5;
    UserProfileWare stream = context.watch<UserProfileWare>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
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
                  child: Center(
                      child: Image.network(
                          stream.userProfileModel.profilephoto ?? ""))),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          color: stream.loadStatus ? baseColor : Colors.transparent,
          width:
              stream.loadStatus ? 200 : MediaQuery.of(context).size.width * 0.7,
          height: stream.loadStatus ? 30 : null,
          child: stream.loadStatus
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppText(
                        text: "${stream.userProfileModel.username}",
                        color: HexColor(darkColor),
                        size: 18,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w800,
                        align: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                    // Image.asset(
                    //   "assets/pic/verified.png",
                    //   height: 27,
                    //   width: 27,
                    // )
                  ],
                ),
        )
      ],
    );
  }
}

class ProfileImageAndNameShimmer extends StatelessWidget {
  const ProfileImageAndNameShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 3;
    UserProfileWare stream = context.watch<UserProfileWare>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          //  color: baseColor,
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
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          color: baseColor.withOpacity(.3),
          width: 200,
          height: stream.loadStatus ? 30 : null,
          child: stream.loadStatus
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: "Makanaki, ",
                            style: GoogleFonts.spartan(
                              color: HexColor(darkColor),
                              fontSize: 24,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: " ",
                                style: GoogleFonts.spartan(
                                    color: HexColor("#C0C0C0"), fontSize: 24),
                              )
                            ])),
                  ],
                ),
        )
      ],
    );
  }
}
