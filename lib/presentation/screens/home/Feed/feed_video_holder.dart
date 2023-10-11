import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/uiproviders/screen/tab_provider.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';

import '../../../../model/feed_post_model.dart';
import '../../../../services/controllers/action_controller.dart';
import '../../../../services/middleware/action_ware.dart';
import '../../../../services/middleware/video/video_ware.dart';
import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../constants/string.dart';
import '../../../widgets/ads_display.dart';
import '../../../widgets/debug_emitter.dart';
import '../../../widgets/feed_views/like_section.dart';
import '../../../widgets/feed_views/new_action_design.dart';

class FeedVideoHolder extends StatefulWidget {
  String file;
//  VideoPlayerController? controller;
  bool isHome;
  bool shouldPlay;
  String thumbLink;
  final String page;
  bool? isInView;
  int postId;
  final FeedPost data;

  FeedVideoHolder(
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
  State<FeedVideoHolder> createState() => _FeedVideoHolderState();
}

class _FeedVideoHolderState extends State<FeedVideoHolder>
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
      VideoWareHome.instance.loadVideo(true);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      VideoWareHome.instance.viewToggle(0);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VideoWareHome.instance.getVideoPostFromApi(1);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // VideoWareHome.instance.initSomeVideo(
      //     "$muxStreamBaseUrl/${widget.data.mux!.first}.$videoExtension",
      //     widget.postId,
      //     0);

