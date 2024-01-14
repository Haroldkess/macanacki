import 'dart:developer';
import 'dart:io';
import 'package:apivideo_player/apivideo_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
import '../../model/profile_feed_post.dart';
import '../../services/controllers/feed_post_controller.dart';
import '../../services/controllers/save_media_controller.dart';
import '../../services/controllers/url_launch_controller.dart';
import '../../services/middleware/gift_ware.dart';
import '../../services/middleware/user_profile_ware.dart';
import '../../services/middleware/video/video_ware.dart';
import '../../services/temps/temps_id.dart';
import '../allNavigation.dart';
import '../constants/string.dart';
import '../screens/home/diamond/diamond_modal/download_modal.dart';
import '../screens/home/diamond/diamond_modal/give_modal.dart';
import '../screens/home/profile/promote_post/promote_screen.dart';
import '../uiproviders/screen/comment_provider.dart';
import '../uiproviders/screen/tab_provider.dart';
import 'ads_display.dart';
import 'feed_views/new_action_design.dart';
import 'feed_views/user_multiple_post.dart';
import 'option_modal.dart';
import 'package:flutter/services.dart';

class UserTikTokView extends StatefulWidget {
  final List<String> media;
  final List<String> urls;
  final List<dynamic> thumbails;
  final FeedPost data;
  final List<dynamic> allPost;
  final List<dynamic> vod;
  int? index1;
  int? index2;
  String page;
  List<FeedPost>? feedPosts;
  final bool isHome;
  VideoPlayerController? controller;
  bool? isInView;
  dynamic pageData;
  final ProfileFeedDatum? thisPost;
  bool showComment;
  UserTikTokView(
      {super.key,
      required this.media,
      required this.data,
      required this.page,
      required this.vod,
      required this.thumbails,
      required this.allPost,
      required this.showComment,
      this.index1,
      this.index2,
      this.controller,
      required this.isHome,
      this.feedPosts,
      required this.urls,
      required this.isInView,
      required this.pageData,
      this.thisPost});

  @override
  State<UserTikTokView> createState() => _UserTikTokViewState();
}

