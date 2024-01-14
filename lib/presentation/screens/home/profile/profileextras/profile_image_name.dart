import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../operations.dart';
import '../../../../widgets/feed_views/image_holder.dart';
import '../../../../widgets/loader.dart';

class ProfileImageAndName extends StatelessWidget {
  const ProfileImageAndName({super.key});

  @override
  Widget build(BuildContext context) {
    var w = 100.0;
    UserProfileWare stream = context.watch<UserProfileWare>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            stream.userProfileModel.profilephoto == null
                ? null
                : PageRouting.pushToPage(
                    context,
                    ImageHolder(
                      images: [
                        stream.userProfileModel.profilephoto!.isEmpty
                            ? ""
                            : stream.userProfileModel.profilephoto!
                      ],
                    ));
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Stack(
                children: [
                  HexagonWidget.pointy(
                    width: w,
                    elevation: 10.0,
                    color: HexColor("#C0C0C0").withOpacity(.4),
                    cornerRadius: 15.0,
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
                    color: Colors.black,
                    padding: 2,
                    cornerRadius: 15.0,
                    child: AspectRatio(
                        aspectRatio: HexagonType.POINTY.ratio,
                        child: CachedNetworkImage(
                          imageUrl: stream.userProfileModel.profilephoto ?? "",
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                                  child: Loader(
                            color: textWhite,
                          )),
                          errorWidget: (context, url, error) =>
                              CachedNetworkImage(
                            imageUrl:
                                stream.userProfileModel.profilephoto ?? "",
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                                    child: Loader(
                              color: textWhite,
                            )),
                            errorWidget: (context, url, error) =>
                                CachedNetworkImage(
                                    imageUrl:
                                        stream.userProfileModel.profilephoto ??
                                            "",
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Center(
                                                child: Loader(
                                              color: textWhite,
                                            )),
                                    errorWidget: (context, url, error) =>
                                        SizedBox()),
                          ),
                        )),
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                right: w * 2 / 1.5,
                child: InkWell(
                  onTap: () async => await Operations.changePhotoFromGallery(
                      context,
                      stream.userProfileModel.aboutMe,
                      stream.userProfileModel.phone,
                      stream.userProfileModel.country,
                      stream.userProfileModel.state,
                      stream.userProfileModel.city),
                  child: CircleAvatar(
                    radius: 13,
                    backgroundColor: Colors.black,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 10,
                      child: SvgPicture.asset(
                        "assets/icon/add_profile.svg",
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
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
                    Container(
                      constraints: BoxConstraints(maxWidth: 210),
                      child: AppText(
                        // text: "Kelt",
                        text: "${stream.userProfileModel.username}",
                        color: Colors.white.withOpacity(.6),
                        // color: HexColor(darkColor),
                        size: 16,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w800,
                        align: TextAlign.center,
                        maxLines: 1,
                        overflow:
                            stream.userProfileModel.username.toString().length >
                                    20
                                ? TextOverflow.ellipsis
                                : TextOverflow.fade,
                      ),
                    ),

                    SizedBox(
                      width: 4,
                    ),
                    stream.userProfileModel.verified == 1 &&
                            stream.userProfileModel.activePlan != sub
                        ? SvgPicture.asset(
                            "assets/icon/badge.svg",
                            height: 15,
                            width: 15,
                          )
                        : const SizedBox.shrink()
                    // stream.userProfileModel.verified == 0 ||
                    //         stream.userProfileModel.verified == null
                    //     ? const SizedBox.shrink()
                    //     : SvgPicture.asset(
                    //         "assets/icon/badge.svg",
                    //         height: 15,
                    //         width: 15,
                    //       )
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
          // width: 200,
          height: stream.loadStatus ? 30 : null,
          child: stream.loadStatus
              ? const SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: "macanacki, ",
                            style: GoogleFonts.leagueSpartan(
                              color: HexColor(darkColor),
                              fontSize: 24,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w400,
                            ),
                            children: [
                              TextSpan(
                                text: " ",
                                style: GoogleFonts.leagueSpartan(
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
