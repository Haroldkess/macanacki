import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

import '../../../uiproviders/screen/tab_provider.dart';

class FeedVideoHolder extends StatefulWidget {
  String file;
  VideoPlayerController controller;

  bool shouldPlay;
  FeedVideoHolder(
      {super.key,
      required this.file,
      required this.controller,
      required this.shouldPlay});

  @override
  State<FeedVideoHolder> createState() => _FeedVideoHolderState();
}

class _FeedVideoHolderState extends State<FeedVideoHolder> {
  late Future<void> _initializeVideoPlayerFuture;

  String? thumbnail = "";

  getThumbnail() async {
    try {
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
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getThumbnail();

    // Initialize the controller and store the Future for later use.
    // _initializeVideoPlayerFuture =
    //     widget.controller.initialize().whenComplete(() {
    //   if (widget.shouldPlay) {
    //     widget.controller.play();
    //     setState(() {});
    //   }
    // });

    // // Use the controller to loop the video.
    // if (widget.shouldPlay) {
    //   widget.controller.setLooping(true);
    // }
  }

  Future<void> innit() async {}

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    widget.controller.dispose();

    super.dispose();
  }

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TabProvider tabs = context.watch<TabProvider>();
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: FileImage(File(thumbnail!)),
              fit: BoxFit.fill,
            )),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            )),
        Container(
          height: double.infinity,
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            // Use the VideoPlayer widget to display the video.
            child: VideoPlayer(widget.controller),
          ),
        ),
        InkWell(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if (widget.controller.value.isInitialized == false) {
              return;
            }
            if (isTapped) {
              setState(() {
                isTapped = false;
              });
            } else {
              setState(() {
                isTapped = true;
              });
            }
            if (widget.controller.value.isPlaying) {
              widget.controller.pause();

              //   isPaused = true;
            } else {
              widget.controller.play();

              // isPaused = false;
            }
          },
          child: Container(
            color: Colors.transparent,
            width: width,
            height: height,
            //  color: Colors.amber,
            child: !widget.controller.value.isPlaying
                ? Icon(
                    Icons.play_arrow,
                    size: 50,
                    color: Colors.white.withOpacity(0.6),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: VideoProgressIndicator(
              widget.controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                  backgroundColor: Colors.transparent,
                  bufferedColor: HexColor(primaryColor).withOpacity(0.4),
                  playedColor: HexColor(primaryColor)),
            ))
      ],
    );
  }

  @override
  void didChangeDependencies() {
    widget.controller.pause();
    super.didChangeDependencies();
  }
}