class _UserTikTokViewState extends State<UserTikTokView>
    with TickerProviderStateMixin {
  ApiVideoPlayerController? _controller;
  FeedPost? thisData;
  static const _networkCachingMs = 2000;
  // final _key = GlobalKey<VlcPlayerWithControlsState>();

  static const _subtitlesFontSize = 30;

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
    // log(widget.data.id!.toString());
    initPref();
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

    if (widget.media.length < 2) {
      //  debugPrint("This is the url ${widget.data.media!.first}");
      if (widget.media == null || widget.media.isEmpty) return;
      if (!widget.media.first.contains("https")) {
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //   VideoWare.instance.getVideoPostFromApi(widget.allPost);
        // });
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //   VideoWareHome.instance.disposeAllVideoV2(widget.data.id!,
        //       "$muxStreamBaseUrl/${widget.media.first}.$videoExtension");
        // VideoWareHome.instance.initSomeVideo(
        //     "$muxStreamBaseUrl/${widget.media.first}.$videoExtension",
        //     widget.data.id!,
        //     0);
        // });
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
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    if (widget.media.length < 2) {
      debugPrint("This is the url ${widget.data.media!.first}");
      if (widget.media == null || widget.media.isEmpty) return;
      if (!widget.media.first.contains("https")) {
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //   VideoWare.instance.disposeVideo(widget.data.id!,
        //       "$muxStreamBaseUrl/${widget.media.first}.$videoExtension");
        // });
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //   VideoWare.instance.disposeAllVideoV2(widget.data.id!,
        //       "$muxStreamBaseUrl/${widget.media.first}.$videoExtension");
        // });
      }
    }
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
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);

    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: HexColor(backgroundColor),
        elevation: 0,
        title: Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

              Row(
                children: [
                  InkWell(
                      onTap: () => PageRouting.popToPage(context),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      )),
                  // SizedBox(
                  //   width: 2,
                  // ),
                  widget.data.user!.username! == user.userProfileModel.username
                      ? SizedBox.shrink()
                      : GestureDetector(
                          onTap: () => giveDiamondsModal(
                              context, widget.data.user!.username!),
                          child: Container(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              "assets/icon/diamond.svg",
                              //  color: HexColor(diamondColor),
                            ),
                          )),
                  widget.data.user!.username! == user.userProfileModel.username
                      ? SizedBox.shrink()
                      : SizedBox(
                          width: 10,
                        ),
                  widget.data.media!.first.contains(".mp3")
                      ? SizedBox.shrink()
                      : GestureDetector(
                          onTap: () async {
                            if (widget.data.user!.username! ==
                                user.userProfileModel.username) {
                              if (widget.media.length > 1) {
                                await Future.forEach(widget.media,
                                    (element) async {
                                  if (element.isNotEmpty) {
                                    try {
                                      if (element.contains('.mp4')) {
                                        await SaveMediaController
                                            .saveNetworkVideo(
                                                context,
                                                element,
                                                widget.data.description ??
                                                    "macanacki");
                                      } else {
                                        await SaveMediaController
                                            .saveNetworkImage(
                                                context,
                                                element,
                                                widget.data.description ??
                                                    "macanacki");
                                      }
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                  }
                                });
                              } else {
                                if (widget.data.media!.first.contains('.mp4')) {
                                  emitter(widget.media.first);
                                  await SaveMediaController.saveNetworkVideo(
                                      context,
                                      widget.data.media!.first,
                                      widget.data.description ?? "macanacki");
                                } else if (widget.data.media!.first
                                    .contains('.mp3')) {
                                  await SaveMediaController.saveNetworkAudio(
                                      context,
                                      widget.data.media!.first,
                                      widget.data.description ?? "macanacki");
                                } else {
                                  await SaveMediaController.saveNetworkImage(
                                      context,
                                      widget.data.media!.first,
                                      widget.data.description ?? "macanacki");
                                }
                              }
                            } else {
                              downloadDiamondsModal(
                                  context,
                                  widget.data.id!,
                                  widget.data.media!.first.contains(".mp3")
                                      ? true
                                      : false);
                            }
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            child: SvgPicture.asset(
                              "assets/icon/d.svg",
                              color: textPrimary,
                            ),
                          )),
                ],
              ),

              widget.media.length > 1
                  ? Expanded(
                      //  width: 200,
                      //color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...widget.media.map((e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                child: CircleAvatar(
                                  backgroundColor: e.replaceAll('\\', '/') ==
                                          tabs.image.replaceAll('\\', '/')
                                      ? Colors.green
                                      : HexColor("#6A6A6A"),
                                  radius: 3,
                                  //   width: 25,
                                  //   height: 3,
                                ),
                              ))
                        ],
                      ),
                    )
                  : SizedBox.shrink(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 28),
                child: InkWell(
                    onTap: () => optionModal(context, widget.urls,
                        widget.data.user!.id, widget.data.id, widget.data),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(
                          "assets/icon/more.svg",
                          color: textPrimary,
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onDoubleTap: () async {
          HapticFeedback.vibrate();

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
                direction: Axis.vertical,
                // clipBehavior: Clip.hardEdge,
                children: <Widget>[
                  Expanded(
                      child: LayoutBuilder(
                          builder: (_, constraints) => widget.media.length < 2
                              ? UserSinglePost(
                                  media: widget.media.first,
                                  // /  controller: thisData == null
                                  //       ? null
                                  //       : thisData!.controller,
                                  shouldPlay: true,
                                  constraints: constraints,
                                  isHome: widget.isHome,
                                  thumbLink: widget.thumbails.first ?? "",
                                  page: widget.page,
                                  isInView: widget.isInView,
                                  postId: widget.data.id!,
                                  data: widget.data,
                                  vod: widget.vod.first,
                                  showComment: widget.showComment,
                                  allPost: widget.allPost,
                                  //   vlcController: _vlcController,
                                )
                              : UserMultiplePost(
                                  media: widget.media,
                                  constraints: constraints,
                                  data: widget.data,
                                  isHome: widget.isHome,
                                  thumbLinks: widget.urls,
                                  page: widget.page,
                                  isInView: widget.isInView,
                                  showComment: widget.showComment,
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
              bottom: 0,
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: NewDesignTest(
                    data: widget.data,
                    page: widget.page,
                    media: widget.urls,
                    controller: _controller,
                    isHome: false,
                    showComment: widget.showComment,
                    extended: true,
                  )

                  // : FollowSection(
                  //     data: widget.data,
                  //     page: widget.page,
                  //     media: widget.media,
                  //     controller: _controller,
                  //   ),
                  ),
            ),
            // widget.data.promoted == "yes"
            //     ? Positioned(
            //         bottom: 100,
            //         left: 0,
            //         child: Align(
            //             alignment: Alignment.bottomLeft,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 // AdsDisplay(
            //                 //   sponsored: false,
            //                 //   color: HexColor('#00B074'),
            //                 //   title: '\$10.000.00',
            //                 // ),
            //                 // SizedBox(
            //                 //   height: 10,
            //                 // ),
            //                 AdsDisplay(
            //                   sponsored: true,
            //                   //  color: HexColor('#00B074'),
            //                   color: Colors.transparent,
            //                   title: 'Sponsored Ad',
            //                 ),
            //               ],
            //             )),
            //       )
            //     : SizedBox.shrink(),
            widget.page == "user"
                ? Positioned(
                    bottom: 150,
                    right: 0,
                    child: widget.data.promoted == "yes"
                        ? SizedBox.shrink()
                        : Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AdsDisplay(
                                  action: () {
                                    PageRouting.pushToPage(
                                        context,
                                        PromoteScreen(
                                          postId: widget.data.id.toString(),
                                          thisPost: widget.thisPost,
                                        ));
                                  },
                                  sponsored: false,
                                  color: HexColor('#00B074'),
                                  title: 'PROMOTE',
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

            widget.data.btnLink != null && widget.data.button != null
                ? Positioned(
                    bottom: .1,
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
                                  if (widget.data.button == "Spotify") {
                                    await UrlLaunchController.launchWebViewOrVC(
                                        Uri.parse(widget.data.btnLink!));
                                  } else {
                                    await UrlLaunchController
                                        .launchInWebViewOrVC(
                                            Uri.parse(widget.data.btnLink!));
                                  }
                                }
                              },
                              child: Container(
                                height: 35,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.zero,
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppText(
                                        text: widget.data.button!,
                                        color: HexColor(backgroundColor),
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
