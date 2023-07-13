import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../widgets/loader.dart';

class PublicProfileImageAndName extends StatelessWidget {
  const PublicProfileImageAndName({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = 100.0;
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
                    child: CachedNetworkImage(
                      imageUrl:
                          stream.publicUserProfileModel.profilephoto ?? "",
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: Loader(
                        color: HexColor(primaryColor),
                      )),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        color: HexColor(primaryColor),
                      ),
                    ),

                    //  Image.network(
                    //     stream.publicUserProfileModel.profilephoto == null
                    //         ? url
                    //         : stream.publicUserProfileModel.profilephoto!)
                  )),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          color: stream.loadStatus2 ? baseColor : Colors.transparent,
          width: stream.loadStatus2
              ? 200
              : MediaQuery.of(context).size.width * 0.7,
          height: stream.loadStatus2 ? 30 : null,
          child: stream.loadStatus2
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 210),
                      child: AppText(
                        text: stream.publicUserProfileModel.username == null
                            ? ""
                            : "${stream.publicUserProfileModel.username}",
                        color: HexColor(darkColor),
                        size: 15,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w800,
                        align: TextAlign.center,
                        maxLines: 1,
                        overflow: stream.publicUserProfileModel.username.toString().length >
                                    20
                                ? TextOverflow.ellipsis
                                : TextOverflow.fade,
                      ),
                    ),
                    stream.publicUserProfileModel.verified == 0
                        ? const SizedBox.shrink()
                        : SvgPicture.asset(
                            "assets/icon/badge.svg",
                            height: 15,
                            width: 15,
                          )
                  ],
                ),
        )
      ],
    );
  }
}