      VideoWareHome.instance.disposeAllVideoV2(widget.data.id!,
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
            // FeedPost? post2 =
            //     index < (allVideos.length - 2) ? allVideos[index + 1] : null;

            return GestureDetector(
              onTap: () {
                if (index != 0) {
                  VideoWareHome.instance.loadVideo(true);

                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    VideoWareHome.instance.initSomeVideo(
                        "$muxStreamBaseUrl/${post.mux!.first}.$videoExtension",
                        post.id!,
                        index);
                  });
                }
              },
              onDoubleTap: () async {
                var lister = VideoWareHome.instance.videoController
                    .where((p0) => p0.id == post.id!)
                    .toList();

                if (lister.isNotEmpty) {
                  if (lister.first.controller!.value.value.isPlaying) {
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
                  }
                }
              },
              child: Stack(
                children: [
                  VideoView(
                      //   data2: post2,
                      thumbLink: post.thumbnails!.first,
                      page: widget.page,
                      postId: post.id!,
                      index: index,
                      // video: vid.videoController
                      //     .where((p0) => p0.id == post.id)
                      //     .first,
                      data: post,
                      isHome: false),
                  post.promoted == "yes"
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

            // GetBuilder<VideoWareHome>(
            //     init: VideoWareHome.instance.videoController
            //             .where((p0) => p0.id == post.id)
            //             .toList()
            //             .isEmpty
            //         ? VideoWareHome(
            //             "$muxStreamBaseUrl/${post.mux!.first}.$videoExtension",
            //             post.id!,
            //             true,
            //             index)
            //         : VideoWareHome.instance.videoController
            //                     .where((p0) => p0.id == post.id)
            //                     .first
            //                     .controller ==
            //                 null
            //             ? VideoWareHome(
            //                 "$muxStreamBaseUrl/${post.mux!.first}.$videoExtension",
            //                 post.id!,
            //                 true,
            //                 index)
            //             : null,
            //     initState: (initState) => VideoWareHome.instance.videoController
            //             .where((p0) => p0.id == post.id)
            //             .toList()
            //             .isEmpty
            //         ? WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            //             VideoWareHome.instance.initSomeVideo(
            //                 "$muxStreamBaseUrl/${post.mux!.first}.$videoExtension",
            //                 post.id!,
            //                 index);
            //           })
            //         : VideoWareHome.instance.videoController
            //                     .where((p0) => p0.id == post.id)
            //                     .first
            //                     .controller ==
            //                 null
            //             ? WidgetsBinding.instance
            //                 .addPostFrameCallback((timeStamp) {
            //                 VideoWareHome.instance.initSomeVideo(
            //                     "$muxStreamBaseUrl/${post.mux!.first}.$videoExtension",
            //                     post.id!,
            //                     index);
            //               })
            //             : VideoWareHome.instance.videoController
            //                     .where((p0) => p0.id == post.id)
            //                     .first
            //                     .controller!
            //                     .value
            //                     .value
            //                     .isInitialized
            //                 ? null
            //                 : WidgetsBinding.instance
            //                     .addPostFrameCallback((timeStamp) {
            //                     VideoWareHome.instance.initSomeVideo(
            //                         "$muxStreamBaseUrl/${post.mux!.first}.$videoExtension",
            //                         post.id!,
            //                         index);
            //                   }),
            //     builder: (vid) {
            //       return vid.videoController
            //               .where((p0) => p0.id == post.id)
            //               .toList()
            //               .isEmpty
            //           ? Center(child: Loader(color: HexColor(primaryColor)))
            //           : GestureDetector(
            //               onDoubleTap: () async {
            //                 var lister = VideoWareHome.instance.videoController
            //                     .where((p0) => p0.id == post.id!)
            //                     .toList();

            //                 if (lister.isNotEmpty) {
            //                   if (lister
            //                       .first.controller!.value.value.isPlaying) {
            //                     if (mounted) {
            //                       if (controller.value == 1) {
            //                         controller.reset();
            //                         controller.forward();
            //                       } else {
            //                         controller.forward();
            //                       }

            //                       if (action.likeIds.contains(post.id!)) {
            //                         setState(() {
            //                           flag = true;
            //                         });
            //                         await Future.delayed(
            //                             const Duration(seconds: 2));

            //                         setState(() {
            //                           flag = false;
            //                         });

            //                         return;
            //                       }
            //                       setState(() {
            //                         flag = true;
            //                       });

            //                       await likeAction(context, true, post.id!);

            //                       await Future.delayed(
            //                           const Duration(seconds: 2));

            //                       setState(() {
            //                         flag = false;
            //                       });
            //                     }
            //                   }
            //                 }
            //               },
            //               child: Stack(
            //                 children: [
            //                   VideoView(
            //                    //   data2: post2,
            //                       thumbLink: post.thumbnails!.first,
            //                       page: widget.page,
            //                       postId: post.id!,
            //                       index: index,
            //                       video: vid.videoController
            //                           .where((p0) => p0.id == post.id)
            //                           .first,
            //                       data: post,
            //                       isHome: false),
            //                   post.promoted == "yes"
            //                       ? Positioned(
            //                           bottom: 140,
            //                           left: 0,
            //                           child: Align(
            //                               alignment: Alignment.bottomLeft,
            //                               child: Column(
            //                                 crossAxisAlignment:
            //                                     CrossAxisAlignment.start,
            //                                 children: [
            //                                   // AdsDisplay(
            //                                   //   sponsored: false,
            //                                   //   color: HexColor('#00B074'),
            //                                   //   title: '\$10.000.00',
            //                                   // ),
            //                                   // SizedBox(
            //                                   //   height: 10,
            //                                   // ),
            //                                   AdsDisplay(
            //                                     sponsored: true,
            //                                     //  color: HexColor('#00B074'),
            //                                     color: Colors.grey.shade400,
            //                                     title: 'Sponsored Ad',
            //                                   ),
            //                                 ],
            //                               )),
            //                         )
            //                       : SizedBox.shrink(),
            //                   flag
            //                       ? Center(
            //                           child: Align(
            //                             alignment: Alignment.center,
            //                             child: AnimatedContainer(
            //                               duration: const Duration(seconds: 3),
            //                               curve: Curves.bounceInOut,
            //                               onEnd: () {
            //                                 setState(() {
            //                                   flag = false;
            //                                 });
            //                               },
            //                               child: Icon(
            //                                 Icons.favorite,
            //                                 size: Get.width * 0.4,
            //                                 color: animation.value,
            //                               ),
            //                             ),
            //                           ),
            //                         )
            //                       : const SizedBox.shrink(),
            //                 ],
            //               ),
            //             );

            //     });
          }),
          onPageChanged: (index) {
            if (index != 0) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                VideoWare.instance.loadVideo(false);
              });
            }
            if (mounted) {
              if (index > VideoWareHome.instance.feedPosts.length - 4) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  paginateFeed();
                });
              }
            }
          },
        );
      }, VideoWareHome.instance.feedPosts),
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

class VideoView extends StatefulWidget {
  String thumbLink;
  final String page;
  int index;
  bool isHome;
  int postId;
  final FeedPost data;
  // final FeedPost? data2;
  // VideoModel? video;

