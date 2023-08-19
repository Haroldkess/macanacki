import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/feed_views/follow_section.dart';
import 'package:macanacki/presentation/widgets/feed_views/like_section.dart';
import 'package:macanacki/presentation/widgets/feed_views/multiple_post.dart';
import 'package:macanacki/presentation/widgets/feed_views/single_posts.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/action_controller.dart';
import 'package:macanacki/services/controllers/view_controller.dart';
import 'package:macanacki/services/middleware/action_ware.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../model/feed_post_model.dart';
import '../../services/controllers/feed_post_controller.dart';
import '../../services/controllers/url_launch_controller.dart';
import '../../services/temps/temps_id.dart';
import '../constants/string.dart';
import '../uiproviders/screen/comment_provider.dart';
import '../uiproviders/screen/tab_provider.dart';
import 'feed_views/new_action_design.dart';
import 'feed_views/user_multiple_post.dart';
import 'option_modal.dart';

class UserTikTokView extends StatefulWidget {
  final List<String> media;
  final List<String> urls;
  final FeedPost data;
  int? index1;
  int? index2;
  String page;
  List<FeedPost>? feedPosts;
  final bool isHome;
  VideoPlayerController? controller;
  bool? isInView;
  dynamic pageData;
  UserTikTokView(
      {super.key,
      required this.media,
      required this.data,
      required this.page,
      this.index1,
      this.index2,
      this.controller,
      required this.isHome,
      this.feedPosts,
      required this.urls,
      required this.isInView,
      required this.pageData});

  @override
  State<UserTikTokView> createState() => _UserTikTokViewState();
}

