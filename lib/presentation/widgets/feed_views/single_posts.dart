import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:video_player/video_player.dart';

import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../screens/home/Feed/feed_video_cache.dart';
import '../../screens/home/Feed/feed_video_holder.dart';
import '../loader.dart';

class SinglePost extends StatelessWidget {
  final String media;
  final VideoPlayerController? controller;
  final bool shouldPlay;
  final BoxConstraints? constraints;
  final bool isHome;
  final String thumbLink;
  const SinglePost(
      {super.key,
      required this.media,
      required this.controller,
      required this.shouldPlay,
      required this.constraints,
      required this.isHome, required this.thumbLink});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return !media.contains("https")
        ?   FeedVideoHolder(
            file: "$muxStreamBaseUrl/$media.$videoExtension",
            controller: controller!,
            shouldPlay: true,
            isHome: isHome,
            thumbLink: thumbLink,
          ) 
        : Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      media,
                    ),
                    fit: BoxFit.fill,
                  )),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  )),
              CachedNetworkImage(
                imageUrl: media,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: Loader(
                  color: HexColor(primaryColor),
                )),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: HexColor(primaryColor),
                ),
              ),
              // Image(
              //   //  fit: BoxFit.fitWidth,
              //   width: constraints!.maxWidth,
              //   image: media.contains("/data/user/0/")
              //       ? FileImage(File(media))
              //       : CachedNetworkImageProvider(
              //           media.replaceAll('\\', '/'),
              //         ) as ImageProvider,
              // ),
            ],
          );
  }
}

class UserSinglePost extends StatelessWidget {
  final String media;
  final VideoPlayerController? controller;
  final bool shouldPlay;
  final BoxConstraints? constraints;
  final bool isHome;
  final String thumbLink;
  final String page;
  const UserSinglePost(
      {super.key,
      required this.media,
      required this.controller,
      required this.shouldPlay,
      required this.constraints,
      required this.isHome, required this.thumbLink, required this.page});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return !media.contains("https")
        ?   FeedVideoHolderPrivate(
            file: "$muxStreamBaseUrl/$media.$videoExtension",
            controller: controller!,
            shouldPlay: true,
            isHome: isHome,
            thumbLink: thumbLink,
            page: page,
          ) 
        : Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      media,
                    ),
                    fit: BoxFit.fill,
                  )),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  )),
              CachedNetworkImage(
                imageUrl: media,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: Loader(
                  color: HexColor(primaryColor),
                )),
                errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: HexColor(primaryColor),
                ),
              ),
              // Image(
              //   //  fit: BoxFit.fitWidth,
              //   width: constraints!.maxWidth,
              //   image: media.contains("/data/user/0/")
              //       ? FileImage(File(media))
              //       : CachedNetworkImageProvider(
              //           media.replaceAll('\\', '/'),
              //         ) as ImageProvider,
              // ),
            ],
          );
  }
}
