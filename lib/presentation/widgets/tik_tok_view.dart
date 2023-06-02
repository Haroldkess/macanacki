import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:like_button/like_button.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/operations.dart';
import 'package:makanaki/presentation/screens/home/Feed/feed_video_holder.dart';
import 'package:makanaki/presentation/screens/userprofile/user_profile_screen.dart';
import 'package:makanaki/presentation/uiproviders/screen/comment_provider.dart';
import 'package:makanaki/presentation/widgets/comment_modal.dart';
import 'package:makanaki/presentation/widgets/feed_views/follow_section.dart';
import 'package:makanaki/presentation/widgets/feed_views/like_section.dart';
import 'package:makanaki/presentation/widgets/feed_views/multiple_post.dart';
import 'package:makanaki/presentation/widgets/feed_views/single_posts.dart';
import 'package:makanaki/presentation/widgets/hexagon_avatar.dart';
import 'package:makanaki/presentation/widgets/option_modal.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/action_controller.dart';
import 'package:makanaki/services/controllers/view_controller.dart';
import 'package:makanaki/services/middleware/action_ware.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:numeral/numeral.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../model/feed_post_model.dart';
import '../../services/controllers/feed_post_controller.dart';
import '../../services/controllers/url_launch_controller.dart';
import '../screens/home/profile/profile_screen.dart';
import '../uiproviders/screen/tab_provider.dart';

class TikTokView extends StatefulWidget {
  final List<String> media;
    final List<String> urls;
  final FeedPost data;
  int? index1;
  int? index2;
  String page;
  List<FeedPost>? feedPosts;
    final bool isHome;

  TikTokView(
      {super.key,
      required this.media,
      required this.data,
      required this.page,
      this.index1,
      this.index2,
      required this.isHome,
      this.feedPosts, required this.urls});

  @override
  State<TikTokView> createState() => _TikTokViewState();
}

class _TikTokViewState extends State<TikTokView> with TickerProviderStateMixin {
  VideoPlayerController? _controller;

  List<String> savedVid = [];
  bool flag = false;
  late AnimationController controller;
  late Animation animation;

  bool _hasCallSupport = false;
  Future<void>? _launched;

  List<String> photos = [url, url, url];

  @override
  void initState() {
    super.initState();
   
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Operations.commentOperation(context, false, widget.data.comments!);
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

    if (widget.media.length < 2) {
      debugPrint("This is the url ${widget.data.media!.first}");
      if (widget.media == null || widget.media.isEmpty) return;
      if (widget.media.first.contains(".mp4")) {
        debugPrint("This is the url ${widget.media.first}");
        if (widget.media.first
            .contains("/data/user/0/com.example.makanaki/app_flutter/")) {
          debugPrint("++++++++++++++++++++++++++++++");
          _controller = VideoPlayerController.file(
            File(widget.media.first),
          )
            
            ..setLooping(true)
            ..initialize().then((_) => _controller!.play()).then((value) => {
              _controller!.addListener(() {
              setState(() {});
              if (_controller!.value.position.inSeconds > 7 &&
                  _controller!.value.position.inSeconds < 10) {
                ViewController.handleView(widget.data.id!);
                //log("Watched more than 10 seconds");
              }
            })
            });

          // _controller!.initialize().whenComplete(() {
          //   _controller!.play();
          //   setState(() {});
          // }).then((value) => {
          //       _controller!.addListener(() {
          //         if (_controller!.value.position.inSeconds > 7 &&
          //             _controller!.value.position.inSeconds < 10) {
          //           ViewController.handleView(widget.data.id!);
          //           //log("Watched more than 10 seconds");
          //         }
          //       })
          //     });

          // // Use the controller to loop the video.

          // _controller!.setLooping(true);
        } else {
          _controller = VideoPlayerController.network(
            widget.media.first.replaceAll('\\', '/'),
            //   videoPlayerOptions: VideoPlayerOptions()
          );

          _controller!.initialize().whenComplete(() {
            _controller!.play();
            setState(() {});
          }).then((value) => {
                _controller!.addListener(() {
                  if (_controller!.value.position.inSeconds > 7 &&
                      _controller!.value.position.inSeconds < 10) {
                    ViewController.handleView(widget.data.id!);
                    //log("Watched more than 10 seconds");
                  }
                })
              });

          // Use the controller to loop the video.

          _controller!.setLooping(true);
        }
      } else {
        Future.delayed(const Duration(seconds: 2))
            .whenComplete(() => ViewController.handleView(widget.data.id!));
      }
    }
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
    // print("This is the url ${widget.media.first}");
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
    return GestureDetector(
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
        children: [
          Container(
            width: width,
            height: height,
            child: Flex(
              mainAxisSize: MainAxisSize.max,
              //   mainAxisSize: MainAxisSize.min,
              direction: Axis.vertical,
              // clipBehavior: Clip.hardEdge,
              children: <Widget>[
                Expanded(
                    child: LayoutBuilder(
                        builder: (_, constraints) => widget.media.length < 2
                            ? SinglePost(
                                media: widget.media.first,
                                controller: _controller,
                                shouldPlay: true,
                                constraints: constraints,
                                isHome: widget.isHome,
                              )
                            : MultiplePost(
                                media: widget.media,
                                constraints: constraints,
                                data: widget.data,
                                isHome: widget.isHome,
                              )))
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: LikeSection(
                data: widget.data,
                page: widget.page,
                media: widget.media,
                urls: widget.urls,
              )),
          Align(
              alignment: Alignment.bottomLeft,
              child: FollowSection(
                data: widget.data,
                page: widget.page,
                media: widget.media,
                controller: _controller,
              )
              // : FollowSection(
              //     data: widget.data,
              //     page: widget.page,
              //     media: widget.media,
              //     controller: _controller,
              //   ),
              ),
          flag
              ? Align(
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
                )
              : const SizedBox.shrink(),
          widget.data.user!.gender == "Business" &&
                  widget.data.btnLink != null &&
                  widget.data.button != null
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            if (widget.data.button == "Call Now") {
                              await UrlLaunchController.makePhoneCall(
                                  widget.data.btnLink!);
                            }
                            if (widget.data.button == "Whatsapp") {
                              print(widget.data.btnLink!);

                              if (widget.data.btnLink!
                                  .contains("https://wa.me/https://")) {
                                var start = widget.data.btnLink!
                                    .split("https://wa.me/https://");

                                String newVal =
                                    "https://${start.last}".toString();
                                print(newVal);
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
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
                                    fontWeight: FontWeight.w800,
                                    size: 13,
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
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
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
