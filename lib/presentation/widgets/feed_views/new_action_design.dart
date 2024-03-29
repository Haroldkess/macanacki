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
import 'package:macanacki/preload/preload_controller.dart';
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
import '../../uiproviders/buttons/button_state.dart';
import '../../uiproviders/screen/comment_provider.dart';
import '../../uiproviders/screen/tab_provider.dart';
import '../ads_display.dart';
import '../comment_modal.dart';
import '../debug_emitter.dart';
import '../hexagon_avatar.dart';
import '../text.dart';
import 'package:macanacki/services/middleware/video/video_ware.dart';
import 'package:flutter/services.dart';
import 'package:readmore/readmore.dart';

class NewDesignTest extends StatefulWidget {
  final FeedPost data;
  String page;
  final List<String> media;
  ApiVideoPlayerController? controller;
  bool isHome;
  bool showComment;
  bool extended;
  bool? showDesign;
  NewDesignTest(
      {super.key,
      required this.isHome,
      required this.data,
      required this.page,
      required this.media,
      this.showDesign,
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
  double height = 60;
  bool show = false;
  bool tapped = false;
  double width = 60;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    ActionWare stream = context.watch<ActionWare>();
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
    StoreComment comment = context.watch<StoreComment>();
    return Padding(
      padding: const EdgeInsets.only(left: 0.0),
      child: Container(
        height: showMore
            ? height / 1.4
            : widget.data.user!.gender == "Business" &&
                    widget.data.btnLink != null &&
                    widget.data.button != null
                ? 130
                : widget.data.btnLink != null && widget.data.button != null
                    ? 130
                    : widget.data.description!.isEmpty
                        ? 70
                        : 124,
        width: width,
        decoration: BoxDecoration(
          //    backgroundBlendMode: BlendMode.colorDodge,
          // color: Colors.amber,
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
                            // TabProvider action = Provider.of<TabProvider>(
                            //     context,
                            //     listen: false);

                            if (widget.data.user!.username! ==
                                user.userProfileModel.username) {
                            } else {
                              if (widget.isHome == false) {
                                return;
                              }

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
                                  GestureDetector(
                                    onTap: () {
                                      if (widget.data.user!.username! ==
                                          user.userProfileModel.username) {
                                        return;
                                      }
                                      PageRouting.pushToPage(
                                          context,
                                          TestProfile(
                                            username:
                                                widget.data.user!.username!,
                                            extended: true,
                                            page: widget.page,
                                          ));
                                      try {
                                        PreloadController.to
                                            .pausePreloadById(widget.data.id!);
                                      } catch (e) {
                                        emitter(e.toString());
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          constraints: const BoxConstraints(
                                            maxWidth: 139,
                                          ),
                                          //   color: Colors.amber,
                                          child: AppText(
                                            text: widget.data.user!.username!,

                                            maxLines: 1,
                                            overflow: widget.data.user!
                                                        .username!.length >
                                                    20
                                                ? TextOverflow.ellipsis
                                                : TextOverflow.ellipsis,
                                            //color: textWhite,
                                            color: textWhite,
                                            size: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(width: 4),
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
                                        child: widget.data.promoted == "yes"
                                            ? AppText(
                                                text: 'Sponsored Ad',
                                                color: textPrimary,
                                                size: 10,
                                                fontWeight: FontWeight.w600,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : AppText(
                                                text: Operations.feedTimes(
                                                    widget.data.createdAt!),
                                                size: 12,
                                                fontWeight: FontWeight.w400,
                                                maxLines: 1,
                                                color: textPrimary,
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
              widget.data.description!.isEmpty
                  ? SizedBox.shrink()
                  : Padding(
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
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(.8),
                                        // decorationStyle:
                                        //     TextDecorationStyle.solid,
                                        fontSize: 12,
                                        fontFamily: '',
                                      )),
                                      recognizer: tapGestureRecognizer
                                        ..onTap = () async {
                                          print("object");
                                          if (showMore) {
                                            setState(() {
                                              showMore = false;
                                            });
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              ButtonState.instance.tapClose();
                                            });
                                          } else {
                                            setState(() {
                                              showMore = true;
                                            });

                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              ButtonState.instance.tapOpen();
                                            });
                                          }
                                        },
                                      children: [
                                        widget.data.description!.length <
                                                seeMoreVal
                                            ? const TextSpan(text: "")
                                            : TextSpan(
                                                text: showMore
                                                    ? " less"
                                                    : " see more",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white
                                                      .withOpacity(.8),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                recognizer: tapGestureRecognizer
                                                  ..onTap = () async {
                                                    //    print("object");
                                                    if (showMore) {
                                                      setState(() {
                                                        showMore = false;
                                                      });
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        ButtonState.instance
                                                            .tapClose();
                                                      });
                                                    } else {
                                                      setState(() {
                                                        showMore = true;
                                                      });
                                                      WidgetsBinding.instance
                                                          .addPostFrameCallback(
                                                              (_) {
                                                        ButtonState.instance
                                                            .tapOpen();
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
                height: widget.data.user!.gender == "Business" ? 0 : 0,
              ),
              SizedBox(
                height:
                    widget.data.btnLink != null && widget.data.button != null
                        ? 50
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
        // Container(
        //                       height: 40,
        //                       width: 40,
        //                       decoration: BoxDecoration(
        //                           color: backgroundSecondary,
        //                           shape: BoxShape.circle),
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: SvgPicture.asset(
        //                           "assets/icon/filter.svg",
        //                         ),
        //                       ),
        //                     ),
        Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundSecondary,
                border: Border.all(color: Colors.transparent, width: 0.5)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: SvgPicture.asset(
                    svgPath,
                    height: 18,
                    width: 18,
                    color: textPrimary,
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
              color: textWhite,
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
          circleColor: CircleColor(start: Colors.blue, end: secondaryColor),
          bubblesColor: BubblesColor(
              dotPrimaryColor: Colors.grey,
              dotSecondaryColor: Colors.blue,
              dotThirdColor: Colors.yellow,
              dotLastColor: secondaryColor),
          countPostion: CountPostion.right,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          likeCountPadding: const EdgeInsets.only(
            top: 0,
            left: 5,
            bottom: 0,
          ),
          onTap: (isLiked) async {
            try {
              await HapticFeedback.heavyImpact();
            } catch (e) {}
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
          likeCount: int.tryParse(likes.toString()),
          likeBuilder: (bool isLiked) {
            return isLiked
                ? Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: backgroundSecondary,
                        border:
                            Border.all(color: Colors.transparent, width: 0.5)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.favorite,
                          color: secondaryColor,
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
                        color: backgroundSecondary,
                        border:
                            Border.all(color: Colors.transparent, width: 0.5)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          "assets/icon/hert.svg",
                          color: textPrimary,
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
  bool? showFollow;
  VideoUser(
      {super.key,
      required this.data,
      required this.page,
      required this.media,
      this.isAudio,
      this.isVideo,
      this.showFollow,
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
  final preloadController = PreloadController.to;
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
  double height = 60;
  bool show = false;
  bool tapped = false;
  double width = 60;
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
                                //  height: 120,
                                constraints:
                                    BoxConstraints(maxWidth: width * 0.75),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Row(
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                // alignment: Alignment.topCenter,
                                                children: [
                                                  Column(
                                                    children: [
                                                      DpAvatar(
                                                        url: widget.data.user!
                                                            .profilephoto!,
                                                        w: w,
                                                      ),
                                                    ],
                                                  ),
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
                                                      InkWell(
                                                        onTap: () {
                                                          //  print(" ******** Marto XX 1");
                                                          TabProvider action =
                                                              Provider.of<
                                                                      TabProvider>(
                                                                  context,
                                                                  listen:
                                                                      false);

                                                          if (widget.isAudio ==
                                                              true) {
                                                            if (widget.player !=
                                                                null) {
                                                              try {
                                                                widget.player!
                                                                    .pause();
                                                              } catch (e) {
                                                                emitter(e
                                                                    .toString());
                                                              }
                                                            }
                                                          }

                                                          // if (widget.isVideo == true) {
                                                          //   widget.controller!.pause();
                                                          // }

                                                          if (widget.data.user!
                                                                  .username! ==
                                                              user.userProfileModel
                                                                  .username) {
                                                            // action.pageController!.animateToPage(
                                                            //   4,
                                                            //   duration: const Duration(milliseconds: 1),
                                                            //   curve: Curves.easeIn,
                                                            // );
                                                          } else {
                                                            if (widget.isHome ==
                                                                false) {
                                                              return;
                                                            }
                                                            // try {
                                                            //   WidgetsBinding.instance
                                                            //       .addPostFrameCallback((timeStamp) {
                                                            //     VideoWareHome.instance.pauseAnyVideo();
                                                            //   });
                                                            // } catch (e) {}
                                                            PageRouting
                                                                .pushToPage(
                                                                    context,
                                                                    TestProfile(
                                                                      username: widget
                                                                          .data
                                                                          .user!
                                                                          .username!,
                                                                      extended:
                                                                          true,
                                                                      page: widget
                                                                          .page,
                                                                    ));
                                                            try {
                                                              preloadController
                                                                  .pausePreloadById(
                                                                      widget
                                                                          .data
                                                                          .id!);
                                                            } catch (e) {
                                                              emitter(
                                                                  e.toString());
                                                            }

                                                            print(
                                                                " ******** Marto XX 2");
                                                          }
                                                        },
                                                        child: Container(
                                                          constraints:
                                                              const BoxConstraints(
                                                            maxWidth: 139,
                                                          ),
                                                          //   color: Colors.amber,
                                                          child: AppText(
                                                            text: widget
                                                                .data
                                                                .user!
                                                                .username!,
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
                                                            color: textWhite,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 4),
                                                      widget.data.user!
                                                                      .verified ==
                                                                  1 &&
                                                              widget.data.user!
                                                                      .activePlan !=
                                                                  sub
                                                          ? SvgPicture.asset(
                                                              "assets/icon/badge.svg",
                                                              height: 13,
                                                              width: 13)
                                                          : const SizedBox
                                                              .shrink(),
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
                                                        child: widget.data
                                                                    .promoted ==
                                                                "yes"
                                                            ? AppText(
                                                                text:
                                                                    'Sponsored Ad',
                                                                color:
                                                                    textPrimary,
                                                                size: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )
                                                            : AppText(
                                                                text: Operations
                                                                    .feedTimes(widget
                                                                        .data
                                                                        .createdAt!),
                                                                size: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                maxLines: 1,
                                                                color:
                                                                    textPrimary,
                                                              ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: stream.followIds.contains(
                                                    widget.data.user!.id!)
                                                ? SizedBox.shrink()
                                                : user.userProfileModel
                                                            .username ==
                                                        widget
                                                            .data.user!.username
                                                    ? SizedBox.shrink()
                                                    : InkWell(
                                                        onTap: () async {
                                                          HapticFeedback
                                                              .heavyImpact();
                                                          followAction(
                                                            context,
                                                          );
                                                        },
                                                        child: CircleAvatar(
                                                          radius: 10,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            radius: 7,
                                                            child: SvgPicture
                                                                .asset(
                                                              "assets/icon/add_profile.svg",
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                          ),
                                        )
                                      ],
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
                                                  style: GoogleFonts.roboto(
                                                      textStyle: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: textPrimary,
                                                    decorationStyle:
                                                        TextDecorationStyle
                                                            .solid,
                                                    fontSize: 12,
                                                    fontFamily: '',
                                                  )),
                                                  recognizer:
                                                      tapGestureRecognizer
                                                        ..onTap = () async {
                                                          print(
                                                              "---------- Marto 222");
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
                                                                    print(
                                                                        "---------- Marto");
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
                                    widget.data.thumbnails!.isEmpty
                                        ? ""
                                        : widget.data.thumbnails!.first ?? ""),
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

  Future animateButton(double val, bool isFirst) async {
    if (isFirst) {
      setState(() {
        height = val;
        width = val;
        show = true;
        tapped = true;
      });

      await Future.delayed(Duration(seconds: 1));
    } else {
      setState(() {
        height = 60;
        width = 60;
        show = false;
        tapped = false;
      });
    }
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
