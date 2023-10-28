import 'dart:developer';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:animate_do/animate_do.dart';
import 'package:apivideo_player/apivideo_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:macanacki/presentation/uiproviders/screen/tab_provider.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';

import '../../../../model/feed_post_model.dart';
import '../../../../services/controllers/action_controller.dart';
import '../../../../services/controllers/url_launch_controller.dart';
import '../../../../services/middleware/action_ware.dart';
import '../../../../services/middleware/post_security.dart';
import '../../../../services/middleware/user_profile_ware.dart';
import '../../../../services/middleware/video/video_ware.dart';
import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../constants/string.dart';
import '../../../widgets/ads_display.dart';
import '../../../widgets/debug_emitter.dart';
import '../../../widgets/feed_views/like_section.dart';
import '../../../widgets/feed_views/new_action_design.dart';
import '../../../widgets/text.dart';
import '../../userprofile/testing_profile.dart';
import '../../userprofile/user_profile_screen.dart';
import '../test_api_video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';

import 'audio_common/common.dart';

class FeedAudioHolderUser extends StatefulWidget {
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
  bool showComment;
  bool extended;

  FeedAudioHolderUser(
      {super.key,
      required this.file,
      required this.vod,
      required this.showComment,
      //  required this.controller,
      required this.isHome,
      required this.shouldPlay,
      required this.thumbLink,
      required this.page,
      required this.isInView,
      required this.postId,
      required this.extended,
      required this.data});

  @override
  State<FeedAudioHolderUser> createState() => _FeedAudioHolderUserState();
}

class _FeedAudioHolderUserState extends State<FeedAudioHolderUser>
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
      VideoWareHome.instance.getAudioPostFromApi(1);
    });

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

    super.dispose();
  }

  bool flag = false;
  PageController pageController =
      PageController(initialPage: 0, keepPage: false);
  PageController pageController2 =
      PageController(initialPage: 0, keepPage: false);
  List<FeedPost> nextRandomVideo = VideoWare.instance.feedPostsAudio;
  int added = 0;

  @override
  Widget build(BuildContext context) {
    ActionWare action = Provider.of<ActionWare>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: ObxValue((allVideos) {
        List<dynamic> allThumbs = [];
        //  final List<FeedPost> nextRandomVideo = allVideos;
        //  nextRandomVideo.shuffle();
        //  final List<FeedPost> shuffledVideo = nextRandomVideo;

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

            return FutureBuilder<Object>(
                future: null,
                builder: (context, snapshot) {
                  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  //   if (added == 0) {
                  //     if (mounted) {
                  //       nextRandomVideo.shuffle();
                  //       setState(() {
                  //         //  nextRandomVideo.insert(0, post);
                  //         added = 1;
                  //       });
                  //     }
                  //   }
                  // });

                  final List newList = [post, ...nextRandomVideo].distinct();
                  return Container(
                    height: Get.height,
                    child: PageView.builder(
                        controller: pageController2,
                        itemCount: newList.length,
                        physics: NeverScrollableScrollPhysics(),
                        //    pageSnapping: true,
                        // allowImplicitScrolling: false,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          FeedPost post = newList[index];
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
                                  await Future.delayed(
                                      const Duration(seconds: 2));

                                  setState(() {
                                    flag = false;
                                  });

                                  return;
                                }
                                setState(() {
                                  flag = true;
                                });

                                await likeAction(context, true, post.id!);

                                await Future.delayed(
                                    const Duration(seconds: 2));

                                setState(() {
                                  flag = false;
                                });
                              }
                            },
                            child: Stack(
                              children: [
                                AudioView(
                                  allThumb: allThumbs,
                                  thumbLink: post.thumbnails!.first,
                                  page: widget.page,
                                  postId: post.id!,
                                  index: index,
                                  data: post,
                                  allVideos: allVideos,
                                  pageController: pageController2,
                                  isHome: widget.isHome,
                                  showComment: widget.showComment,
                                  next: () {
                                    //   pageController2.\
                                    if (index < newList.length) {
                                      pageController2.animateToPage(index + 1,
                                          duration: Duration(seconds: 1),
                                          curve: Curves.bounceOut);
                                    }
                                  },
                                  previous: () {
                                    if (index > 0) {
                                      pageController2.animateToPage(index - 1,
                                          duration: Duration(seconds: 1),
                                          curve: Curves.bounceOut);
                                    }
                                  },
                                ),
                                post.promoted == "yes"
                                    ? Positioned(
                                        bottom: 140,
                                        left: 0,
                                        child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                            duration:
                                                const Duration(seconds: 3),
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
                  );
                });
          }),
          onPageChanged: (index) {
            setState(() {
              added = 0;
            });
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
      }, VideoWare.instance.feedPostsAudio),
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
        .instance.feedAudioData.value.currentPage!; // api current  page num
    int maxPages = VideoWareHome
        .instance.feedAudioData.value.lastPage!; // api last page num
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
          .getAudioPostFromApi(pageNum + 1, true)
          .whenComplete(() => emitter("paginated"));
    }
  }
}

