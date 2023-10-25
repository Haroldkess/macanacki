import 'dart:developer';

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
import '../../../../services/controllers/action_controller.dart';
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
import '../test_api_video.dart';

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
      PostSecurity.instance.toggleSecure(true);
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

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: ObxValue((allVideos) {
        List<dynamic> allThumbs = [];
        if (allVideos.isNotEmpty) {
          for (var i in allVideos) {
            allThumbs.add(i.thumbnails!.first);
          }
        }
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
                  VideoView(
                      allThumb: allThumbs,
                      thumbLink: post.thumbnails!.first,
                      page: widget.page,
                      postId: post.id!,
                      index: index,
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
  // VideoModel? video;

  VideoView(
      {super.key,
      required this.allThumb,
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
  ApiVideoPlayerController? _controller;
  String apiToken = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      VideoWareHome.instance.viewToggle(0);
    });
    buildVideoOptions();
  }

  void buildVideoOptions() {
    final token = apiToken.isEmpty ? null : apiToken;

    final videoOptions = VideoOptions(
        videoId: widget.data.vod!.first!, type: VideoType.vod, token: token);

    if (_controller == null) {
      _controller = ApiVideoPlayerController(
          videoOptions: videoOptions,
          autoplay: false,
          onEnd: () {},
          onReady: () {
            log("READY!!!");
          });
    } else {
      _controller?.setVideoOptions(videoOptions);
    }
  }

  Future<void> innit() async {}

  @override
  void dispose() {
    super.dispose();
  }

  Rx<VideoPlayerController>? vid;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: widget.allThumb == null
              ? []
              : List.generate(
                  widget.allThumb == null ? 0 : widget.allThumb!.length,
                  (index) => Container(
                    height: 1,
                    child: CachedNetworkImage(
                        imageUrl: widget.allThumb![index] ?? ""),
                  ),
                ),
        ),
        Center(
          child: Stack(
            children: [
              VodView(
                data: widget.data,
                index: widget.index,
                vod: widget.data.vod!.first!,
                controller: _controller,
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
                  isHome: true,
                  controller: _controller,
                  isVideo: true,
                ),
              ),
      ],
    );
  }
}
