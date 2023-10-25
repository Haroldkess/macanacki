import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:apivideo_player/apivideo_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/screens/home/test_api_video.dart';
import 'package:macanacki/presentation/widgets/feed_views/new_action_design.dart';
import 'package:macanacki/services/middleware/video/video_ware.dart';
import 'package:provider/provider.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';

import '../../../../model/feed_post_model.dart';
import '../../../../services/controllers/action_controller.dart';
import '../../../../services/middleware/action_ware.dart';
import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../constants/string.dart';
import '../../../uiproviders/screen/tab_provider.dart';
import '../../../widgets/ads_display.dart';
import '../../../widgets/debug_emitter.dart';
import '../../../widgets/feed_views/like_section.dart';
import '../../../widgets/loader.dart';

class FeedVideoHolderPrivate extends StatefulWidget {
  String file;
//  VideoPlayerController? controller;
  bool isHome;
  bool shouldPlay;
  String thumbLink;
  final String page;
  bool? isInView;
  int postId;
  final FeedPost data;

  FeedVideoHolderPrivate(
      {super.key,
      required this.file,
      //  required this.controller,
      required this.isHome,
      required this.shouldPlay,
      required this.thumbLink,
      required this.page,
      required this.isInView,
      required this.postId,
      required this.data});

  @override
  State<FeedVideoHolderPrivate> createState() => _FeedVideoHolderPrivateState();
}

class _FeedVideoHolderPrivateState extends State<FeedVideoHolderPrivate>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  bool dismissed = false;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500), //controll animation duration
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    animation = ColorTween(
      begin: Colors.transparent,
      end: HexColor(primaryColor).withOpacity(.8),
    ).animate(controller);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (PersistentNavController.instance.hide.value == false) {
        PersistentNavController.instance.toggleHide();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      VideoWare.instance.loadVideo(true);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // VideoWareHome.instance.initSomeVideo(
      //     "$muxStreamBaseUrl/${widget.data.mux!.first}.$videoExtension",
      //     widget.postId,
      //     0);

      VideoWare.instance.disposeAllVideo(
        widget.postId,
        "$muxStreamBaseUrl/${widget.data.mux!.first}.$videoExtension",
      );

      VideoWare.instance.disposeAllVideoV2(widget.data.id!,
          "$muxStreamBaseUrl/${widget.data.mux!.first}.$videoExtension");
    });

    super.dispose();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PersistentNavController.instance.toggleHide();
    });
  }

  bool flag = false;
  PageController pageController =
      PageController(initialPage: 0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
    // PreloadPageController controller =
    //     PreloadPageController(initialPage: 0, keepPage: true);
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: ObxValue((allVideos) {
        return PageView.builder(
          itemCount: allVideos.length,
          controller: pageController,
          //  preloadPagesCount: 0,
          scrollDirection: Axis.vertical,
          itemBuilder: ((context, index) {
            FeedPost post = allVideos[index];
            return GestureDetector(
              // onTap: () {
              //   if (index != 0) {
              //     VideoWare.instance.loadVideo(true);

              //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //       VideoWare.instance.initSomeVideo(
              //           "$muxStreamBaseUrl/${post.mux!.first}.$videoExtension",
              //           post.id!,
              //           index);
              //     });
              //   }
              // },
              onDoubleTap: () async {
                if (mounted) {
                  if (controller.value == 1) {
                    controller.reset();
                    controller.forward();
                  } else {
                    controller.forward();
                  }

                  if (action.likeIds.contains(post.id!)) {
                    setState(() {
                      flag = true;
                    });
                    await Future.delayed(const Duration(seconds: 2));

                    setState(() {
                      flag = false;
                    });

                    return;
                  }
                  setState(() {
                    flag = true;
                  });

                  await likeAction(context, true, post.id!);

                  await Future.delayed(const Duration(seconds: 2));

                  setState(() {
                    flag = false;
                  });
                }
              },
              child: Stack(
                children: [
                  VideoView2(
                      thumbLink: post.thumbnails!.first ?? "",
                      page: widget.page,
                      postId: post.id!,
                      index: index,
                      data: post,
                      isHome: false),
                  widget.data.promoted == "yes"
                      ? Positioned(
                          bottom: 140,
                          left: 0,
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // AdsDisplay(
                                  //   sponsored: false,
                                  //   color: HexColor('#00B074'),
                                  //   title: '\$10.000.00',
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  AdsDisplay(
                                    sponsored: true,
                                    //  color: HexColor('#00B074'),
                                    color: Colors.grey.shade400,
                                    title: 'Sponsored Ad',
                                  ),
                                ],
                              )),
                        )
                      : SizedBox.shrink(),
                  flag
                      ? Center(
                          child: Align(
                            alignment: Alignment.center,
                            child: AnimatedContainer(
                              duration: const Duration(seconds: 3),
                              curve: Curves.bounceInOut,
                              onEnd: () {
                                setState(() {
                                  flag = false;
                                });
                              },
                              child: Icon(
                                Icons.favorite,
                                size: Get.width * 0.4,
                                color: animation.value,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            );
          }),
          onPageChanged: (index) {
            if (index != 0) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                VideoWare.instance.loadVideo(false);
              });
            }
          },
        );
      }, VideoWare.instance.feedPosts),
    );
  }

  Future<void> likeAction(BuildContext context, bool like, int id) async {
    ActionWare provide = Provider.of<ActionWare>(context, listen: false);
    late bool isLiked;
    // print(like.toString());
    provide.tempAddLikeId(id);

    if (like == false) {
      isLiked = true;
      ActionController.likeOrDislikeController(context, id);
    } else {
      //  provide.tempAddLikeId(widget.data.id!);
      isLiked = false;
      ActionController.likeOrDislikeController(context, id);
    }

    // return !isLiked;
  }

  Future paginateFeed() async {
    emitter("Pageinating");
    //FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);

    ///  provide.indexChange(index);

    // int checkNum = provide.feedPosts.length - 3; // lenght of posts
    int pageNum = VideoWareHome
        .instance.feedData.value.currentPage!; // api current  page num
    int maxPages =
        VideoWareHome.instance.feedData.value.lastPage!; // api last page num
    //  emitter("there");
    //  emitter(maxPages.toString());
    // emitter(pageNum.toString());

    if (pageNum >= maxPages) {
      emitter("cannot paginate");
      return;
    } else {
      //  emitter("PAGINTATING");
      if (VideoWareHome.instance.paginating.value) {
        return;
      }
      // emitter((pageNum + 1) as String);
      await VideoWareHome.instance
          .getVideoPostFromApi(pageNum + 1, true)
          .whenComplete(() => emitter("paginated"));
    }
  }
}