class AudioView extends StatefulWidget {
  String thumbLink;
  final String page;
  int index;
  bool isHome;
  int postId;
  final FeedPost data;
  final List? allThumb;
  List<FeedPost> allVideos;
  PageController pageController;
  VoidCallback previous;
  VoidCallback next;
  bool showComment;

  // VideoModel? video;

  AudioView({
    super.key,
    required this.allThumb,
    // required this.video,
    required this.thumbLink,
    required this.index,
    required this.page,
    required this.postId,
    required this.isHome,
    required this.allVideos,
    required this.pageController,
    required this.next,
    required this.previous,
    required this.data,
    required this.showComment,
  });

  @override
  State<AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<AudioView> {
  final _player = AudioPlayer();
  List<FeedPost> newVideos = [];

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await _player.setAudioSource(LockCachingAudioSource(
        Uri.parse(widget.data.media!.first.toString()),
      ));

      _player.play();
      setState(() {});
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    //  ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      CombineLatestStream.combine3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  Widget build(BuildContext context) {
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    return Stack(
      children: [
        Container(
          color: Colors.black,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => PageRouting.popToPage(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                    AppText(
                      text: "Now Playing",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      size: 16,
                    ),
                    SizedBox(
                      width: 50,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 300,
                        width: Get.width * 0.6,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  widget.data.thumbnails!.first!),
                              fit: BoxFit.cover,
                            )),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      AppText(
                        text: widget.data.description ?? "",
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        size: 16,
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      TextButton(
                        onPressed: () async {
                          if (widget.isHome == false) {
                            return;
                          }
                          _player.pause();
                          if (widget.data.user!.username! ==
                              user.userProfileModel.username) {
                            // action.pageController!.animateToPage(
                            //   4,
                            //   duration: const Duration(milliseconds: 1),
                            //   curve: Curves.easeIn,
                            // );
                          } else {
                            if (widget.isHome == false) {
                              return;
                            }
                            // try {
                            //   WidgetsBinding.instance
                            //       .addPostFrameCallback((timeStamp) {
                            //     VideoWareHome.instance.pauseAnyVideo();
                            //   });
                            // } catch (e) {}
                            PageRouting.popToPage(context);

                            PageRouting.pushToPage(
                                context,
                                TestProfile(
                                    username: widget.data.user!.username!,
                                    extended: true,
                                    page: "audio"));
                          }
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                        child: AppText(
                          text: widget.data.user!.username ?? "",
                          color: Colors.grey,
                          fontWeight: FontWeight.w800,
                          size: 13,
                        ),
                      ),

                      StreamBuilder<PositionData>(
                        stream: _positionDataStream,
                        builder: (context, snapshot) {
                          final positionData = snapshot.data;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: Get.width * 0.7,
                                child: SeekBar(
                                  duration:
                                      positionData?.duration ?? Duration.zero,
                                  position:
                                      positionData?.position ?? Duration.zero,
                                  bufferedPosition:
                                      positionData?.bufferedPosition ??
                                          Duration.zero,
                                  onChangeEnd: _player.seek,
                                ),
                              ),
                              TimeLeft(
                                duration:
                                    positionData?.duration ?? Duration.zero,
                                position:
                                    positionData?.position ?? Duration.zero,
                              )
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ControlButtons(_player, widget.next, widget.previous),
                    ],
                  ),
                )
              ],
            ),
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
              isAudio: true,
              userName: widget.data.user!.username,
              isHome: widget.isHome,
              showComment: widget.showComment,
              mediaController: _player,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: VideoUser(
            page: widget.page,
            data: widget.data,
            isAudio: true,
            player: _player,
            isHome: false,
            media: [],
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
                            log(widget.data.button.toString());
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
                              if (widget.data.button == "Spotify") {
                                await UrlLaunchController.launchWebViewOrVC(
                                    Uri.parse(widget.data.btnLink!));
                              } else {
                                await UrlLaunchController.launchInWebViewOrVC(
                                    Uri.parse(widget.data.btnLink!));
                              }
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

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;
  VoidCallback previous;
  VoidCallback next;

  ControlButtons(this.player, this.next, this.previous, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: const Icon(
            Icons.arrow_left,
            color: Colors.grey,
          ),
          iconSize: 40,
          onPressed: previous,
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: Loader(
                  color: HexColor(primaryColor),
                ),
              );
            } else if (playing != true) {
              return Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: HexColor(primaryColor), shape: BoxShape.circle),
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    iconSize: 30.0,
                    onPressed: player.play,
                  ),
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: HexColor(primaryColor), shape: BoxShape.circle),
                child: IconButton(
                  icon: const Icon(
                    Icons.pause,
                    color: Colors.white,
                  ),
                  iconSize: 30.0,
                  onPressed: player.pause,
                ),
              );
            } else {
              return Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: HexColor(primaryColor), shape: BoxShape.circle),
                child: IconButton(
                  icon: const Icon(
                    Icons.replay,
                    color: Colors.white,
                  ),
                  iconSize: 30.0,
                  onPressed: () => player.seek(
                    Duration.zero,
                  ),
                ),
              );
            }
          },
        ),
        // Opens speed slider dialog
        IconButton(
          icon: const Icon(
            Icons.arrow_right,
            color: Colors.grey,
          ),
          iconSize: 40,
          onPressed: next,
        ),
      ],
    );
  }
}
