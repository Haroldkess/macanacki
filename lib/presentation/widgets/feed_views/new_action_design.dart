import 'package:animate_do/animate_do.dart';
import 'package:apivideo_player/apivideo_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:just_audio/just_audio.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../../model/feed_post_model.dart';
import '../../../services/controllers/action_controller.dart';
import '../../../services/middleware/action_ware.dart';
import '../../../services/temps/temps_id.dart';
import '../../allNavigation.dart';
import '../../constants/colors.dart';
import '../../constants/string.dart';
import '../../operations.dart';
import '../../screens/home/profile/profile_screen.dart';
import '../../screens/userprofile/testing_profile.dart';
import '../../screens/userprofile/user_profile_screen.dart';
import '../../uiproviders/screen/comment_provider.dart';
import '../../uiproviders/screen/tab_provider.dart';
import '../comment_modal.dart';
import '../hexagon_avatar.dart';
import '../text.dart';
import 'package:macanacki/services/middleware/video/video_ware.dart';

class NewDesignTest extends StatefulWidget {
  final FeedPost data;
  String page;
  final List<String> media;
  ApiVideoPlayerController? controller;
  bool isHome;
  bool showComment;
  bool extended;
  NewDesignTest(
      {super.key,
      required this.isHome,
      required this.data,
      required this.page,
      required this.media,
      required this.showComment,
      this.controller,
      required this.extended});

  @override
  State<NewDesignTest> createState() => _NewDesignTestState();
}

class _NewDesignTestState extends State<NewDesignTest> {
  bool showMore = false;
  late SharedPreferences pref;
  // String myUsername = "";
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  String test =
      "Users description will appear here eg. Video description here. description should be two lines before...see moreUsers description will appear here eg. Video description here. description should be two lines before...see more";

  @override
  void initState() {
    super.initState();
    // initPref();
  }

  initPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      //   myUsername = pref.getString(userNameKey)!;
    });
  }

  int seeMoreVal = 89;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    //_checkIfLikedBefore();
    var w = 30.0;
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    ActionWare stream = context.watch<ActionWare>();
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
    StoreComment comment = context.watch<StoreComment>();
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Container(
        height: showMore
            ? height / 1.4
            : widget.data.user!.gender == "Business"
                ? 124
                : 124,
        width: width,
        decoration: BoxDecoration(
          //    backgroundBlendMode: BlendMode.colorDodge,
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(.0),
                Colors.black.withOpacity(.1),
                Colors.black.withOpacity(.4),
                Colors.black.withOpacity(.5),
                Colors.black.withOpacity(.6),
              ],
              stops: [
                0.0,
                0.1,
                0.3,
                0.8,
                0.9
              ]),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    //  color: Colors.amber,
                    //475
                    constraints: BoxConstraints(maxWidth: width * 0.55),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            TabProvider action = Provider.of<TabProvider>(
                                context,
                                listen: false);

                            if (widget.data.user!.username! ==
                                user.userProfileModel.username) {
                            } else {
                              if (widget.isHome == false) {
                                return;
                              }
                              try {} catch (e) {}
                              PageRouting.pushToPage(
                                  context,
                                  TestProfile(
                                    username: widget.data.user!.username!,
                                    extended: widget.extended,
                                    page: widget.page,
                                  ));
                            }
                          },
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // HexagonWidget.pointy(
                                  //   width: w - 3,
                                  //   elevation: 2.0,
                                  //   color: Colors.white,
                                  //   cornerRadius: 2.0,
                                  //   child: AspectRatio(
                                  //     aspectRatio: HexagonType.POINTY.ratio,
                                  //     // child: Image.asset(
                                  //     //   'assets/tram.jpg',
                                  //     //   fit: BoxFit.fitWidth,
                                  //     // ),
                                  //   ),
                                  // ),
                                  DpAvatar(
                                    url: widget.data.user!.profilephoto!,
                                    w: 13,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 5.5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 139,
                                        ),
                                        //   color: Colors.amber,
                                        child: AppText(
                                          text: widget.data.user!.username!,
                                          size: 16,
                                          fontWeight: FontWeight.w700,
                                          maxLines: 1,
                                          overflow: widget.data.user!.username!
                                                      .length >
                                                  20
                                              ? TextOverflow.ellipsis
                                              : TextOverflow.ellipsis,
                                          color: HexColor(backgroundColor),
                                        ),
                                      ),
                                      widget.data.user!.verified == 1 &&
                                              widget.data.user!.activePlan !=
                                                  sub
                                          ? SvgPicture.asset(
                                              "assets/icon/badge.svg",
                                              height: 13,
                                              width: 13)
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 139,
                                        ),
                                        //   color: Colors.amber,
                                        child: AppText(
                                          text: Operations.feedTimes(
                                              widget.data.createdAt!),
                                          size: 12,
                                          fontWeight: FontWeight.w400,
                                          maxLines: 1,
                                          color: HexColor(backgroundColor)
                                              .withOpacity(.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5.5,
                        ),
                        // Image.asset("assets/pic/verified.png"),
                        // const SizedBox(
                        //   width: 5.5,
                        // ),
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

                        // const SizedBox(
                        //   width: 15.5,
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          likeButton(
                              context,
                              stream.likeIds.contains(widget.data.id!) ||
                                      stream.isDoubleTapped
                                  ? widget.data.noOfLikes! + stream.addLike
                                  : widget.data.noOfLikes!,
                              stream.likeIds.contains(widget.data.id!) ||
                                      stream.isDoubleTapped
                                  ? true
                                  : false),
                          // myIcon("assets/icon/heart.svg", backgroundColor, 35, 35,
                          //     widget.data.noOfLikes),
                          InkWell(
                            onTap: () async {
                              StoreComment comment = Provider.of<StoreComment>(
                                  context,
                                  listen: false);
                              List checkCom = comment.comments
                                  .where((element) =>
                                      element.postId == widget.data.id)
                                  .toList();

                              if (checkCom.isEmpty) {
                                if (widget.data.comments!.isEmpty) {
                                } else {
                                  Operations.commentOperation(
                                      context, false, widget.data.comments!);
                                }
                              } else {}
                              setState(() {});
                              //   emitter(comment.comments.length.toString());
                              // emitter(widget.data.id!.toString());
                              // Operations.commentOperation(
                              //     context, false, widget.data.comments!);

                              commentModal(
                                context,
                                widget.data.id!,
                                widget.page,
                                widget.showComment,
                                false,
                                widget.controller,
                                widget.data.comments!,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: myIcon(
                                  "assets/icon/coment.svg",
                                  backgroundColor,
                                  30,
                                  30,
                                  comment.comments
                                      .where((element) =>
                                          element.postId == widget.data.id)
                                      .toList()
                                      .length),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 36, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      //   width: width * 0.5,
                      constraints: BoxConstraints(maxWidth: width * 0.85),
                      child: SingleChildScrollView(
                        child: RichText(
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            maxLines: showMore ? 50 : 2,
                            text: TextSpan(
                                text: widget.data.description!.length >=
                                            seeMoreVal &&
                                        showMore == false
                                    ? widget.data.description!
                                        .substring(0, seeMoreVal - 5)
                                    : widget.data.description!,
                                style: GoogleFonts.leagueSpartan(
                                    textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: HexColor(backgroundColor)
                                      .withOpacity(0.9),
                                  decorationStyle: TextDecorationStyle.solid,
                                  fontSize: 12,
                                  fontFamily: '',
                                )),
                                recognizer: tapGestureRecognizer
                                  ..onTap = () async {
                                    //    print("object");
                                    if (showMore) {
                                      setState(() {
                                        showMore = false;
                                      });
                                    } else {
                                      setState(() {
                                        showMore = true;
                                      });
                                    }
                                  },
                                children: [
                                  widget.data.description!.length < seeMoreVal
                                      ? const TextSpan(text: "")
                                      : TextSpan(
                                          text:
                                              showMore ? " less" : " see more",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: HexColor(backgroundColor),
                                            fontWeight: FontWeight.w600,
                                          ),
                                          recognizer: tapGestureRecognizer
                                            ..onTap = () async {
                                              //    print("object");
                                              if (showMore) {
                                                setState(() {
                                                  showMore = false;
                                                });
                                              } else {
                                                setState(() {
                                                  showMore = true;
                                                });
                                              }
                                            },
                                        )
                                ])),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: widget.data.user!.gender == "Business" ? 10 : 10,
              ),
              SizedBox(
                height:
                    widget.data.btnLink != null && widget.data.button != null
                        ? 40
                        : 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row myIcon(String svgPath, String hexString, double height, double width,
      [int? text]) {
    StoreComment comment = context.watch<StoreComment>();
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: HexColor(backgroundColor), width: 0.5)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: SvgPicture.asset(
                    svgPath,
                    height: 18,
                    width: 18,
                    color: HexColor(hexString),
                  ),
                ),
              ),
            ),
          ),
        ),
        //  text == 0 ? widget.data.comments!.length : text
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 40),
            child: AppText(
              text: text == null
                  ? ""
                  : Numeral(text == 0 ? widget.data.comments!.length : text)
                      .format(fractionDigits: 1),
              size: 14,
              align: TextAlign.center,
              fontWeight: FontWeight.w500,
              color: HexColor(backgroundColor),
            ),
          ),
        )
      ],
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

  Column likeButton(BuildContext context, int likes, bool likedBefore) {
    //  ActionWare stream = context.watch<ActionWare>();
    //log(likedBefore.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LikeButton(
          isLiked: likedBefore,
          animationDuration: Duration(seconds: 2),
          circleColor:
              CircleColor(start: HexColor(primaryColor), end: Colors.red),
          bubblesColor: BubblesColor(
              dotPrimaryColor: Colors.red,
              dotSecondaryColor: HexColor(primaryColor),
              dotThirdColor: Colors.yellow,
              dotLastColor: Colors.green),
          countPostion: CountPostion.right,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          likeCountPadding: const EdgeInsets.only(
            top: 0,
            left: 5,
            bottom: 0,
          ),
          onTap: (isLiked) async {
            likeAction(context, isLiked);
            return !isLiked;
          },
          //
          countDecoration: (count, likeCount) => Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 40),
              child: AppText(
                text: Numeral(likeCount!).format(fractionDigits: 1),
                color: Colors.white,
                align: TextAlign.center,
                size: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          padding:
              EdgeInsets.only(right: 10, top: likedBefore ? 0 : 0, bottom: 0),
          likeCount: int.tryParse(Numeral(likes).format(fractionDigits: 1)),
          likeBuilder: (bool isLiked) {
            return isLiked
                ? Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: HexColor(backgroundColor), width: 0.5)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.favorite,
                          color: HexColor(primaryColor),
                          size: 21,
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: HexColor(backgroundColor), width: 0.5)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "assets/icon/hert.svg",
                          color: HexColor(backgroundColor),
                          height: 16,
                          width: 16,
                        ),
                      ),
                    ),
                  );
          },
          size: 40,
        ),
      ],
    );
  }

  Future<void> likeAction(BuildContext context, bool like) async {
    ActionWare provide = Provider.of<ActionWare>(context, listen: false);
    late bool isLiked;
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

class VideoUser extends StatefulWidget {
  final FeedPost data;
  String page;
  final List<String> media;
  dynamic controller;
  bool? isAudio;
  AudioPlayer? player;
  bool? isVideo;
  bool isHome;
  VideoUser(
      {super.key,
      required this.data,
      required this.page,
      required this.media,
      this.isAudio,
      this.isVideo,
      required this.isHome,
      this.player,
      this.controller});

  @override
  State<VideoUser> createState() => _VideoUserState();
}

class _VideoUserState extends State<VideoUser> {
  bool showMore = false;
  late SharedPreferences pref;
  // String myUsername = "";
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  String test =
      "Users description will appear here eg. Video description here. description should be two lines before...see moreUsers description will appear here eg. Video description here. description should be two lines before...see more";

  @override
  void initState() {
    super.initState();
    // initPref();
  }

  initPref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      //   myUsername = pref.getString(userNameKey)!;
    });
  }

  int seeMoreVal = 89;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    //_checkIfLikedBefore();
    var w = 30.0;
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    ActionWare stream = context.watch<ActionWare>();
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
    StoreComment comment = context.watch<StoreComment>();
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.isAudio == true
              ? SizedBox.shrink()
              : Container(
                  height: widget.isAudio == true
                      ? 60
                      : showMore
                          ? height / 1.4
                          : widget.data.user!.gender == "Business"
                              ? 124
                              : 124,
                  width: width,
                  decoration: BoxDecoration(
                    //color: Colors.amber
                    //  backgroundBlendMode: BlendMode.colorDodge,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(.0),
                          Colors.black.withOpacity(.1),
                          Colors.black.withOpacity(.3),
                          Colors.black.withOpacity(.4),
                          Colors.black.withOpacity(.6),
                        ],
                        stops: [
                          0.0,
                          0.1,
                          0.3,
                          0.8,
                          0.9
                        ]),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: FadeInRight(
                      duration: Duration(seconds: 1),
                      animate: true,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                //  color: Colors.amber,
                                //475
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.75),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        TabProvider action =
                                            Provider.of<TabProvider>(context,
                                                listen: false);

                                        if (widget.isAudio == true) {
                                          if (widget.player != null) {
                                            widget.player!.pause();
                                          }
                                        }

                                        if (widget.isVideo == true) {
                                          widget.controller!.pause();
                                        }

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
                                          PageRouting.pushToPage(
                                              context,
                                              TestProfile(
                                                username:
                                                    widget.data.user!.username!,
                                                extended: true,
                                                page: widget.page,
                                              ));
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // HexagonWidget.pointy(
                                              //   width: w - 3,
                                              //   elevation: 2.0,
                                              //   color: Colors.white,
                                              //   cornerRadius: 2.0,
                                              //   child: AspectRatio(
                                              //     aspectRatio: HexagonType.POINTY.ratio,
                                              //     // child: Image.asset(
                                              //     //   'assets/tram.jpg',
                                              //     //   fit: BoxFit.fitWidth,
                                              //     // ),
                                              //   ),
                                              // ),
                                              // HexagonAvatar(
                                              //   url: widget.data.user!.profilephoto!,
                                              //   w: w,
                                              // ),
                                              DpAvatar(
                                                url: widget
                                                    .data.user!.profilephoto!,
                                                w: w,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 5.5,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxWidth: 139,
                                                    ),
                                                    //   color: Colors.amber,
                                                    child: AppText(
                                                      text: widget
                                                          .data.user!.username!,
                                                      size: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      maxLines: 1,
                                                      overflow: widget
                                                                  .data
                                                                  .user!
                                                                  .username!
                                                                  .length >
                                                              20
                                                          ? TextOverflow
                                                              .ellipsis
                                                          : TextOverflow
                                                              .ellipsis,
                                                      color: HexColor(
                                                          backgroundColor),
                                                    ),
                                                  ),
                                                  widget.data.user!.verified ==
                                                              1 &&
                                                          widget.data.user!
                                                                  .activePlan !=
                                                              sub
                                                      ? SvgPicture.asset(
                                                          "assets/icon/badge.svg",
                                                          height: 13,
                                                          width: 13)
                                                      : const SizedBox.shrink(),
                                                  // SizedBox(
                                                  //   width: 7,
                                                  // ),
                                                  // user.userProfileModel.username ==
                                                  //         widget.data.user!.username!
                                                  //     ? const SizedBox.shrink()
                                                  //     : Row(
                                                  //         children: [
                                                  //           followButton(() async {
                                                  //             followAction(
                                                  //               context,
                                                  //             );
                                                  //           },
                                                  //               stream.followIds.contains(
                                                  //                       widget.data.user!
                                                  //                           .id!)
                                                  //                   ? "Following"
                                                  //                   : "Follow"),
                                                  //         ],
                                                  //       ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    constraints:
                                                        const BoxConstraints(
                                                      maxWidth: 139,
                                                    ),
                                                    //   color: Colors.amber,
                                                    child: AppText(
                                                      text:
                                                          Operations.feedTimes(
                                                              widget.data
                                                                  .createdAt!),
                                                      size: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      maxLines: 1,
                                                      color: HexColor(
                                                              backgroundColor)
                                                          .withOpacity(.6),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          widget.isAudio == true
                              ? SizedBox.shrink()
                              : Padding(
                                  padding:
                                      const EdgeInsets.only(left: 36, top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        //   width: width * 0.5,
                                        constraints: BoxConstraints(
                                            maxWidth: width * 0.85),
                                        child: SingleChildScrollView(
                                          child: RichText(
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: showMore ? 50 : 2,
                                              text: TextSpan(
                                                  text: widget.data.description!
                                                                  .length >=
                                                              seeMoreVal &&
                                                          showMore == false
                                                      ? widget.data.description!
                                                          .substring(
                                                              0, seeMoreVal - 3)
                                                      : widget
                                                          .data.description!,
                                                  style:
                                                      GoogleFonts.leagueSpartan(
                                                          textStyle: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: HexColor(
                                                            backgroundColor)
                                                        .withOpacity(0.9),
                                                    decorationStyle:
                                                        TextDecorationStyle
                                                            .solid,
                                                    fontSize: 12,
                                                    fontFamily: '',
                                                  )),
                                                  recognizer:
                                                      tapGestureRecognizer
                                                        ..onTap = () async {
                                                          //    print("object");
                                                          if (showMore) {
                                                            setState(() {
                                                              showMore = false;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              showMore = true;
                                                            });
                                                          }
                                                        },
                                                  children: [
                                                    widget.data.description!
                                                                .length <
                                                            seeMoreVal
                                                        ? const TextSpan(
                                                            text: "")
                                                        : TextSpan(
                                                            text: showMore
                                                                ? " less"
                                                                : "...see more",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: HexColor(
                                                                  backgroundColor),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            recognizer:
                                                                tapGestureRecognizer
                                                                  ..onTap =
                                                                      () async {
                                                                    //    print("object");
                                                                    if (showMore) {
                                                                      setState(
                                                                          () {
                                                                        showMore =
                                                                            false;
                                                                      });
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        showMore =
                                                                            true;
                                                                      });
                                                                    }
                                                                  },
                                                          )
                                                  ])),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: widget.data.user!.gender == "Business"
                                ? 10
                                : 10,
                          ),
                          SizedBox(
                            height: widget.data.btnLink != null &&
                                    widget.data.button != null
                                ? 40
                                : 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          widget.isAudio == true || widget.isVideo == true
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: 10,
                        bottom: widget.data.btnLink != null &&
                                widget.data.button != null
                            ? 50
                            : 30),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 40,
                          width: 35,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.data.thumbnails!.first ?? ""),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: Lottie.asset("assets/icon/wav.json")),
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox.shrink()
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
        height: 20,

        width: title == "Follow" ? null : null,
        constraints: BoxConstraints(
          maxWidth: title == "Follow" ? 54 : 65,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: HexColor(primaryColor),
            border: Border.all(
                style: BorderStyle.solid,
                width: 1.2,
                color: title == "Follow"
                    ? HexColor(primaryColor).withOpacity(.9)
                    : HexColor(primaryColor).withOpacity(.9)),
            borderRadius: BorderRadius.circular(7)),
        child: Center(
          child: AppText(
            text: title,
            color: HexColor(backgroundColor),
            size: 10,
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
}