class VideoView2 extends StatefulWidget {
  String thumbLink;
  final String page;
  int index;
  bool isHome;
  int postId;
  final FeedPost data;

  VideoView2(
      {super.key,
      required this.thumbLink,
      required this.index,
      required this.page,
      required this.postId,
      required this.isHome,
      required this.data});

  @override
  State<VideoView2> createState() => _VideoView2State();
}

class _VideoView2State extends State<VideoView2> {
  ApiVideoPlayerController? _controller;
  String apiToken = "";

  @override
  void initState() {
    super.initState();
    buildVideoOptions();
  }

  void buildVideoOptions() {
    final token = apiToken.isEmpty ? null : apiToken;

    final videoOptions = VideoOptions(
        videoId: widget.data.vod!.first!, type: VideoType.vod, token: token);

    if (_controller == null) {
      _controller = ApiVideoPlayerController(
          videoOptions: videoOptions, autoplay: false, onEnd: () {});
    } else {
      _controller?.setVideoOptions(videoOptions);
    }
  }

  Future<void> innit() async {}

  @override
  void dispose() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (VideoWare.instance.videoController
    //           .where((item) => item.id == widget.postId)
    //           .first
    //           .chewie !=
    //       null) {
    //     VideoWare.instance.videoController
    //         .where((item) => item.id == widget.postId)
    //         .first
    //         .chewie!
    //         .pause();
    //     VideoWare.instance.videoController
    //         .where((item) => item.id == widget.postId)
    //         .first
    //         .controller!
    //         .value
    //         .pause();
    //   }
    // });
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   VideoWareHome.instance.loadVideo(false);
    // });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   //  if (widget.index == 0) return;
    //   VideoWare.instance.disposeVideo(widget.data.id!,
    //       "$muxStreamBaseUrl/${widget.data.mux!.first}.$videoExtension");
    //   // VideoWare.instance.disposeAllVideoV2(widget.data.id!,
    //   //     "$muxStreamBaseUrl/${widget.data.mux!.first}.$videoExtension");
    // });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              VodView(
                data: widget.data,
                index: widget.index,
                vod: widget.data.vod!.first!,
                controller: _controller,
              )
              // ObxValue<Rx<VideoPlayerController>>((val) {
              //   if (val.value.value.isInitialized) {
              //     if (widget.isHome) {
              //       if (mounted) {
              //         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //           if (PersistentNavController.instance.hide.value ==
              //               false) {
              //             val.value.play();
              //           } else {
              //             if (widget.index == 0) {
              //               emitter("yes lets play the video");
              //               val.value.play();
              //             } else {
              //               //   val.value.pause();
              //             }
              //           }
              //         });
              //       }
              //     } else {
              //       // val.value.pause();
              //     }