  VideoView(
      {super.key,
      //   required this.data2,
      // required this.video,
      required this.thumbLink,
      required this.index,
      required this.page,
      required this.postId,
      required this.isHome,
      required this.data});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      VideoWareHome.instance.viewToggle(0);
    });

    if (widget.index == 0) {
      VideoWareHome.instance.loadVideo(true);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        VideoWareHome.instance.loadVideo(true);
        VideoWareHome.instance.initSomeVideo(
            "$muxStreamBaseUrl/${widget.data.mux!.first}.$videoExtension",
            widget.data.id!,
            widget.index);
      });
    }
    // if (widget.data2 != null) {
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //     if (VideoWareHome.instance.videoController
    //             .where((item) => item.id == widget.data2!.id)
    //             .first
    //             .chewie !=
    //         null) {
    //       VideoWareHome.instance.videoController
    //           .where((item) => item.id == widget.data2!.id)
    //           .first
    //           .chewie!
    //           .pause();
    //       VideoWareHome.instance.videoController
    //           .where((item) => item.id == widget.data2!.id)
    //           .first
    //           .controller!
    //           .value
    //           .pause();
    //     }
    //   });
    // }

    final find = VideoWareHome.instance.videoController
        .where((item) => item.id == widget.postId)
        .toList();
    if (find.isNotEmpty) {
      if (find.first.controller!.value.value.isInitialized) {}
    } else {
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   VideoWareHome.instance.initSomeVideo(
      //       "$muxStreamBaseUrl/${widget.data.mux!.first}.$videoExtension",
      //       widget.data.id!,
      //       widget.index);
      // });
    }
  }

  Future<void> innit() async {}

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (VideoWareHome.instance.videoController
              .where((item) => item.id == widget.postId)
              .first
              .chewie !=
          null) {
        VideoWareHome.instance.videoController
            .where((item) => item.id == widget.postId)
            .first
            .chewie!
            .pause();
        VideoWareHome.instance.videoController
            .where((item) => item.id == widget.postId)
            .first
            .controller!
            .value
            .pause();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //  if (widget.index == 0) return;
      VideoWareHome.instance.disposeVideo(widget.data.id!,
          "$muxStreamBaseUrl/${widget.data.mux!.first}.$videoExtension");
      // VideoWareHome.instance.disposeAllVideoV2(widget.data.id!,
      //     "$muxStreamBaseUrl/${widget.data.mux!.first}.$videoExtension");

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //  if (widget.index == 0) return;
        //  if (widget.data2 != null) {
        // VideoWareHome.instance.disposeAllVideo(widget.data2!.id!,
        //     "$muxStreamBaseUrl/${widget.data2!.mux!.first}.$videoExtension");
        //}
      });
    });

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
              ObxValue<Rx<VideoPlayerController>>((val) {
                if (val.value.value.isInitialized) {
                  if (widget.isHome) {
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        if (PersistentNavController.instance.hide.value ==
                            false) {
                          val.value.play();
                        } else {
                          if (widget.index == 0) {
                            emitter("yes lets play the video");
                            val.value.play();
                          } else {
                            //  val.value.pause();
                          }
                        }
                      });
                    }
                  } else {
                    // val.value.pause();
                  }

                  if (mounted) {
                    if (widget.index == 0) {
                      emitter("yes lets play the video");
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        val.value.play();
                      });
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        //val.value.pause();
                      });
                    }
                  }

                  // emitter("yes index is ${widget.index}");
                  if (mounted) {
                    //  emitter("initialized 0000");
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (val.value.value.isInitialized) {
                        VideoWareHome.instance.addListeners(widget.postId);
                      }
                    });
                  }
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    if (mounted) {
                      setState(() {});
                    }
                    Future.delayed(Duration(milliseconds: 500), () {
                      if (mounted) {
                        setState(() {});
                      }
                    });
                    Future.delayed(Duration(seconds: 1), () {
                      if (mounted) {
                        setState(() {});
                      }
                    });
                    Future.delayed(Duration(seconds: 2), () {
                      if (mounted) {
                        setState(() {});
                      }
                    });
                  });
                }

                return val.value.value.isInitialized == false
                    ? Stack(
                        children: [
                          Container(
                            width: Get.width,
                            height: Get.height,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      widget.thumbLink.toString()),
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ObxValue((load) {
                              return load.value
                                  ? CircleAvatar(
                                      backgroundColor:
                                          Colors.white.withOpacity(.7),
                                      radius: 30,
                                      child: Center(
                                        child: Loader(
                                            color: HexColor(primaryColor)),
                                      ),
                                    )
                                  : Visibility(
                                      visible: load.value ? false : true,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            Colors.white.withOpacity(.7),
                                        radius: 30,
                                        child: const Icon(
                                          Icons.play_arrow_outlined,
                                          size: 25,
                                          color: Colors.black,
                                        ),
                                      ),
                                    );
                            }, VideoWareHome.instance.isLoadVideo),
                          ),
                        ],
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: val.value.value.aspectRatio,
                            // Use the VideoPlayer widget to display the video.
                            child:

                                //  widget.isHome
                                //     ? Stack(
                                //         alignment: Alignment.center,
                                //         children: [
                                //           VideoPlayer(val.value),
                                //           val.value.value.isPlaying
                                //               ? SizedBox.shrink()
                                //               : CircleAvatar(
                                //                   backgroundColor:
                                //                       Colors.white.withOpacity(.7),
                                //                   radius: 30,
                                //                   child: const Icon(
                                //                     Icons.play_arrow_outlined,
                                //                     size: 25,
                                //                     color: Colors.black,
                                //                   ),
                                //                 )
                                //         ],
                                //       )
                                //     :

                                ObxValue((cheiwe) {
                              return cheiwe
                                          .where(
                                              (p0) => p0.id == widget.data.id)
                                          .first
                                          .chewie ==
                                      null
                                  ? Container(
                                      width: Get.width,
                                      height: Get.height,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                widget.thumbLink.toString()),
                                            fit: BoxFit.cover,
                                          )),
                                    )
                                  : Chewie(
                                      controller: cheiwe
                                          .where(
                                              (p0) => p0.id == widget.data.id)
                                          .first
                                          .chewie!);
                            }, VideoWareHome.instance.videoController),
                          ),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: ObxValue((load) {
                          //     return load.value
                          //         ? CircleAvatar(
                          //             backgroundColor:
                          //                 Colors.white.withOpacity(.7),
                          //             radius: 30,
                          //             child: Center(
                          //               child: Loader(
                          //                   color: HexColor(primaryColor)),
                          //             ),
                          //           )
                          //         : Visibility(
                          //             visible: load.value ? false : true,
                          //             child: CircleAvatar(
                          //               backgroundColor:
                          //                   Colors.white.withOpacity(.7),
                          //               radius: 30,
                          //               child: const Icon(
                          //                 Icons.play_arrow_outlined,
                          //                 size: 25,
                          //                 color: Colors.black,
                          //               ),
                          //             ),
                          //           );
                          //   }, VideoWareHome.instance.isLoadVideo),
                          // ),
                        ],
                      );
              },
                  VideoWareHome.instance.videoController
                      .where((p0) => p0.id == widget.postId)
                      .first
                      .controller!),
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
                  media: [],
                ),
              ),
      ],
    );

    //  GetBuilder<VideoWareHome>(
    //       init: widget.data2 == null
    //           ? null
    //           : widget.data2!.id == widget.data.id
    //               ? null
    //               : VideoWareHome(
    //                   "$muxStreamBaseUrl/${widget.data2!.mux!.first}.$videoExtension",
    //                   widget.data2!.id!,
    //                   true,
    //                   widget.index + 1),
    //       initState: (initState) => widget.data2 == null
    //           ? null
    //           : widget.data2!.id == widget.data.id
    //               ? null
    //               : WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //                   VideoWareHome.instance.initSomeVideo(
    //                       "$muxStreamBaseUrl/${widget.data2!.mux!.first}.$videoExtension",
    //                       widget.data2!.id!,
    //                       widget.index + 1);
    //                 }),
    //       builder: (change) {
    //         return Stack(
    //           children: [
    //             Center(
    //               child: Stack(
    //                 alignment: Alignment.center,
    //                 children: [
    //                   ObxValue<Rx<VideoPlayerController>>((val) {
    //                     if (val.value.value.isInitialized) {
    //                       if (widget.isHome) {
    //                         if (mounted) {
    //                           WidgetsBinding.instance
    //                               .addPostFrameCallback((timeStamp) {
    //                             if (PersistentNavController.instance.hide.value ==
    //                                 false) {
    //                               val.value.play();
    //                             } else {
    //                               val.value.pause();
    //                             }
    //                           });
    //                         }
    //                       } else {
    //                         // val.value.pause();
    //                       }

    //                       if (mounted) {
    //                         //  emitter("initialized 0000");
    //                         WidgetsBinding.instance
    //                             .addPostFrameCallback((timeStamp) {
    //                           if (val.value.value.isInitialized) {
    //                             VideoWareHome.instance
    //                                 .addListeners(widget.postId);
    //                           }
    //                         });
    //                       }
    //                     } else {
    //                       WidgetsBinding.instance
    //                           .addPostFrameCallback((timeStamp) {
    //                         if (mounted) {
    //                           setState(() {});
    //                         }
    //                         Future.delayed(Duration(milliseconds: 500), () {
    //                           if (mounted) {
    //                             setState(() {});
    //                           }
    //                         });
    //                         Future.delayed(Duration(seconds: 1), () {
    //                           if (mounted) {
    //                             setState(() {});
    //                           }
    //                         });
    //                         Future.delayed(Duration(seconds: 2), () {
    //                           if (mounted) {
    //                             setState(() {});
    //                           }
    //                         });
    //                       });
    //                     }

    //                     return val.value.value.isInitialized == false
    //                         ? Container(
    //                             width: Get.width,
    //                             height: Get.height,
    //                             decoration: BoxDecoration(
    //                                 color: Colors.black,
    //                                 image: DecorationImage(
    //                                   image: CachedNetworkImageProvider(
    //                                       widget.thumbLink.toString()),
    //                                   fit: BoxFit.cover,
    //                                 )),
    //                           )
    //                         : Stack(
    //                             alignment: Alignment.center,
    //                             children: [
    //                               AspectRatio(
    //                                 aspectRatio: val.value.value.aspectRatio,
    //                                 // Use the VideoPlayer widget to display the video.
    //                                 child: widget.isHome
    //                                     ? Stack(
    //                                         alignment: Alignment.center,
    //                                         children: [
    //                                           VideoPlayer(val.value),
    //                                           val.value.value.isPlaying
    //                                               ? SizedBox.shrink()
    //                                               : CircleAvatar(
    //                                                   backgroundColor: Colors
    //                                                       .white
    //                                                       .withOpacity(.7),
    //                                                   radius: 30,
    //                                                   child: const Icon(
    //                                                     Icons.play_arrow_outlined,
    //                                                     size: 25,
    //                                                     color: Colors.black,
    //                                                   ),
    //                                                 )
    //                                         ],
    //                                       )
    //                                     : ObxValue((cheiwe) {
    //                                         return Chewie(
    //                                             controller: cheiwe
    //                                                 .where((p0) =>
    //                                                     p0.id == widget.data.id)
    //                                                 .first
    //                                                 .chewie!);
    //                                       },
    //                                         VideoWareHome
    //                                             .instance.videoController),
    //                               ),

    //                               widget.isHome
    //                                   ? SizedBox.shrink()
    //                                   : Align(
    //                                       alignment: Alignment.bottomCenter,
    //                                       child: Align(
    //                                         alignment: Alignment.bottomCenter,
    //                                         child: VideoProgressIndicator(
    //                                           val.value,
    //                                           allowScrubbing: true,
    //                                           colors: VideoProgressColors(
    //                                               playedColor:
    //                                                   HexColor(primaryColor)
    //                                                       .withOpacity(.6)),
    //                                         ),
    //                                       ),
    //                                     )
    //                             ],
    //                           );
    //                   },
    //                       VideoWareHome.instance.videoController
    //                           .where((p0) => p0.id == widget.postId)
    //                           .first
    //                           .controller!),
    //                 ],
    //               ),
    //             ),
    //             widget.isHome
    //                 ? SizedBox.shrink()
    //                 : Padding(
    //                     padding: const EdgeInsets.only(top: 30, left: 5),
    //                     child: Align(
    //                       alignment: Alignment.topLeft,
    //                       child: IconButton(
    //                           onPressed: () => PageRouting.popToPage(context),
    //                           icon: const Icon(
    //                             Icons.arrow_back_ios,
    //                             color: Colors.white,
    //                           )),
    //                     ),
    //                   ),
    //             widget.isHome
    //                 ? SizedBox.shrink()
    //                 : FadeInRight(
    //                     duration: Duration(seconds: 1),
    //                     animate: true,
    //                     child: Align(
    //                       alignment: Alignment.centerRight,
    //                       child: LikeSection(
    //                         page: widget.page,
    //                         data: widget.data,
    //                       ),
    //                     ),
    //                   ),
    //             widget.isHome
    //                 ? SizedBox.shrink()
    //                 : Align(
    //                   alignment: Alignment.bottomLeft,
    //                   child: VideoUser(
    //                     page: widget.page,
    //                     data: widget.data,
    //                     media: [],
    //                   ),
    //                 ),
    //           ],
    //         );

    //       });
  }
}
