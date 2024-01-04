import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:macanacki/model/profile_feed_post.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/uiproviders/screen/tab_provider.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../model/feed_post_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../operations.dart';
import '../../../../widgets/text.dart';
import '../../Feed/profilefeed/user_profile_feed.dart';

class GridViewItems extends StatefulWidget {
  final FeedPost data;
  final int index;
  final bool isAudio;
  final int isHome;
  const GridViewItems(
      {super.key,
      required this.data,
      required this.index,
      required this.isAudio,
      required this.isHome});

  @override
  State<GridViewItems> createState() => _GridViewItemsState();
}

class _GridViewItemsState extends State<GridViewItems> {
  String? thumbnail = "";
  @override
  void initState() {
    super.initState();

    // getThumbnail();
  }

// getgif (){
//   return CachedVideoPreview(
//   path: widget.data.media!,
//   type: SourceType.remote,
//   httpHeaders: const <String, String>{},
//   remoteImageBuilder: (BuildContext context, url) =>
//       Image.network(url),
// )

//}
  // getThumbnail() async {
  //   if (!widget.data.media!.contains(".mp4")) {
  //     return;
  //   }
  //   try {
  //     final fileName = await VideoThumbnail.thumbnailFile(
  //       video: widget.data.media!.first,
  //       thumbnailPath: (await getTemporaryDirectory()).path,
  //       imageFormat: ImageFormat.WEBP,
  //       maxHeight:
  //           0, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
  //       quality: 100,
  //     ).whenComplete(() => log(" thumbnail generated"));

  //     log(fileName.toString());
  //     setState(() {
  //       thumbnail = fileName;
  //     });
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    UserProfileWare provide =
        Provider.of<UserProfileWare>(context, listen: false);
    return InkWell(
      splashColor: HexColor(primaryColor),
      onTap: () async {
        //    provide.changeIndex(widget.index);
        PageRouting.pushToPage(
            context,
            UserProfileFeed(
              index: widget.index,
              isAudio: widget.isAudio,
              isHome: widget.isHome,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: widget.data.media!.contains(".mp4") ||
                        widget.data.media!.first.contains(".mp3") ||
                        !widget.data.media!.first.contains("http")
                    ? NetworkImage(widget.data.thumbnails!.first ?? "")
                    : NetworkImage(widget.data.media!.first) as ImageProvider)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            widget.data.media!.contains(".mp4")
                ? Align(
                    alignment: Alignment.center,
                    child: Lottie.asset("assets/icon/mov.json",
                        height: 70, width: 70),
                  )

                // Icon(
                //     Icons.play_arrow,
                //     color: Colors.grey.withOpacity(0.9),
                //   )
                : const SizedBox.shrink(),
            Positioned(
                child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/icon/view.svg",
                    color: Colors.white,
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class MyGridViewItems extends StatefulWidget {
  final ProfileFeedDatum data;
  final int index;
  final bool isAudio;
  final int isHome;
  const MyGridViewItems(
      {super.key,
      required this.data,
      required this.index,
      required this.isAudio,
      required this.isHome});

  @override
  State<MyGridViewItems> createState() => _MyGridViewItemsState();
}

class _MyGridViewItemsState extends State<MyGridViewItems> {
  String? thumbnail = "";
  @override
  void initState() {
    super.initState();
    Operations.controlSystemColor();
    // getThumbnail();
  }

// getgif (){
//   return CachedVideoPreview(
//   path: widget.data.media!,
//   type: SourceType.remote,
//   httpHeaders: const <String, String>{},
//   remoteImageBuilder: (BuildContext context, url) =>
//       Image.network(url),
// )

//}
  getThumbnail() async {
    // if (!widget.data.media!.first.contains(".mp4")) {
    //   return;
    // }
    // try {
    //   final fileName = await VideoThumbnail.thumbnailFile(
    //     video: widget.data.media!.first,
    //     thumbnailPath: (await getTemporaryDirectory()).path,
    //     imageFormat: ImageFormat.WEBP,
    //     maxHeight:
    //         0, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    //     quality: 100,
    //   ).whenComplete(() => emitter("thumbnail generated"));

    //   // log(fileName.toString());
    //   if (mounted) {
    //     setState(() {
    //       thumbnail = fileName;
    //     });
    //   }
    // } catch (e) {
    //   emitter(e.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    UserProfileWare provide =
        Provider.of<UserProfileWare>(context, listen: false);
    return InkWell(
      splashColor: HexColor(primaryColor),
      onTap: () async {
        Operations.controlSystemColor();
        TabProvider action = Provider.of<TabProvider>(context, listen: false);
        action.isHomeChange(true);
        //    provide.changeIndex(widget.index);
        PageRouting.pushToPage(
            context,
            UserProfileFeed(
              index: widget.index,
              isAudio: widget.isAudio,
              isHome: widget.isHome,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: widget.data.media!.first.contains(".mp4") ||
                        widget.data.media!.first.contains(".mp3") ||
                        !widget.data.media!.first.contains("http")
                    ? CachedNetworkImageProvider(
                        widget.data.thumbnails!.first ?? "")
                    : CachedNetworkImageProvider(widget.data.media!.first)
                        as ImageProvider)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: Get.height,
              width: Get.width,
              child: CachedNetworkImage(
                imageUrl: widget.data.media!.first.contains(".mp4") ||
                        widget.data.media!.first.contains(".mp3") ||
                        !widget.data.media!.first.contains("http")
                    ? widget.data.thumbnails!.first ?? ""
                    : widget.data.media!.first,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Shimmer.fromColors(
                        baseColor: HexColor(backgroundColor),
                        highlightColor: Colors.grey.withOpacity(.2),
                        period: Duration(seconds: 1),
                        child: Container(
                          color: HexColor(backgroundColor),
                        )),
                errorWidget: (context, url, error) => CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Shimmer.fromColors(
                          baseColor: HexColor(backgroundColor),
                          highlightColor: Colors.grey.withOpacity(.2),
                          period: Duration(seconds: 1),
                          child: Container(
                            color: HexColor(backgroundColor),
                          )),
                  errorWidget: (context, url, error) => CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              Shimmer.fromColors(
                                  baseColor: HexColor(backgroundColor),
                                  highlightColor: Colors.grey.withOpacity(.2),
                                  period: Duration(seconds: 1),
                                  child: Container(
                                    color: HexColor(backgroundColor),
                                  )),
                      errorWidget: (context, url, error) => SizedBox()),
                ),
              ),
            ),
            widget.data.media!.first.contains(".mp4")
                ? Align(
                    alignment: Alignment.center,
                    child: Lottie.asset("assets/icon/mov.json",
                        height: 70, width: 70),
                  )
                : widget.data.media!.first.contains(".mp3")
                    ? Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/icon/aud.svg",
                          height: 25,
                          width: 25,
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox.shrink(),
            Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(.0),
                      Colors.black.withOpacity(.0),
                      Colors.black.withOpacity(.0),
                      Colors.black.withOpacity(.1),
                      Colors.black.withOpacity(.4),
                    ],
                    stops: [
                      0.0,
                      0.1,
                      0.3,
                      0.8,
                      0.9
                    ]),
              ),
            ),
            Positioned(
                child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icon/bar.svg",
                      color: Colors.white,
                      height: 10,
                      //   width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 3),
                      child: AppText(
                        text: Numeral(widget.data.viewCount!)
                            .format(fractionDigits: 1),
                        fontWeight: FontWeight.w600,
                        size: 12,
                        color: Colors.white,
                        //  color: HexColor(backgroundColor),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