              //     if (mounted) {
              //       if (widget.index == 0) {
              //         emitter("yes lets play the video");
              //         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //           val.value.play();
              //         });
              //       } else {
              //         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //           //val.value.pause();
              //         });
              //       }
              //     }

              //     // emitter("yes index is ${widget.index}");
              //     if (mounted) {
              //       //  emitter("initialized 0000");
              //       WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //         if (val.value.value.isInitialized) {
              //           VideoWare.instance.addListeners(widget.postId);
              //         }
              //       });
              //     }
              //   } else {
              //     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //       if (mounted) {
              //         setState(() {});
              //       }
              //       Future.delayed(Duration(milliseconds: 500), () {
              //         if (mounted) {
              //           setState(() {});
              //         }
              //       });
              //       Future.delayed(Duration(seconds: 1), () {
              //         if (mounted) {
              //           setState(() {});
              //         }
              //       });
              //       Future.delayed(Duration(seconds: 2), () {
              //         if (mounted) {
              //           setState(() {});
              //         }
              //       });
              //     });
              //   }

              //   return val.value.value.isInitialized == false
              //       ? Stack(
              //           children: [
              //             Container(
              //               width: Get.width,
              //               height: Get.height,
              //               decoration: BoxDecoration(
              //                   color: Colors.black,
              //                   image: DecorationImage(
              //                     image: CachedNetworkImageProvider(
              //                         widget.thumbLink.toString()),
              //                     fit: BoxFit.cover,
              //                   )),
              //             ),
              //             Align(
              //               alignment: Alignment.center,
              //               child: ObxValue((load) {
              //                 return load.value
              //                     ? CircleAvatar(
              //                         backgroundColor:
              //                             Colors.white.withOpacity(.7),
              //                         radius: 30,
              //                         child: Center(
              //                           child: Loader(
              //                               color: HexColor(primaryColor)),
              //                         ),
              //                       )
              //                     : Visibility(
              //                         visible: load.value ? false : true,
              //                         child: CircleAvatar(
              //                           backgroundColor:
              //                               Colors.white.withOpacity(.7),
              //                           radius: 30,
              //                           child: const Icon(
              //                             Icons.play_arrow_outlined,
              //                             size: 25,
              //                             color: Colors.black,
              //                           ),
              //                         ),
              //                       );
              //               }, VideoWare.instance.isLoadVideo),
              //             ),
              //           ],
              //         )
              //       : Stack(
              //           alignment: Alignment.center,
              //           children: [
              //             AspectRatio(
              //               aspectRatio: val.value.value.aspectRatio,
              //               // Use the VideoPlayer widget to display the video.
              //               child: ObxValue((cheiwe) {
              //                 return cheiwe
              //                             .where(
              //                                 (p0) => p0.id == widget.data.id)
              //                             .first
              //                             .chewie ==
              //                         null
              //                     ? Stack(
              //                         children: [
              //                           Container(
              //                             width: Get.width,
              //                             height: Get.height,
              //                             decoration: BoxDecoration(
              //                                 color: Colors.black,
              //                                 image: DecorationImage(
              //                                   image:
              //                                       CachedNetworkImageProvider(
              //                                           widget.thumbLink
              //                                               .toString()),
              //                                   fit: BoxFit.cover,
              //                                 )),
              //                           ),
              //                         ],
              //                       )
              //                     : Chewie(
              //                         controller: cheiwe
              //                             .where(
              //                                 (p0) => p0.id == widget.data.id)
              //                             .first
              //                             .chewie!);
              //               }, VideoWare.instance.videoController),
              //             ),

              //             Align(
              //               alignment: Alignment.bottomCenter,
              //               child: VideoProgressIndicator(
              //                 val.value,
              //                 allowScrubbing: true,
              //                 colors: VideoProgressColors(
              //                     playedColor: HexColor(backgroundColor)
              //                         .withOpacity(.9)),
              //               ),
              //             ),

              //           ],
              //         );
              // },
              //     VideoWare.instance.videoController
              //         .where((p0) => p0.id == widget.data.id)
              //         .first
              //         .controller!),
            ],
          ),
        ),
        widget.isHome
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.only(top: 30, left: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () => PageRouting.popToPage(context),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),
                ),
              ),
        widget.isHome
            ? SizedBox.shrink()
            : FadeInRight(
                duration: Duration(seconds: 1),
                animate: true,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: LikeSection(
                    page: widget.page,
                    data: widget.data,
                  ),
                ),
              ),
        widget.isHome
            ? SizedBox.shrink()
            : Align(
                alignment: Alignment.bottomLeft,
                child: VideoUser(
                  page: widget.page,
                  data: widget.data,
                  isHome: true,
                  media: [],
                  controller: _controller,
                  isVideo: true,
                ),
              ),
      ],
    );
  }
}
