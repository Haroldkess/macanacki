import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../model/public_profile_model.dart';
import '../../../../services/middleware/extra_profile_ware.dart';
import '../../../constants/colors.dart';
import '../../../widgets/feed_views/image_holder.dart';
import '../../../widgets/loader.dart';

class PublicProfileImageAndName extends StatelessWidget {
  const PublicProfileImageAndName({super.key});

  @override
  Widget build(BuildContext context) {
    var w = 100.0;
    UserProfileWare stream = context.watch<UserProfileWare>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            stream.publicUserProfileModel.profilephoto == null
                ? null
                : PageRouting.pushToPage(
                    context,
                    ImageHolder(
                      images: [
                        stream.publicUserProfileModel.profilephoto!.isEmpty
                            ? ""
                            : stream.publicUserProfileModel.profilephoto!
                      ],
                    ));
          },
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
                    child: CachedNetworkImage(
                      imageUrl:
                          stream.publicUserProfileModel.profilephoto ?? "",
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              Shimmer.fromColors(
                                  baseColor: Colors.grey,
                                  highlightColor:
                                      HexColor(backgroundColor).withOpacity(.7),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                  )),
                      errorWidget: (context, url, error) => CachedNetworkImage(
                        imageUrl:
                            stream.publicUserProfileModel.profilephoto ?? "",
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url,
                                downloadProgress) =>
                            Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor:
                                    HexColor(backgroundColor).withOpacity(.7),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                )),
                        errorWidget: (context, url, error) =>
                            CachedNetworkImage(
                                imageUrl: stream
                                        .publicUserProfileModel.profilephoto ??
                                    "",
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                            child: Loader(
                                          color: HexColor(backgroundColor),
                                        )),
                                errorWidget: (context, url, error) =>
                                    SizedBox()),
                      ),
                    )),
              ),
            ],
          ),
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
                        size: 16,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w800,
                        align: TextAlign.center,
                        maxLines: 1,
                        overflow: stream.publicUserProfileModel.username
                                    .toString()
                                    .length >
                                20
                            ? TextOverflow.ellipsis
                            : TextOverflow.fade,
                      ),
                    ),
                    stream.publicUserProfileModel.verified == 1 &&
                            stream.publicUserProfileModel.activePlan != sub
                        ? SvgPicture.asset(
                            "assets/icon/badge.svg",
                            height: 15,
                            width: 15,
                          )
                        : const SizedBox.shrink()
                  ],
                ),
        )
      ],
    );
  }
}

class PublicProfileImageAndNameExtra extends StatelessWidget {
  const PublicProfileImageAndNameExtra({super.key});

  @override
  Widget build(BuildContext context) {
    var w = 100.0;
    ExtraProfileWare stream = context.watch<ExtraProfileWare>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            stream.publicUserProfileModel.profilephoto == null
                ? null
                : PageRouting.pushToPage(
                    context,
                    ImageHolder(
                      images: [
                        stream.publicUserProfileModel.profilephoto!.isEmpty
                            ? ""
                            : stream.publicUserProfileModel.profilephoto!
                      ],
                    ));
          },
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
                    child: CachedNetworkImage(
                      imageUrl:
                          stream.publicUserProfileModel.profilephoto ?? "",
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              Shimmer.fromColors(
                                  baseColor: Colors.grey,
                                  highlightColor:
                                      HexColor(primaryColor).withOpacity(.7),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                  )),
                      errorWidget: (context, url, error) => CachedNetworkImage(
                        imageUrl:
                            stream.publicUserProfileModel.profilephoto ?? "",
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                Shimmer.fromColors(
                                    baseColor: Colors.grey,
                                    highlightColor:
                                        HexColor(primaryColor).withOpacity(.7),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.white,
                                    )),
                        errorWidget: (context, url, error) =>
                            CachedNetworkImage(
                                imageUrl: stream
                                        .publicUserProfileModel.profilephoto ??
                                    "",
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                            child: Loader(
                                          color: HexColor(primaryColor),
                                        )),
                                errorWidget: (context, url, error) =>
                                    SizedBox()),
                      ),
                    )),
              ),
            ],
          ),
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
                        size: 16,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w800,
                        align: TextAlign.center,
                        maxLines: 1,
                        overflow: stream.publicUserProfileModel.username
                                    .toString()
                                    .length >
                                20
                            ? TextOverflow.ellipsis
                            : TextOverflow.fade,
                      ),
                    ),
                    stream.publicUserProfileModel.verified == 1 &&
                            stream.publicUserProfileModel.activePlan != sub
                        ? SvgPicture.asset(
                            "assets/icon/badge.svg",
                            height: 15,
                            width: 15,
                          )
                        : const SizedBox.shrink()
                  ],
                ),
        )
      ],
    );
  }
}

class PublicProfileImageAndNameTest extends StatelessWidget {
  final PublicUserData stream;
  const PublicProfileImageAndNameTest({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    var w = 100.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            stream.profilephoto == null
                ? null
                : PageRouting.pushToPage(
                    context,
                    ImageHolder(
                      images: [
                        stream.profilephoto!.isEmpty ? "" : stream.profilephoto!
                      ],
                    ));
          },
          child: Stack(
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
                cornerRadius: 20.0,
                child: AspectRatio(
                    aspectRatio: HexagonType.POINTY.ratio,
                    child: CachedNetworkImage(
                      imageUrl: stream.profilephoto ?? "",
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              Shimmer.fromColors(
                                  baseColor: Colors.grey,
                                  highlightColor:
                                      HexColor(backgroundColor).withOpacity(.7),
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.white,
                                  )),
                      errorWidget: (context, url, error) => CachedNetworkImage(
                        imageUrl: stream.profilephoto ?? "",
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url,
                                downloadProgress) =>
                            Shimmer.fromColors(
                                baseColor: Colors.grey,
                                highlightColor:
                                    HexColor(backgroundColor).withOpacity(.7),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                )),
                        errorWidget: (context, url, error) =>
                            CachedNetworkImage(
                                imageUrl: stream.profilephoto ?? "",
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                            child: Loader(
                                          color: HexColor(backgroundColor),
                                        )),
                                errorWidget: (context, url, error) =>
                                    SizedBox()),
                      ),
                    )),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width * 0.7,
          height: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 210),
                child: AppText(
                  text: stream.username == null ? "" : "${stream.username}",
                  color: Colors.white.withOpacity(.6),
                  size: 16,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w800,
                  align: TextAlign.center,
                  maxLines: 1,
                  overflow: stream.username.toString().length > 20
                      ? TextOverflow.ellipsis
                      : TextOverflow.fade,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              stream.verified == 1 && stream.activePlan != sub
                  ? SvgPicture.asset(
                      "assets/icon/badge.svg",
                      height: 15,
                      width: 15,
                    )
                  : const SizedBox.shrink()
            ],
          ),
        )
      ],
    );
  }
}
