import 'package:apivideo_player/apivideo_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/home/diamond/diamond_modal/give_modal.dart';
import 'package:macanacki/presentation/screens/home/profile/promote_post/promote_screen.dart';
import 'package:macanacki/presentation/widgets/ads_display.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
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
import '../../services/controllers/url_launch_controller.dart';
import '../screens/home/diamond/diamond_modal/download_modal.dart';
import '../uiproviders/buttons/button_state.dart';
import '../uiproviders/screen/comment_provider.dart';
import '../uiproviders/screen/tab_provider.dart';
import 'feed_views/new_action_design.dart';
import 'option_modal.dart';
import 'package:flutter/services.dart';
import 'package:macanacki/services/middleware/video/video_ware.dart';

class TikTokView extends StatefulWidget {
  final List<String> media;
  final List<String> urls;
  final FeedPost data;
  final List<dynamic> vod;
  final List<dynamic>? nextImage;
  final List<dynamic> thumbails;
  int? index1;
  int? index2;
  String page;
  bool isFriends;
  List<FeedPost>? feedPosts;
  final bool isHome;
  VideoPlayerController? controller;
  bool? isInView;
  TikTokView(
      {super.key,
      required this.media,
      required this.data,
      required this.page,
      required this.nextImage,
      required this.thumbails,
      required this.vod,
      required this.isFriends,
      this.index1,
      this.index2,
      this.controller,
      required this.isHome,
      this.feedPosts,
      required this.urls,
      required this.isInView});

  @override
  State<TikTokView> createState() => _TikTokViewState();
}

