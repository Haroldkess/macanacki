import 'dart:developer';

import 'package:apivideo_player/apivideo_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';

import '../../../model/feed_post_model.dart';
import '../../../services/controllers/view_controller.dart';
import '../../widgets/loader.dart';

// class ApiVideoDemo extends StatelessWidget {
//   const ApiVideoDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     PageController pageController =
//         PageController(initialPage: 0, keepPage: false);
//     List<String> demoVideos = [
//       "vi5ytnPMtCQR8XUyU5yOqJWP",
//       "vi7OTHEnU8egpug47CDJddor",
//       "vi58kXu4ezjMqtdt0yjEKxTJ",
//       "vi1vN8pDBBAJ70cDXBlrfCxn",
//       "vi6agTwyDINhyYVGZg8hsBBW",
//       "vi7RYvsDH5tuzPL7AzHa6Vg7",
//       "vi3RqBWa6WjSlct8hi3fNgZA",
//       "vi17coOs319rN7WgtTG2gW8d",
//       "vi7OTHEnU8egpug47CDJddor",
//       "vi5ytnPMtCQR8XUyU5yOqJWP"
//     ];
//     return SizedBox(
//       height: Get.height,
//       width: Get.width,
//       child: PageView.builder(
//           itemCount: demoVideos.length,
//           controller: pageController,
//           //  preloadPagesCount: 0,
//           scrollDirection: Axis.vertical,
//           itemBuilder: ((context, index) {
//             String vod = demoVideos[index];
//             return VodView(
//               vod: vod,
//             );
//           })),
//     );
//   }
// }

// class VodView extends StatefulWidget {
//   final String vod;
//   final FeedPost? data;
//   int? index;
//   ApiVideoPlayerController? controller;

//   VodView(
//       {super.key, required this.vod, this.data, this.index, this.controller});

//   @override
//   State<VodView> createState() => _VodViewState();
// }

// class _VodViewState extends State<VodView> {
//   ApiVideoPlayerController? _controller;
//   String apiToken = "";
//   @override
//   void initState() {
//     super.initState();

//     widget.controller!.initialize();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.controller != null
//         ? PlayerWidget(
//             controller: widget.controller!,
//             index: widget.index,
//             data: widget.data,
//           )
//         : Container(
//             width: Get.width,
//             height: Get.height,
//             decoration: BoxDecoration(
//                 color: Colors.black,
//                 image: DecorationImage(
//                   image: CachedNetworkImageProvider(
//                       widget.data!.thumbnails!.first ?? ""),
//                   fit: BoxFit.cover,
//                 )),
//           );
//   }
// }

class PlayerWidget extends StatefulWidget {
  PlayerWidget(
      {super.key,
      required this.controller,
      this.index,
      required this.data,
      required this.applyStyle});
  int? index;
  final ApiVideoPlayerController controller;
  final FeedPost? data;
  final PlayerStyle applyStyle;

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  bool isReady = false;
  bool tapped = false;

  bool delayUser = true;

  @override
  void initState() {
    widget.controller.initialize();
    addListener();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();

    super.dispose();
  }

  void addListener() {
    widget.controller.addListener(ApiVideoPlayerControllerEventsListener(
      onReady: () async {
        if (await widget.controller.isPlaying) {
          setState(() {
            isReady = true;
            tapped = false;
            delayUser = false;
          });
        }
      },
      onPlay: () {
        // setState(() {
        //   isReady = true;
        //   _duration = 'Get duration';
        // });
      },
      onEnd: () {
        log("video ended");
        ViewController.handleView(widget.data!.id!);
        setState(() {});
      },
    ));
  }

  // onTap: () async {
  //                   setState(() {
  //                     isReady = false;
  //                     tapped = true;
  //                     delayUser = true;
  //                     _duration = 'Get duration';
  //                   });
  //                   if (await widget.controller.isCreated) {
  //                     print("here");
  //                     widget.controller.play();
  //                     widget.controller.setIsLooping(true);

  //                     if (await widget.controller.isPlaying) {
  //                       setState(() {
  //                         isReady = true;
  //                         tapped = false;
  //                         delayUser = false;
  //                         _duration = 'Get duration';
  //                       });
  //                     }

  //                     addListener();

  //                     setState(() {
  //                       _duration = 'Get duration';
  //                     });
  //                     // widget.controller.play();

  //                     setState(() {});
  //                   } else if (widget.index != 0) {
  //                     // widget.controller.dispose();
  //                     setState(() {
  //                       tapped = true;
  //                       delayUser = true;
  //                       isReady = false;
  //                     });
  //                     await widget.controller.initialize();
  //                     setState(() {
  //                       widget.controller.addListener(
  //                           ApiVideoPlayerControllerEventsListener(
  //                         onReady: () {
  //                           if (widget.index == 0) {
  //                             widget.controller.play();
  //                             widget.controller.setIsLooping(true);
  //                           } else {
  //                             widget.controller.play();
  //                             widget.controller.setIsLooping(true);
  //                           }
  //                           setState(() {
  //                             isReady = true;
  //                             tapped = false;
  //                             delayUser = false;
  //                             _duration = 'Get duration';
  //                           });
  //                         },
  //                         onPlay: () {
  //                           // setState(() {
  //                           //   isReady = true;
  //                           //   _duration = 'Get duration';
  //                           // });
  //                         },
  //                         onEnd: () {
  //                           setState(() {});
  //                         },
  //                       ));
  //                       _duration = 'Get duration';
  //                     });
  //                     // widget.controller.play();

  //                     setState(() {});
  //                   }
  //                 },

  @override
  Widget build(BuildContext context) {
    return isReady == false || delayUser
        ? Stack(
            children: [
              Container(
                width: Get.width,
                height: Get.height,
                decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          widget.data!.thumbnails!.first ?? ""),
                      fit: BoxFit.cover,
                    )),
              ),
              Align(
                alignment: Alignment.center,
                child: PlayAnimationBuilder<double>(
                    tween: Tween(begin: 10.0, end: 50.0), // set tween
                    duration: const Duration(milliseconds: 1500),
                    onCompleted: () async {
                      setState(() {
                        tapped = true;
                      });

                      widget.controller.play();

                      //  if (widget.index! == 0) {

                      if (await widget.controller.isPlaying) {
                        setState(() {
                          isReady = true;
                          tapped = false;
                          delayUser = false;
                        });
                      }
                    }, // set duration
                    builder: (context, value, _) {
                      return Container(
                        height: value,
                        width: value,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            border:
                                Border.all(width: 4.0, color: Colors.white)),
                        child: Center(
                          child: IconButton(
                            onPressed: null,
                            icon: tapped
                                ? const Loader(
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    // size: 35,
                                  ),
                            style: widget.applyStyle.controlsBarStyle!
                                .mainControlButtonStyle,
                          ),
                        ),
                      );
                    }),
              )
            ],
          )
        : SizedBox(
            width: Get.width,
            height: Get.height,
            child: ApiVideoPlayer(
              controller: widget.controller,
              style: widget.applyStyle,
            ),
          );
  }
}
