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
import '../../../../services/controllers/url_launch_controller.dart';
import '../../../../services/controllers/view_controller.dart';
import '../../../../services/middleware/action_ware.dart';
import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../constants/string.dart';
import '../../../uiproviders/screen/tab_provider.dart';
import '../../../widgets/ads_display.dart';
import '../../../widgets/debug_emitter.dart';
import '../../../widgets/feed_views/like_section.dart';
import '../../../widgets/loader.dart';
import '../../../widgets/text.dart';

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
  bool showComment;
  bool? extended;

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
      required this.data,
      required this.extended,
      required this.showComment});

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
    super.dispose();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.page == "user") {
        if (PersistentNavController.instance.hide.value == true) {
          PersistentNavController.instance.toggleHide();
        }
      } else {
        if (widget.extended == false) {
          if (PersistentNavController.instance.hide.value == true) {
            PersistentNavController.instance.toggleHide();
          }
        }
      }
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
        log(allVideos.length.toString() + "just checkinh");
        return PageView.builder(
          itemCount: allVideos.length,
          controller: pageController,
          //  preloadPagesCount: 0,
          scrollDirection: Axis.vertical,
          itemBuilder: ((context, index) {
            FeedPost post = allVideos[index];
            return GestureDetector(
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
                  Platform.isAndroid
                      ? VideoView2(
                          thumbLink: post.thumbnails!.first ?? "",
                          page: widget.page,
                          postId: post.id!,
                          index: index,
                          data: post,
                          isHome: widget.isHome,
                          showComment: widget.showComment,
                        )
                      : VideoView2Ios(
                          thumbLink: post.thumbnails!.first ?? "",
                          page: widget.page,
                          postId: post.id!,
                          index: index,
                          data: post,
                          isHome: widget.isHome,
                          showComment: widget.showComment,
                        ),
                  widget.data.promoted == "yes"
                      ? Positioned(
                          bottom: 140,
                          left: 0,
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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

    // int checkNum = provide.feedPosts.length - 3; // lenght of posts
    int pageNum = VideoWareHome
        .instance.feedData.value.currentPage!; // api current  page num
    int maxPages =
        VideoWareHome.instance.feedData.value.lastPage!; // api last page num

    if (pageNum >= maxPages) {
      emitter("cannot paginate");
      return;
    } else {
      //  emitter("PAGINTATING");
      if (VideoWareHome.instance.paginating.value) {
        return;
      }

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
  bool showComment;

  VideoView2(
      {super.key,
      required this.thumbLink,
      required this.index,
      required this.page,
      required this.postId,
      required this.isHome,
      required this.showComment,
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
    final videoOptions = VideoOptions(
        videoId: widget.data.vod!.first!, type: VideoType.vod, token: null);

    _controller = ApiVideoPlayerController(
        videoOptions: videoOptions,
        autoplay: false,
        onEnd: () {
          ViewController.handleView(widget.data.id!);
        },
        onReady: () {
          log("READY!!!");
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            alignment: Alignment.center,
            children: [
              PlayerWidget(
                data: widget.data,
                index: widget.index,
                //vod: widget.data.vod!.first!,
                controller: _controller!,
                applyStyle: applyStyle,
              )
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
                    userName: widget.data.user!.username,
                    isHome: widget.isHome,
                    showComment: widget.showComment,
                    mediaController: _controller,
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

class VideoView2Ios extends StatefulWidget {
  String thumbLink;
  final String page;
  int index;
  bool isHome;
  int postId;
  final FeedPost data;
  bool showComment;

  VideoView2Ios(
      {super.key,
      required this.thumbLink,
      required this.index,
      required this.page,
      required this.postId,
      required this.isHome,
      required this.showComment,
      required this.data});

  @override
  State<VideoView2Ios> createState() => _VideoView2IosState();
}

class _VideoView2IosState extends State<VideoView2Ios> {
  VideoPlayerController? _controller;
  String apiToken = "";

  @override
  void initState() {
    super.initState();
    buildVideoOptions();
  }

  void buildVideoOptions() {
    final videoOptions = VideoOptions(
        videoId: widget.data.vod!.first!, type: VideoType.vod, token: null);

    _controller = VideoPlayerController.networkUrl(Uri.parse(
        "$muxStreamBaseUrl/${widget.data.mux!.first}.$videoExtension"));
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            alignment: Alignment.center,
            children: [
              PlayerWidgetIos(
                data: widget.data,
                index: widget.index,
                //vod: widget.data.vod!.first!,
                controller: _controller!,
                applyStyle: applyStyle,
              )
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
                    userName: widget.data.user!.username,
                    isHome: widget.isHome,
                    showComment: widget.showComment,
                    mediaController: _controller,
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
