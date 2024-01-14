import 'dart:developer';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:apivideo_player/apivideo_player.dart';
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
import '../../../../preload/preload_controller.dart';
import '../../../../services/controllers/action_controller.dart';
import '../../../../services/controllers/url_launch_controller.dart';
import '../../../../services/controllers/view_controller.dart';
import '../../../../services/middleware/action_ware.dart';
import '../../../../services/middleware/post_security.dart';
import '../../../../services/middleware/video/video_ware.dart';
import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../constants/string.dart';
import '../../../widgets/ads_display.dart';
import '../../../widgets/debug_emitter.dart';
import '../../../widgets/feed_views/like_section.dart';
import '../../../widgets/feed_views/new_action_design.dart';
import '../../../widgets/text.dart';
import '../test_api_video.dart';
import 'package:flutter/services.dart';

class VodClass {
  int? id;
  ApiVideoPlayerController? controller;
  VodClass({this.id, this.controller});
}

class FeedVideoHolder extends StatefulWidget {
  String file;
  String vod;
//  VideoPlayerController? controller;
  bool isHome;
  bool shouldPlay;
  String thumbLink;
  final String page;
  bool? isInView;
  int postId;
  final FeedPost data;
  bool? extended;

  FeedVideoHolder(
      {super.key,
      required this.file,
      required this.vod,
      //  required this.controller,
      required this.isHome,
      required this.shouldPlay,
      required this.thumbLink,
      required this.page,
      required this.isInView,
      required this.postId,
      required this.data,
      required this.extended});

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      PostSecurity.instance.toggleSecure(false);
    });
    controller = AnimationController(
      duration: const Duration(milliseconds: 500), //controll animation duration
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    animation = ColorTween(
      begin: Colors.transparent,
      end: secondaryColor.withOpacity(.8),
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
      //  removeAllVideoOption();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.extended == false) {
        if (PersistentNavController.instance.hide.value == true) {
          PersistentNavController.instance.toggleHide();
        }
      }
    });

    super.dispose();
  }

  String apiToken = "";

  bool flag = false;
  PageController pageController =
      PageController(initialPage: 0, keepPage: false);
  bool loadVod = true;
  List<VodClass> vodVid = [];

  Future<void> removeAllVideoOption() async {
    await Future.forEach(vodVid, (element) => element.controller!.dispose())
        .whenComplete(() {
      if (mounted) {
        setState(() {
          vodVid.clear();
          vodVid = [];
        });
      }
    });
  }

  Future<void> buildVideoOptions(vod, id, index) async {
    if (vod == null || id == null) {
    } else {
      final token = apiToken.isEmpty ? null : apiToken;

      List<VodClass> lister =
          vodVid.where((element) => element.id == id).toList();
      if (lister.isEmpty) {
        final videoOptions =
            VideoOptions(videoId: vod!, type: VideoType.vod, token: token);

        ApiVideoPlayerController controller = ApiVideoPlayerController(
            videoOptions: videoOptions,
            autoplay: false,
            onEnd: () {},
            onReady: () {
              log("READY!!! From List");
            });

        await controller.initialize();
        if (mounted) {
          setState(() {
            vodVid.add(VodClass(
                id: int.tryParse(id.toString()), controller: controller));
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ActionWare action = Provider.of<ActionWare>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: ObxValue((allVideos) {
        // List<dynamic> allThumbs = [];
        // if (allVideos.isNotEmpty) {
        //   for (var i in allVideos) {
        //     if (i.thumbnails!.isNotEmpty) {
        //       allThumbs.add(i.thumbnails!.first);
        //     }

        //     // if (i.vod!.first != null || i.vod != null) {
        //     //   buildVideoOptions(i.vod!.first, i.id);
        //     // }
        //   }
        // }
        return Stack(children: [
          // Column(
          //   children: allThumbs == null
          //       ? []
          //       : List.generate(
          //           allThumbs == null ? 0 : allThumbs.length,
          //           (index) => Container(
          //             height: 1,
          //             child:
          //                 CachedNetworkImage(imageUrl: allThumbs[index] ?? ""),
          //           ),
          //         ),
          // ),
          PageView.builder(
            itemCount: allVideos.length,
            controller: pageController,
            //  preloadPagesCount: 0,
            scrollDirection: Axis.vertical,
            itemBuilder: ((context, index) {
              FeedPost post = allVideos[index];
              // FeedPost? post2 =
              //     index + 1 < allVideos.length ? allVideos[index + 1] : null;
              // FeedPost? post3 =
              //     index + 2 < allVideos.length ? allVideos[index + 2] : null;

              // if (loadVod) {
              //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
              // }

              return GestureDetector(
                onDoubleTap: () async {
                  HapticFeedback.heavyImpact();
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
                    VideoView(
                      allThumb: [],
                      thumbLink: post.thumbnails!.isEmpty
                          ? ""
                          : post.thumbnails!.first,
                      page: widget.page,
                      postId: post.id!,
                      index: index,
                      vodList: vodVid,
                      data: post,
                      inComingController: null,
                      isHome: widget.isHome,
                    ),
                    // : VideoViewIos(
                    //     allThumb: allThumbs,
                    //     thumbLink: post.thumbnails!.first,
                    //     page: widget.page,
                    //     postId: post.id!,
                    //     index: index,
                    //     vodList: vodVid,
                    //     data: post,
                    //     inComingController: null,
                    //     isHome: widget.isHome,
                    //   ),
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
            }),
            onPageChanged: (index) {
              // if (index > (allVideos.length - 1) || index < 1) {
              // } else {
              //   if (index % 3 == 0) {
              //     removeAllVideoOption();
              //   } else {
              //     List<dynamic> sendToVod = [
              //       allVideos[index - 1].vod!.first +
              //           "|${allVideos[index - 1].id}",
              //       allVideos[index].vod!.first + "|${allVideos[index - 1].id}",
              //       allVideos[index + 1].vod!.first +
              //           "|${allVideos[index - 1].id}"
              //     ];

              //     for (var i in sendToVod) {
              //       if (i != null) {
              //         buildVideoOptions(i.toString().split("|").first,
              //             i.toString().split("|").last, index);
              //       }
              //     }
              //   }
              // }

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
          ),
        ]);
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
  final List? allThumb;
  List<VodClass> vodList;
  // VideoModel? video;
  ApiVideoPlayerController? inComingController;

  VideoView(
      {super.key,
      required this.allThumb,
      // required this.video,
      required this.thumbLink,
      required this.index,
      required this.page,
      required this.postId,
      required this.vodList,
      required this.inComingController,
      required this.isHome,
      required this.data});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  int? bufferDelay;
  ApiVideoPlayerController? _controller;
  String apiToken = "";

  final preloadController = PreloadController.to;

  @override
  void initState() {
    log("--------------------------------------xxx Inside FeedVideoHolder");
    //buildVideoOptions();
    initializePlayer();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (mounted) {
    //     for (var i in widget.vodList) {
    //       if (i.controller != null) {
    //         if (i.id != widget.data.id) {
    //           i.controller!.pause();
    //         }
    //       }
    //     }
    //   }
    // });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      VideoWareHome.instance.viewToggle(0);
    });
  }

  Future<void> initializePlayer() async {
    // log(" ffffffffffffffff ${widget.data.mux!.first}");
    // log(" ffffffffffffffff ${widget.data.vod!.first}");

    _videoPlayerController =
        preloadController.getPreloadById(widget.postId).controller!;
    // _videoPlayerController =
    //     VideoPlayerController.networkUrl(Uri.parse(widget.data.vod!.first));
    // await Future.wait([ _videoPlayerController.initialize()]);
    _createChewieController();
    setState(() {});
  }

  void disposePlayer() {
    if (_videoPlayerController != null) {
      _videoPlayerController.pause();
    }
    _chewieController?.dispose();
  }

  void _createChewieController() {
    _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        progressIndicatorDelay:
            bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
        showControls: true,
        allowMuting: false,
        materialProgressColors: ChewieProgressColors(
            backgroundColor: textPrimary, playedColor: secondaryColor),
        cupertinoProgressColors: ChewieProgressColors(
            backgroundColor: textPrimary, playedColor: secondaryColor)

        //controlsSafeAreaMinimum: EdgeInsets.only(bottom: 40),
        //autoInitialize: true,
        );
  }

  // void buildVideoOptions() async {
  //   // final token = apiToken.isEmpty ? null : apiToken;
  //
  //   final videoOptions = VideoOptions(
  //       videoId: widget.data.vod!.first!, type: VideoType.vod, token: null);
  //
  //   _controller = ApiVideoPlayerController(
  //       videoOptions: videoOptions,
  //       autoplay: false,
  //       onEnd: () {
  //         ViewController.handleView(widget.data.id!);
  //       },
  //       onReady: () {
  //         log("READY!!!");
  //       });
  //
  //   // _controller!.initialize();
  // }

  Future<void> innit() async {}

  @override
  void dispose() {
    disposePlayer();
    super.dispose();

    // if (_controller != null) {
    //   _controller!.dispose();
    // }
  }

  Rx<VideoPlayerController>? vid;
  @override
  Widget build(BuildContext context) {
    // log("-------------------------------------- Inside FeedVideoHolder");

    return Stack(
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _chewieController != null &&
                      _chewieController!
                          .videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController!,
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 10, left: 15),
            child: InkWell(
              onTap: () => PageRouting.popToPage(context),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 22,
              ),
            )

            //  Align(
            //   alignment: Alignment.topLeft,
            //   child: IconButton(
            //       onPressed: () => PageRouting.popToPage(context),
            //       icon: const Icon(
            //         Icons.arrow_back_ios,
            //         color: Colors.white,
            //       )),
            // ),
            ),
        Align(
          alignment: Alignment.bottomLeft,
          child: VideoUser(
            page: widget.page,
            data: widget.data,
            media: [],
            isHome: true,
            controller: _controller,
            isVideo: true,
            showFollow: true,
          ),
        ),
        FadeInRight(
          duration: Duration(seconds: 1),
          animate: true,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom:
                      widget.data.btnLink != null && widget.data.button != null
                          ? 100
                          : 80),
              child: LikeSection(
                page: widget.page,
                data: widget.data,
                userName: widget.data.user!.username,
                isHome: widget.isHome,
                showComment: true,
                mediaController: _controller,
              ),
            ),
          ),
        ),
        widget.data.btnLink != null && widget.data.button != null
            ? Positioned(
                bottom: .1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      SizedBox(
                        width: Get.width,
                        child: InkWell(
                          onTap: () async {
                            if (widget.data.button == "Call Now") {
                              await UrlLaunchController.makePhoneCall(
                                  widget.data.btnLink!);
                            }
                            if (widget.data.button == "Whatsapp") {
                              //   print(widget.data.btnLink!);

                              if (widget.data.btnLink!
                                  .contains("https://wa.me/https://")) {
                                var start = widget.data.btnLink!
                                    .split("https://wa.me/https://");

                                String newVal =
                                    "https://${start.last}".toString();
                                emitter(newVal);
                                await UrlLaunchController.launchWebViewOrVC(
                                    Uri.parse(newVal));
                              } else {
                                await UrlLaunchController.launchWebViewOrVC(
                                    Uri.parse(widget.data.btnLink!));
                              }
                            } else {
                              //  print(widget.data.btnLink);
                              await UrlLaunchController.launchInWebViewOrVC(
                                  Uri.parse(widget.data.btnLink!));
                            }
                          },
                          child: Container(
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.zero,
                                color: HexColor("#FFFFFF")),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    text: widget.data.button ?? "",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class VideoViewIos extends StatefulWidget {
  String thumbLink;
  final String page;
  int index;
  bool isHome;
  int postId;
  final FeedPost data;
  final List? allThumb;
  List<VodClass> vodList;
  // VideoModel? video;
  ApiVideoPlayerController? inComingController;

  VideoViewIos(
      {super.key,
      required this.allThumb,
      // required this.video,
      required this.thumbLink,
      required this.index,
      required this.page,
      required this.postId,
      required this.vodList,
      required this.inComingController,
      required this.isHome,
      required this.data});

  @override
  State<VideoViewIos> createState() => _VideoViewIosState();
}

class _VideoViewIosState extends State<VideoViewIos> {
  VideoPlayerController? _controller;
  String apiToken = "";
  @override
  void initState() {
    log("------------------------------------ BuildVideoOptions");
    buildVideoOptions();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (mounted) {
    //     for (var i in widget.vodList) {
    //       if (i.controller != null) {
    //         if (i.id != widget.data.id) {
    //           i.controller!.pause();
    //         }
    //       }
    //     }
    //   }
    // });

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      VideoWareHome.instance.viewToggle(0);
    });
  }

  void buildVideoOptions() async {
    _controller = VideoPlayerController.networkUrl(
        Uri.parse("${widget.data.vod!.first}"));

    // final token = apiToken.isEmpty ? null : apiToken;

    // _controller!.initialize();
  }

  Future<void> innit() async {}

  @override
  void dispose() {
    super.dispose();

    // if (_controller != null) {
    //   _controller!.dispose();
    // }
  }

  Rx<VideoPlayerController>? vid;
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.transparent);
    final buttonStyle = TextButton.styleFrom(
        iconColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        side: BorderSide.none,
        textStyle: textStyle);

    final settingsBarStyle = SettingsBarStyle(
        buttonStyle: buttonStyle,
        sliderTheme: SliderThemeData(
            activeTrackColor: Colors.transparent,
            thumbColor: Colors.transparent,
            overlayShape: SliderComponentShape.noThumb,
            thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 0.0, disabledThumbRadius: 0)));

    final controlsBarStyle = ControlsBarStyle(
        mainControlButtonStyle: buttonStyle,
        seekBackwardControlButtonStyle: null,
        seekForwardControlButtonStyle: null);

    final timeSliderStyle = TimeSliderStyle(
        sliderTheme: const SliderThemeData(
            //    overlayColor: Colors.white,

            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            disabledThumbColor: Color.fromARGB(0, 31, 25, 25),
            thumbColor: Colors.transparent,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 0.0,
            ),
            //   thumbSelector: ,
            valueIndicatorTextStyle: textStyle));

    PlayerStyle applyStyle = PlayerStyle(
        settingsBarStyle: settingsBarStyle,
        controlsBarStyle: controlsBarStyle,
        timeSliderStyle: timeSliderStyle);
    return Stack(
      children: [
        Center(
          child: Stack(
            children: [
              PlayerWidgetIos(
                data: widget.data,
                index: widget.index,
                //   vod: widget.data.vod!.first!,
                controller: _controller!,
                applyStyle: applyStyle,
              )
            ],
          ),
        ),
        Padding(
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
        FadeInRight(
          duration: Duration(seconds: 1),
          animate: true,
          child: Align(
            alignment: Alignment.centerRight,
            child: LikeSection(
              page: widget.page,
              data: widget.data,
              userName: widget.data.user!.username,
              isHome: true,
              showComment: true,
              mediaController: _controller,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: VideoUser(
            page: widget.page,
            data: widget.data,
            media: [],
            isHome: true,
            controller: _controller,
            isVideo: true,
          ),
        ),
        widget.data.btnLink != null && widget.data.button != null
            ? Positioned(
                bottom: .1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      SizedBox(
                        width: Get.width,
                        child: InkWell(
                          onTap: () async {
                            if (widget.data.button == "Call Now") {
                              await UrlLaunchController.makePhoneCall(
                                  widget.data.btnLink!);
                            }
                            if (widget.data.button == "Whatsapp") {
                              //   print(widget.data.btnLink!);

                              if (widget.data.btnLink!
                                  .contains("https://wa.me/https://")) {
                                var start = widget.data.btnLink!
                                    .split("https://wa.me/https://");

                                String newVal =
                                    "https://${start.last}".toString();
                                emitter(newVal);
                                await UrlLaunchController.launchWebViewOrVC(
                                    Uri.parse(newVal));
                              } else {
                                await UrlLaunchController.launchWebViewOrVC(
                                    Uri.parse(widget.data.btnLink!));
                              }
                            } else {
                              //  print(widget.data.btnLink);
                              await UrlLaunchController.launchInWebViewOrVC(
                                  Uri.parse(widget.data.btnLink!));
                            }
                          },
                          child: Container(
                            height: 35,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.zero,
                                color: HexColor("#FFFFFF")),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText(
                                    text: widget.data.button ?? "",
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