class _TikTokViewState extends State<TikTokView> with TickerProviderStateMixin {
  // VideoPlayerController? _controller;
  FeedPost? thisData;
  ChewieController? _chewieController;
  List<String> savedVid = [];
  bool flag = false;
  late AnimationController controller;
  late Animation animation;
  //  MUXClient muxClient = MUXClient();
  late SharedPreferences pref;
  //String myUsername = "";
  int? bufferDelay;
  ApiVideoPlayerController? _controller;
  String apiToken = "";
  @override
  void initState() {
    super.initState();
    // emitter(widget.media.first.toString());
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.media.isNotEmpty) {
    //     if (widget.media.first.contains(".mp4")) {
    //       try {
    //         VideoWareHome.instance.addVideoToList(widget.data).whenComplete(() {
    //           emitter("video added");
    //         }).whenComplete(() {
    //              try {
    //   initializePlayer();
    // } catch (e) {
    //   emitter(e.toString());
    // }
    //         });
    //       } catch (e) {
    //         emitter(e.toString());
    //       }
    //     }
    //   }

    //   //  ButtonState.instance.tapClose();
    // });
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
      // debugPrint("This is the url ${widget.data.media!.first}");
      if (widget.media.isEmpty) return;
      if (!widget.media.first.contains("https")) {
      } else {
        Future.delayed(const Duration(seconds: 2))
            .whenComplete(() => ViewController.handleView(widget.data.id!));
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        try {
          StoreComment comment =
              Provider.of<StoreComment>(context, listen: false);
          List checkCom = comment.comments
              .where((element) => element.postId == widget.data.id)
              .toList();

          if (checkCom.isEmpty) {
            if (widget.data.comments!.isEmpty) {
              return;
            } else {
              Operations.commentOperation(
                  context, false, widget.data.comments!);
            }
          } else {
            return;
          }
        } catch (e) {
          emitter(e.toString());
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
    TabProvider stream = context.watch<TabProvider>();
    // print(widget.data.media!.first);
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
              Row(
                children: [
                  IconButton(
                      onPressed: () => PageRouting.popToPage(context),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: textPrimary,
                      )),
                  GestureDetector(
                      onTap: () => giveDiamondsModal(
                          context, widget.data.user!.username!),
                      child: Container(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset(
                          "assets/icon/diamond.svg",
                        ),
                      )),
                  SizedBox(
                    width: widget.isFriends ? 20 : 15,
                  ),
                  widget.data.media!.isEmpty
                      ? SizedBox.shrink()
                      : widget.data.media!.first.contains(".mp3")
                          ? SizedBox.shrink()
                          : GestureDetector(
                              onTap: () async {
                                downloadDiamondsModal(
                                    context,
                                    widget.data.id!,
                                    widget.data.media!.first.contains(".mp3")
                                        ? true
                                        : false);
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
                                          stream.image.replaceAll('\\', '/')
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
              InkWell(
                  onTap: () => optionModal(context, widget.urls,
                      widget.data.user!.id, widget.data.id, widget.data),
                  child: Container(
                    //   color: Colors.amber,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Container(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              "assets/icon/more.svg",
                              color: textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: 40,
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
      body: GestureDetector(
          onDoubleTap: () async {
            HapticFeedback.heavyImpact();
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

            try {
              await likeAction(context, true);
            } catch (e) {
              emitter(e.toString());
            }

            await Future.delayed(const Duration(seconds: 2));

            setState(() {
              flag = false;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: widget.nextImage == null
                    ? []
                    : List.generate(
                        widget.nextImage == null ? 0 : widget.nextImage!.length,
                        (index) => Container(
                          height: 0,
                          color: Colors.black,
                          child: CachedNetworkImage(
                              color: Colors.black,
                              imageUrl: widget.nextImage![index] ?? ""),
                        ),
                      ),
              ),
              widget.thumbails.isEmpty
                  ? SizedBox.shrink()
                  : Column(
                      children: widget.thumbails.first == null
                          ? []
                          : List.generate(
                              widget.thumbails == null
                                  ? 0
                                  : widget.thumbails.length,
                              (index) => Container(
                                height: 5,
                                color: Colors.black,
                                child: widget.thumbails[index] == null
                                    ? SizedBox.shrink()
                                    : CachedNetworkImage(
                                        color: Colors.black,
                                        imageUrl:
                                            widget.thumbails[index] ?? ""),
                              ),
                            ),
                    ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                      child: widget.media.length < 2
                          ? Center(
                              child: SinglePost(
                                media: widget.media.isEmpty
                                    ? ""
                                    : widget.media.first,
                                shouldPlay: true,
                                // constraints: constraints,
                                isHome: widget.isHome,
                                thumbLink: widget.thumbails.isEmpty
                                    ? ""
                                    : widget.thumbails.first ?? "",
                                isInView: widget.isInView!,
                                postId: widget.data.id!,
                                data: widget.data,
                                vod: widget.vod.isEmpty ? "" : widget.vod.first,
                                allPost: [],
                              ),
                            )
                          : MultiplePost(
                              media: widget.media,
                              //  constraints: constraints,
                              data: widget.data,
                              isHome: widget.isHome,
                              thumbLinks: widget.urls,
                              isInView: widget.isInView,
                            )),
                  SizedBox(
                    height: widget.data.user!.gender == "Business"
                        ? widget.data.btnLink != null &&
                                widget.data.button != null
                            ? 130
                            : 124
                        : widget.data.btnLink != null &&
                                widget.data.button != null
                            ? 130
                            : widget.data.description!.isEmpty
                                ? 70
                                : 124,
                  )
                ],
              ),
              Positioned(
                bottom: 0,
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: NewDesignTest(
                      data: widget.data,
                      page: widget.page,
                      media: widget.media,
                      controller: _controller,
                      isHome: true,
                      showComment: true,
                      extended: false,
                    )),
              ),
              widget.page == "user"
                  ? Positioned(
                      bottom: 120,
                      right: 0,
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AdsDisplay(
                                action: () {
                                  PageRouting.pushToPage(
                                      context,
                                      PromoteScreen(
                                          postId: widget.data.id.toString()));
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
                          child: Icon(
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
                                      await UrlLaunchController
                                          .launchWebViewOrVC(Uri.parse(newVal));
                                    } else {
                                      await UrlLaunchController
                                          .launchWebViewOrVC(
                                              Uri.parse(widget.data.btnLink!));
                                    }
                                  } else {
                                    //  print(widget.data.btnLink);
                                    if (widget.data.button == "Spotify") {
                                      await UrlLaunchController
                                          .launchWebViewOrVC(
                                              Uri.parse(widget.data.btnLink!));
                                    } else {
                                      await UrlLaunchController
                                          .launchWebViewOrVC(
                                              Uri.parse(widget.data.btnLink!));
                                    }
                                  }
                                },
                                child: Container(
                                  height: 35,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.zero,
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppText(
                                          text: widget.data.button!,
                                          color: HexColor(backgroundColor),
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
          )),
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
