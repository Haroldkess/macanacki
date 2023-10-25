import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:numeral/numeral.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../model/feed_post_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../model/public_profile_model.dart';
import '../../../../services/controllers/feed_post_controller.dart';
import '../../../allNavigation.dart';
import '../../../widgets/text.dart';
import '../../home/Feed/profilefeed/public_profile_feed.dart';

class PublicGridViewItems extends StatefulWidget {
  final PublicUserPost data;
  final int index;
  final List<PublicUserPost> posts;
  const PublicGridViewItems(
      {super.key,
      required this.data,
      required this.index,
      required this.posts});

  @override
  State<PublicGridViewItems> createState() => _PublicGridViewItemsState();
}

class _PublicGridViewItemsState extends State<PublicGridViewItems> {
  String? thumbnail = "";
  @override
  void initState() {
    super.initState();

    //  getThumbnail();
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
    if (widget.data.media!.isEmpty) {
      return;
    }
    if (!widget.data.media!.first.contains(".mp4")) {
      return;
    }
    try {
      final fileName = await VideoThumbnail.thumbnailFile(
        video: widget.data.media!.first,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP,
        maxHeight:
            0, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 100,
      );

      // emitter(fileName.toString());
      if (mounted) {
        setState(() {
          thumbnail = fileName;
        });
      }
    } catch (e) {
      emitter(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: HexColor(primaryColor),
      onTap: () async {
        PageRouting.pushToPage(
            context,
            PublicUserProfileFeed(
              index: widget.index,
              data: widget.posts,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            //  borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: widget.data.media!.first.contains(".mp4")
                    ? CachedNetworkImageProvider(
                        widget.data.thumbnails!.first ?? "")
                    : CachedNetworkImageProvider(widget.data.media!.first)
                        as ImageProvider)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            widget.data.media!.first.contains(".mp4")
                ? Align(
                    alignment: Alignment.center,
                    child: Lottie.asset("assets/icon/mov.json",
                        height: 70, width: 70),
                  )

                // Icon(
                //     Icons.play_arrow,
                //     color: Colors.grey.withOpacity(0.9),
                //   )
                : widget.data.media!.first.contains(".mp3")
                    ? Align(
                        alignment: Alignment.center,
                        child: Lottie.asset("assets/icon/mov.json",
                            height: 70, width: 70),
                      )
                    : const SizedBox.shrink(),
            Positioned(
                child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icon/view.svg",
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
                        color: HexColor(backgroundColor),
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
