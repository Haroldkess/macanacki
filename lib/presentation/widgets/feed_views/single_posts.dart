import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../screens/home/Feed/feed_video_holder.dart';

class SinglePost extends StatelessWidget {
  final String media;
  final VideoPlayerController? controller;
  final bool shouldPlay;
  final BoxConstraints? constraints;
  final bool isHome;
  const SinglePost(
      {super.key,
      required this.media,
      required this.controller,
      required this.shouldPlay,
      required this.constraints, required this.isHome});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return media.contains(".mp4")
        ? FeedVideoHolder(
            file: media,
            controller: controller!,
            shouldPlay: true,
            isHome: isHome,
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: media.contains("/data/user/0/")
                        ? FileImage(File(media))
                        : CachedNetworkImageProvider(
                            media.replaceAll('\\', '/'),
                          ) as ImageProvider,
                    fit: BoxFit.fill,
                  )),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  )),
              Image(
                //  fit: BoxFit.fitWidth,
                width: constraints!.maxWidth,
                image: media.contains("/data/user/0/")
                    ? FileImage(File(media))
                    : CachedNetworkImageProvider(
                        media.replaceAll('\\', '/'),
                      ) as ImageProvider,
              ),
            ],
          );
  }
}
