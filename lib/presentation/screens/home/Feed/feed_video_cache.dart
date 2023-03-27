import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:better_player/better_player.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

import '../../../uiproviders/screen/tab_provider.dart';

class FeedVideoCache extends StatefulWidget {
  final String file;
  const FeedVideoCache({super.key, required this.file});

  @override
  State<FeedVideoCache> createState() => _FeedVideoCacheState();
}

class _FeedVideoCacheState extends State<FeedVideoCache> {
  BetterPlayerController? _controller;

  String? thumbnail = "";

  getThumbnail() async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: widget.file,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight:
          64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    ).whenComplete(() => log(" thumbnail generated"));

    log(fileName.toString());
    setState(() {
      thumbnail = fileName;
    });
  }

  @override
  void initState() {
    super.initState();
    getThumbnail();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      widget.file,
      // cacheConfiguration: const BetterPlayerCacheConfiguration(
      //   useCache: true,
      //   preCacheSize: 10 * 1024 * 1024,
      //   maxCacheSize: 10 * 1024 * 1024,
      //   maxCacheFileSize: 10 * 1024 * 1024,

      //   ///Android only option to use cached video between app sessions
      //   key: "testCacheKey",
      // ),
    );

    _controller = BetterPlayerController(
         BetterPlayerConfiguration(),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  Future<void> innit() async {}

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller!.dispose();

    super.dispose();
  }

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TabProvider tabs = context.watch<TabProvider>();
    return AspectRatio(
      aspectRatio: _controller!.videoPlayerController!.value.aspectRatio,
      child: BetterPlayer(
        controller: _controller!,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    print("we moved");
    //  _controller.pause();
    super.didChangeDependencies();
  }
}
