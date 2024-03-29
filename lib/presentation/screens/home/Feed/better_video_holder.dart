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

class FeedVideoHolderV2 extends StatefulWidget {
  String file;
  VideoPlayerController? controller;
  bool isHome;
  bool shouldPlay;
  String thumbLink;
  final String page;
  bool? isInView;


  FeedVideoHolderV2({
    super.key,
    required this.file,
    required this.controller,
    required this.isHome,
    required this.shouldPlay,
    required this.thumbLink,
    required this.page,
    required this.isInView,

  });

  @override
  State<FeedVideoHolderV2> createState() => _FeedVideoHolderV2State();
}

class _FeedVideoHolderV2State extends State<FeedVideoHolderV2> {
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
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   TabProvider tabs = Provider.of<TabProvider>(context, listen: false);

    //   tabs.addHoldControl(widget.controller!);

    //   tabs.tap(true);

    //   //   tabs.tap(false);
    // });
    // }
  }

  Future<void> innit() async {}

  @override
  void dispose() {
 

    super.dispose();

    // if (widget.page == "user") {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     TabProvider tabs = Provider.of<TabProvider>(context, listen: false);
    //     tabs.disposeHolldControl();
    //   }
    //   //   //tabs.tap(false);
    // });
//}
  }

  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    log("------------------------------------- Better Video Holder");
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
                //   emitter("nothing found ${widget.controller.value.isPlaying}");
              } else {
                var val = data.first.split(widget.thumbLink);

                // emitter(val.first + "  Second" + val.last);
              }
              // if (widget.isInView == true) {
              // log(" IN VIEW ${widget.data.user!.username}, ${widget.data.description}");
              //  log("${widget.data.description} ${widget.isInView == true ? "is in view" : "null"}");

              // if (widget.controller != null) {
              //   if (widget.controller!.value.isInitialized) {
              //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //       if (mounted) {
              //         if (isTapped == false) {
              //           widget.controller!.play();
              //         }
              //       }
              //     });
              //   }
              // }
              //   }

              // else {
              //   //  log("NO LONGER IN VIEW ${widget.data.user!.username}, ${widget.data.description}");

              //   if (widget.controller != null) {
              //     if (widget.controller!.value.isInitialized) {
              //       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //         if (mounted) {
              //           widget.controller!.pause();
              //         }
              //       });
              //     }
              //   }
              // }

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
                      child: Container(
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

        Container(
          // width: double.infinity,
          // height: widget.controller.value.aspectRatio < 1
          //     ? height
          //     : null,
          // child: VlcPlayer(
          //   controller: widget.vlcController!,
          //   aspectRatio: widget.vlcController!.value.aspectRatio,
          //   placeholder: Center(child: CircularProgressIndicator()),
          // ),
        ),
        // widget.controller!.value.duration < const Duration(milliseconds: 500) &&
        //         isTapped == false
        //     ? const SizedBox.shrink()
        //     : InkWell(
        //         splashColor: Colors.transparent,
        //         hoverColor: Colors.transparent,
        //         highlightColor: Colors.transparent,
        //         onTap: () {
        //           if (widget.controller!.value.isInitialized == false) {
        //             return;
        //           }
        //           if (isTapped) {
        //             setState(() {
        //               isTapped = false;
        //             });
        //           } else {
        //             setState(() {
        //               isTapped = true;
        //             });
        //           }
        //           if (widget.controller!.value.isPlaying) {
        //             widget.controller!.pause();

        //             //   isPaused = true;
        //           } else {
        //             widget.controller!.play();

        //             // isPaused = false;
        //           }
        //         },
        //         child: Container(
        //           color: Colors.transparent,
        //           width: width,
        //           height: height,
        //           //  color: Colors.amber,
        //           child: !widget.controller!.value.isPlaying && isTapped
        //               ? Icon(
        //                   Icons.play_arrow,
        //                   size: 50,
        //                   color: Colors.white.withOpacity(0.6),
        //                 )
        //               : const SizedBox.shrink(),
        //         ),
        //       ),
        // Positioned(
        //     bottom: 0,
        //     width: MediaQuery.of(context).size.width,
        //     height: 6,
        //     child: VideoProgressIndicator(
        //       widget.controller!,
        //       allowScrubbing: true,
        //       colors: VideoProgressColors(
        //           backgroundColor: Colors.transparent,
        //           bufferedColor: HexColor(headings).withOpacity(0.4),
        //           playedColor: baseColor),
        //     ))
      ],
    );
  }

  @override
  void didChangeDependencies() {
    if (mounted) {
      if (isTapped == false) {
        // widget.controller.play();
      }
    }
    super.didChangeDependencies();
  }
}
