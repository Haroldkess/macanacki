import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/services/middleware/feed_post_ware.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../services/controllers/feed_post_controller.dart';
import '../../../constants/string.dart';
import '../../../uiproviders/screen/tab_provider.dart';

class FeedVideoHolderPrivate extends StatefulWidget {
  String file;
  VideoPlayerController controller;
  bool isHome;
  bool shouldPlay;
  String thumbLink;
  final String page;

  FeedVideoHolderPrivate(
      {super.key,
      required this.file,
      required this.controller,
      required this.isHome,
      required this.shouldPlay,
      required this.thumbLink,
      required this.page});

  @override
  State<FeedVideoHolderPrivate> createState() => _FeedVideoHolderPrivateState();
}

class _FeedVideoHolderPrivateState extends State<FeedVideoHolderPrivate> {
  late Future<void> _initializeVideoPlayerFuture;

  String? thumbnail = "";

  getThumbnail() async {
    try {
      final fileName = await VideoThumbnail.thumbnailFile(
        video: "$muxStreamBaseUrl/${widget.file}.$videoExtension",
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight:
            64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      ).whenComplete(() => emitter(" thumbnail generated"));

      emitter(fileName.toString());
      setState(() {
        thumbnail = fileName;
      });
    } catch (e) {
      emitter(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    //   getThumbnail();
    // widget.controller.play();
    // log(widget.file);
////if (widget.isHome) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TabProvider tabs = Provider.of<TabProvider>(context, listen: false);

      tabs.addControl(widget.controller);

      //   tabs.tap(false);
    });
    // }
  }

  Future<void> innit() async {}

  @override
  void dispose() {
    widget.controller.dispose();

    // if (widget.page == "user") {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        TabProvider tabs = Provider.of<TabProvider>(context, listen: false);
        tabs.disposeControl();
      }

      //   //tabs.tap(false);
    });
//}
    super.dispose();
  }

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TabProvider action = Provider.of<TabProvider>(context, listen: false);
    TabProvider tabs = context.watch<TabProvider>();
    FeedPostWare stream = context.watch<FeedPostWare>();

    return Stack(
      alignment: Alignment.center,
      children: [
        StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              List<String> data = stream.thumbs.where((val) {
                return val.contains(widget.thumbLink);
              }).toList();
              if (data.isEmpty) {
                emitter("nothing found ${widget.controller.value.isPlaying}");
              } else {
                var val = data.first.split(widget.thumbLink);

                // emitter(val.first + "  Second" + val.last);
              }

              return data.isEmpty
                  ? Container(
                      width: width,
                      height: height,
                      color: Colors.black,
                    )
                  : Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            image: FileImage(
                                File(data.first.split(widget.thumbLink).first)),
                            fit: BoxFit.contain,
                          )),
                      child: widget.controller.value.duration <
                              Duration(milliseconds: 500)
                          ? null
                          : Container(
                              width: width,
                              height: height,
                              color: Colors.black,
                            ));
            }),

        // FutureBuilder<String?>(
        //     future: FeedPostController.genThumbnail(widget.thumbLink,height),
        //     builder: (context, AsyncSnapshot<String?> snapshot) {
        //       if (!snapshot.hasData) {
        //         return Container(
        //           width: width,
        //           height: height,
        //           color: Colors.black,
        //         );
        //       }
        //       return Container(
        //         width: width,
        //         height: height,
        //         decoration: BoxDecoration(
        //             color: Colors.black,
        //             image: DecorationImage(
        //               image: FileImage(File(snapshot.data!)),
        //               fit: BoxFit.fill,
        //             )),
        //         // child: BackdropFilter(
        //         //   filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        //         //   child: Container(
        //         //     decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
        //         //   ),
        //         // )
        //       );

        //     }),
        widget.controller.value.aspectRatio == null ||
                widget.controller.value.isInitialized == false ||
                widget.controller.value.duration < Duration(milliseconds: 500)
            ? Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                    //  color: Colors.amber,
                    gradient: LinearGradient(colors: [
                  HexColor(primaryColor).withOpacity(0.2),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                ])),
              )
            : Container(
                // width: double.infinity,
                // height: widget.controller.value.aspectRatio < 1
                //     ? height
                //     : null,
                child: AspectRatio(
                  aspectRatio: widget.controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(widget.controller),
                ),
              ),
        widget.controller.value.duration < const Duration(milliseconds: 500) &&
                isTapped == false
            ? const SizedBox.shrink()
            : InkWell(
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
                  child: !widget.controller.value.isPlaying && isTapped
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
            height: 6,
            child: VideoProgressIndicator(
              widget.controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                  backgroundColor: Colors.transparent,
                  bufferedColor: HexColor(headings).withOpacity(0.4),
                  playedColor: baseColor),
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
