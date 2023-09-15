import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/model/profile_feed_post.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/uiproviders/screen/tab_provider.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../model/feed_post_model.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../operations.dart';
import '../../../../widgets/text.dart';
import '../../Feed/profilefeed/user_profile_feed.dart';

class GridViewItems extends StatefulWidget {
  final FeedPost data;
  final int index;
  const GridViewItems({super.key, required this.data, required this.index});

  @override
  State<GridViewItems> createState() => _GridViewItemsState();
}

class _GridViewItemsState extends State<GridViewItems> {
  String? thumbnail = "";
  @override
  void initState() {
    super.initState();

    getThumbnail();
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
    if (!widget.data.media!.contains(".mp4")) {
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
      ).whenComplete(() => log(" thumbnail generated"));

      log(fileName.toString());
      setState(() {
        thumbnail = fileName;
      });
    } catch (e) {
      log(e.toString());
    }
  }

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
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: widget.data.media!.contains(".mp4")
                    ? FileImage(File(thumbnail!))
                    : NetworkImage(widget.data.media!.first) as ImageProvider)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            widget.data.media!.contains(".mp4")
                ? Icon(
                    Icons.play_arrow,
                    color: Colors.grey.withOpacity(0.9),
                  )
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
  const MyGridViewItems({super.key, required this.data, required this.index});

  @override
  State<MyGridViewItems> createState() => _MyGridViewItemsState();
}

class _MyGridViewItemsState extends State<MyGridViewItems> {
  String? thumbnail = "";
  @override
  void initState() {
    super.initState();
    Operations.controlSystemColor();
    getThumbnail();
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
      ).whenComplete(() => emitter("thumbnail generated"));

      // log(fileName.toString());
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
            ));
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: widget.data.media!.first.contains(".mp4")
                    ? FileImage(File(thumbnail!))
                    : CachedNetworkImageProvider(widget.data.media!.first)
                        as ImageProvider)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            widget.data.media!.first.contains(".mp4")
                ? Icon(
                    Icons.play_arrow,
                    color: Colors.grey.withOpacity(0.9),
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
                        text: Numeral(widget.data.viewCount!).format(),
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