class _UserTikTokViewState extends State<UserTikTokView>
    with TickerProviderStateMixin {
  VideoPlayerController? _controller;
  FeedPost? thisData;

  List<String> savedVid = [];
  bool flag = false;
  late AnimationController controller;
  late Animation animation;
  //  MUXClient muxClient = MUXClient();
  late SharedPreferences pref;
  String myUsername = "";
  bool show = false;
  List<Comment> talks = [];
  @override
  void initState() {
    super.initState();
    initPref();
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   // FeedPostWare post = Provider.of<FeedPostWare>(context, listen: false);

    //   FeedPostController.getSingleThumb(
    //       widget.urls, context, MediaQuery.of(context).size.height);
    //   // emitter('caching first ${data.length} sent');
    // });

//  muxClient.initializeDio();

    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   Operations.commentOperation(context, false, widget.data.comments!);
    // });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   await Future.forEach(widget.pageData.comments, (dynamic element) async {
    //     Comment comment = Comment(
    //         id: element.id,
    //         body: element.body,
    //         createdAt: element.createdAt,
    //         updatedAt: element.updatedAt,
    //         username: element.username,
    //         profilePhoto: element.profilePhoto,
    //         noOfLikes: element.noOfLikes,
    //         postId: element.postId);

    //     talks.add(comment);
    //   });

    //   setState(() {
    //     show = true;
    //   });
    // });

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

    if (widget.media.length < 2) {
      debugPrint("This is the url ${widget.data.media!.first}");
      if (widget.media == null || widget.media.isEmpty) return;
      if (!widget.media.first.contains("https")) {
        debugPrint(
            "This is the url ${"$muxStreamBaseUrl/${widget.media.first}.$videoExtension"}");
        _controller = VideoPlayerController.network(
            "$muxStreamBaseUrl/${widget.media.first}.$videoExtension"

            //   videoPlayerOptions: VideoPlayerOptions()
            );
        if (widget.data.controller == null) {
          thisData = widget.data.copyWith(
            controller: _controller,
          );
        } else {
          thisData = widget.data;
        }

        //  log(thisData.description!);
        // if (widget.isInView == true) {
        thisData!.controller!.initialize().whenComplete(() {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              TabProvider provide =
                  Provider.of<TabProvider>(context, listen: false);
              if (provide.index == 0) {
                if (widget.isInView == true) {
                  //   thisData.controller!.play();
                }

                //   provide.tap(false);
              } else {
                if (provide.index == 4 && provide.isHome) {
                  emitter("heyyyyy");
                  //  thisData.controller!.play();
                  //  provide.tap(false);
                } else {
                  //  _controller!.pause();
                }
              }
            }
          });

          setState(() {});
        }).then((value) => {
              thisData!.controller!.addListener(() {
                if (thisData!.controller!.value.position.inSeconds > 7 &&
                    thisData!.controller!.value.position.inSeconds < 10) {
                  ViewController.handleView(widget.data.id!);
                  //log("Watched more than 10 seconds");
                }
              })
            });
        thisData!.controller!.setLooping(true);

        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //   FeedPostController.loadBeforeHand(context, thisData!);
        // });

        // widget.data.copyWith(controller: _controller);

        //  }

        // Use the controller to loop the video.

      } else {
        Future.delayed(const Duration(seconds: 2))
            .whenComplete(() => ViewController.handleView(widget.data.id!));
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      StoreComment comment = Provider.of<StoreComment>(context, listen: false);
      List checkCom = comment.comments
          .where((element) => element.postId == widget.data.id)
          .toList();

      if (checkCom.isEmpty) {
        if (widget.data.comments!.isEmpty) {
          return;
        } else {
          Operations.commentOperation(context, false, widget.data.comments!);
        }
      } else {
        return;
      }
    });

    // setState(() {
    //   show = true;
    // });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   emitter("changed oooo");
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     TabProvider tabs = Provider.of<TabProvider>(context, listen: false);
  //     if (_controller!.value.isInitialized) {
  //       tabs.tap(true);
  //       setState(() {
  //         _controller!.pause();
  //       });
  //       _controller!.pause();
  //     }
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  initPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      myUsername = pref.getString(userNameKey)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
    ActionWare stream = context.watch<ActionWare>();
    TabProvider tabs = context.watch<TabProvider>();

    return GestureDetector(
      onDoubleTap: () async {
        if (controller.value == 1) {
          controller.reset();
          controller.forward();
        } else {
          controller.forward();GestureDetector(
            onDoubleTap: () async {
              if (controller.value == 1) {
                controller.reset();
                controller.forward();
              } else {
                controller.forward();
              }

              if (action.likeIds.contains(widget.data.id!)) {
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

              await likeAction(context, true);

              await Future.delayed(const Duration(seconds: 2));

              setState(() {
                flag = false;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: width,
                  height: height,
                  child: Flex(
                    //  mainAxisSize: MainAxisSize.max,
                    //   mainAxisSize: MainAxisSize.min,
                    direction: Axis.vertical,
                    // clipBehavior: Clip.hardEdge,
                    children: <Widget>[
                      Expanded(
                          child: LayoutBuilder(
                              builder: (_, constraints) =>
                                  widget.media.length < 2
                                      ? SinglePost(
                                          media: widget.media.first,
                                          controller: thisData == null
                                              ? null
                                              : thisData!.controller,
                                          shouldPlay: true,
                                          constraints: constraints,
                                          isHome: widget.isHome,
                                          thumbLink: widget.urls.first,
                                          isInView: widget.isInView!,
                                        )
                                      : MultiplePost(
                                          media: widget.media,
                                          constraints: constraints,
                                          data: widget.data,
                                          isHome: widget.isHome,
                                          thumbLinks: widget.urls,
                                          isInView: widget.isInView,
                                        )))
                    ],
                  ),
                ),
                // Align(
                //     alignment: Alignment.bottomRight,
                //     child: LikeSection(
                //       data: widget.data,
                //       page: widget.page,
                //       media: widget.media,
                //       urls: widget.urls,
                //     )),
                Positioned(
                  right: 1,
                  top: 0.1,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // myUsername == widget.data.user!.username!
                          //     ? const SizedBox.shrink()
                          //     : Expanded(
                          //         child: Row(
                          //           children: [
                          //             followButton(() async {
                          //               followAction(
                          //                 context,
                          //               );
                          //             },
                          //                 stream.followIds
                          //                         .contains(widget.data.user!.id!)
                          //                     ? "Following"
                          //                     : "Follow"),
                          //           ],
                          //         ),
                          //       ),

                          InkWell(
                              onTap: () => optionModal(context, widget.urls,
                                  widget.data.user!.id, widget.data.id),
                              child: SvgPicture.asset(
                                "assets/icon/new_option.svg",
                                height: 15,
                                width: 20,
                                color: HexColor(backgroundColor),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: NewDesignTest(
                        data: widget.data,
                        page: widget.page,
                        media: widget.urls,
                        controller: _controller,
                      )
                      // : FollowSection(
                      //     data: widget.data,
                      //     page: widget.page,
                      //     media: widget.media,
                      //     controller: _controller,
                      //   ),
                      ),
                ),

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
                            child: // Lottie.asset('assets/icon/like2.json',
                                //     // height: MediaQuery.of(context).size.width * 0.5,
                                //     // width: MediaQuery.of(context).size.width * 0.5,
                                //     repeat: false,
                                //     fit: BoxFit.fill),
                                Icon(
                              Icons.favorite,
                              size: MediaQuery.of(context).size.width * 0.4,
                              color: animation.value,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                widget.data.user!.gender == "Business" &&
                        widget.data.btnLink != null &&
                        widget.data.button != null
                    ? Positioned(
                        bottom: 0.1,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              SizedBox(
                                width: width,
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
                                        await UrlLaunchController
                                            .launchWebViewOrVC(
                                                Uri.parse(newVal));
                                      } else {
                                        await UrlLaunchController
                                            .launchWebViewOrVC(Uri.parse(
                                                widget.data.btnLink!));
                                      }
                                    } else {
                                      await UrlLaunchController
                                          .launchInWebViewOrVC(
                                              Uri.parse(widget.data.btnLink!));
                                    }
                                  },
                                  child: Container(
                                    height: 35,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.zero,
                                        color: HexColor("#00B074")),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppText(
                                            text: widget.data.button!,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            size: 12,
                                          ),
                                          // SvgPicture.asset(
                                          //   "assets/icon/Send.svg",
                                          //   color: Colors.white,
                                          //   height: 15,
                                          //   width: 12,
                                          // )
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
            ),
          );
        
        }

        if (action.likeIds.contains(widget.data.id!)) {
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

        await likeAction(context, true);

        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          flag = false;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: width,
            height: height,
            child: Flex(
              //  mainAxisSize: MainAxisSize.max,
              //   mainAxisSize: MainAxisSize.min,
              direction: Axis.vertical,
              // clipBehavior: Clip.hardEdge,
              children: <Widget>[
                Expanded(
                    child: LayoutBuilder(
                        builder: (_, constraints) => widget.media.length < 2
                            ? UserSinglePost(
                                media: widget.media.first,
                                controller: thisData == null
                                    ? null
                                    : thisData!.controller,
                                shouldPlay: true,
                                constraints: constraints,
                                isHome: widget.isHome,
                                thumbLink: widget.urls.first,
                                page: widget.page,
                                isInView: widget.isInView,
                              )
                            : UserMultiplePost(
                                media: widget.media,
                                constraints: constraints,
                                data: widget.data,
                                isHome: widget.isHome,
                                thumbLinks: widget.urls,
                                page: widget.page,
                                isInView: widget.isInView,
                              )))
              ],
            ),
          ),
          // Align(
          //     alignment: Alignment.bottomRight,
          //     child: LikeSection(
          //       data: widget.data,
          //       page: widget.page,
          //       media: widget.media,
          //       urls: widget.urls,
          //     )),
          Positioned(
            right: 1,
            top: 0.1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // myUsername == widget.data.user!.username!
                    //     ? const SizedBox.shrink()
                    //     : Expanded(
                    //         child: Row(
                    //           children: [
                    //             followButton(() async {
                    //               followAction(
                    //                 context,
                    //               );
                    //             },
                    //                 stream.followIds
                    //                         .contains(widget.data.user!.id!)
                    //                     ? "Following"
                    //                     : "Follow"),
                    //           ],
                    //         ),
                    //       ),

                    InkWell(
                        onTap: () => optionModal(context, widget.urls,
                            widget.data.user!.id, widget.data.id),
                        child: SvgPicture.asset(
                          "assets/icon/new_option.svg",
                          height: 15,
                          width: 20,
                          color: HexColor(backgroundColor),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 1,
            child: Align(
                alignment: Alignment.bottomLeft,
                child: NewDesignTest(
                  data: widget.data,
                  page: widget.page,
                  media: widget.urls,
                  controller: _controller,
                )

                // : FollowSection(
                //     data: widget.data,
                //     page: widget.page,
                //     media: widget.media,
                //     controller: _controller,
                //   ),
                ),
          ),

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
                      child: // Lottie.asset('assets/icon/like2.json',
                          //     // height: MediaQuery.of(context).size.width * 0.5,
                          //     // width: MediaQuery.of(context).size.width * 0.5,
                          //     repeat: false,
                          //     fit: BoxFit.fill),
                          Icon(
                        Icons.favorite,
                        size: MediaQuery.of(context).size.width * 0.4,
                        color: animation.value,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          widget.data.user!.gender == "Business" &&
                  widget.data.btnLink != null &&
                  widget.data.button != null
              ? Positioned(
                  bottom: 0.1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        SizedBox(
                          width: width,
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
                                await UrlLaunchController.launchInWebViewOrVC(
                                    Uri.parse(widget.data.btnLink!));
                              }
                            },
                            child: Container(
                              height: 35,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.zero,
                                  color: HexColor("#00B074")),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppText(
                                      text: widget.data.button!,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      size: 12,
                                    ),
                                    // SvgPicture.asset(
                                    //   "assets/icon/Send.svg",
                                    //   color: Colors.white,
                                    //   height: 15,
                                    //   width: 12,
                                    // )
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
      ),
    );
  }

  Widget followButton(VoidCallback onTap, String title) {
    //  ActionWare stream = context.watch<ActionWare>();
    return InkWell(
      onTap: onTap,
      child: Container(
        //  duration: const Duration(milliseconds: 500),
        height: 28,

        width: title == "Follow" ? null : null,
        constraints: BoxConstraints(
          maxWidth: title == "Follow" ? 54 : 75,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
                style: BorderStyle.solid,
                width: 1,
                color: title == "Follow"
                    ? HexColor("#8B8B8B").withOpacity(.9)
                    : HexColor("#8B8B8B").withOpacity(.9)),
            borderRadius: BorderRadius.circular(7)),
        child: Center(
          child: AppText(
            text: title,
            color: HexColor(backgroundColor),
            size: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Future<void> followAction(BuildContext context) async {
    ActionWare provide = Provider.of<ActionWare>(context, listen: false);

    //  provide.addFollowId(widget.data.id!);
    await ActionController.followOrUnFollowController(
        context, widget.data.user!.username!, widget.data.user!.id!);
  }

  Future<void> likeAction(BuildContext context, bool like) async {
    ActionWare provide = Provider.of<ActionWare>(context, listen: false);
    late bool isLiked;
    // print(like.toString());
    provide.tempAddLikeId(widget.data.id!);

    if (like == false) {
      isLiked = true;
      ActionController.likeOrDislikeController(context, widget.data.id!);
    } else {
      //  provide.tempAddLikeId(widget.data.id!);
      isLiked = false;
      ActionController.likeOrDislikeController(context, widget.data.id!);
    }

    // return !isLiked;
  }
}
