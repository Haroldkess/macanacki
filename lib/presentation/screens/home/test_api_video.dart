import 'dart:developer';

import 'package:apivideo_player/apivideo_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_animations/animation_builder/play_animation_builder.dart';
import 'package:video_player/video_player.dart';

import '../../../model/feed_post_model.dart';
import '../../../services/controllers/view_controller.dart';
import '../../../services/middleware/video/video_ware.dart';
import '../../widgets/loader.dart';

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
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   VideoWare.instance
    //       .dismissSingleVideo(widget.controller, widget.data!.id!, true);
    // });
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
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   VideoWare.instance
    //       .addSingleVideo(widget.controller, widget.data!.id!, true);
    // });
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

class PlayerWidgetIos extends StatefulWidget {
  PlayerWidgetIos(
      {super.key,
      required this.controller,
      this.index,
      required this.data,
      required this.applyStyle});
  int? index;
  final VideoPlayerController controller;
  final FeedPost? data;
  final PlayerStyle applyStyle;

  @override
  State<PlayerWidgetIos> createState() => _PlayerWidgetIosState();
}

class _PlayerWidgetIosState extends State<PlayerWidgetIos> {
  bool isReady = false;
  bool tapped = false;

  bool delayUser = true;

  @override
  void initState() {
    widget.controller.initialize().then((value) {
      setState(() {});
      addListener();
      widget.controller.setLooping(true);
    });

    super.initState();
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   VideoWare.instance
    //       .dismissSingleVideo(widget.controller, widget.data!.id!, true);
    // });
    widget.controller.dispose();

    super.dispose();
  }

  void addListener() {
    widget.controller.addListener(() {
      if (widget.controller.value.isPlaying) {
        if (mounted) {
          setState(() {
            isReady = true;
            tapped = false;
            delayUser = false;
          });
        }
      }

      if (widget.controller.value.position.inSeconds >=
          (widget.controller.value.duration.inSeconds - 1)) {
        ViewController.handleView(widget.data!.id!);
      }
    });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   VideoWare.instance
    //       .addSingleVideo(widget.controller, widget.data!.id!, true);
    // });
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
                      // setState(() {
                      //   tapped = true;
                      // });

                      // widget.controller.play();

                      // if (widget.controller.value.isPlaying) {
                      //   setState(() {
                      //     isReady = true;
                      //     tapped = false;
                      //     delayUser = false;
                      //   });
                      // }

                      //  if (widget.index! == 0) {

                      // if (await widget.controller.isPlaying) {

                      // }
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
                            onPressed: () {
                              setState(() {
                                tapped = true;
                              });

                              widget.controller.play();

                              if (widget.controller.value.isPlaying) {
                                setState(() {
                                  isReady = true;
                                  tapped = false;
                                  delayUser = false;
                                });
                              }
                            },
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
        : AspectRatio(
            aspectRatio: widget.controller.value.aspectRatio,
            child: VideoPlayer(
              widget.controller,
              //  style: widget.applyStyle,
            ),
          );
  }
}
