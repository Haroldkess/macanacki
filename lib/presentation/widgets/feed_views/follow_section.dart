import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/services/controllers/url_launch_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../model/feed_post_model.dart';
import '../../../services/controllers/action_controller.dart';
import '../../../services/middleware/action_ware.dart';
import '../../../services/temps/temps_id.dart';
import '../../allNavigation.dart';
import '../../constants/colors.dart';
import '../../screens/home/profile/profile_screen.dart';
import '../../screens/userprofile/user_profile_screen.dart';
import '../hexagon_avatar.dart';
import '../text.dart';

class FollowSection extends StatefulWidget {
  final FeedPost data;
  String page;
  final String media;
  VideoPlayerController? controller;
  FollowSection(
      {super.key,
      required this.data,
      required this.page,
      required this.media,
      this.controller});

  @override
  State<FollowSection> createState() => _FollowSectionState();
}

class _FollowSectionState extends State<FollowSection> {
  bool showMore = false;
  late SharedPreferences pref;
  String myUsername = "";
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    initPref();
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
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    //_checkIfLikedBefore();
    var w = (size.width - 4 * 1) / 14;
    ActionWare stream = context.watch<ActionWare>();
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Container(
        height: showMore
            ? null
            : widget.data.user!.gender == "Business"
                ? 119
                : 90,
        width: width * 0.77,
        // color: Colors.red,
        //  color: Colors.amber,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              // width: width * 0.7,
              constraints: BoxConstraints(maxWidth: width * 0.7),
              //  color: Colors.black,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HexagonAvatar(
                    url: widget.data.user!.profilephoto!,
                    w: w + 5,
                    onTap: () async {
                      if (widget.data.media!.contains(".mp4")) {
                        widget.controller!.pause();
                      }

                      if (widget.data.user!.username! ==
                          pref.getString(userNameKey)) {
                        PageRouting.pushToPage(context, const ProfileScreen());
                      } else {
                        PageRouting.pushToPage(
                            context,
                            UsersProfile(
                              username: widget.data.user!.username!,
                            ));
                      }
                    },
                  ),
                  const SizedBox(
                    width: 5.5,
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 130),
                    child: AppText(
                      text: widget.data.user!.username!,
                      size: 15,
                      fontWeight: FontWeight.w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: HexColor(backgroundColor),
                    ),
                  ),
                  const SizedBox(
                    width: 5.5,
                  ),
                  // Image.asset("assets/pic/verified.png"),
                  // const SizedBox(
                  //   width: 5.5,
                  // ),
                  myUsername == widget.data.user!.username!
                      ? const SizedBox.shrink()
                      : Expanded(
                          child: Row(
                            children: [
                              followButton(() async {
                                followAction(
                                  context,
                                );
                              },
                                  stream.followIds
                                          .contains(widget.data.user!.id!)
                                      ? "Following"
                                      : "Follow"),
                            ],
                          ),
                        ),
                  // const SizedBox(
                  //   width: 15.5,
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 48, top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    //  color: Colors.amber,
                    //   width: width * 0.5,
                    constraints: BoxConstraints(maxWidth: width * 0.49),
                    child: RichText(
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: showMore ? 50 : 2,
                        text: TextSpan(
                            text: widget.data.description!.length >= 50 &&
                                    showMore == false
                                ? widget.data.description!.substring(0, 47)
                                : widget.data.description!,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: HexColor(backgroundColor).withOpacity(0.9),
                            ),
                            children: [
                              widget.data.description!.length < 50
                                  ? const TextSpan(text: "")
                                  : TextSpan(
                                      text: showMore ? " less" : " see more",
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
                ],
              ),
            ),
            SizedBox(
              height: widget.data.user!.gender == "Business" ? 10 : 0,
            ),
            widget.data.user!.gender == "Business" &&
                    widget.data.btnLink != null &&
                    widget.data.button != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 5),
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
                                await UrlLaunchController.launchWebViewOrVC(
                                    Uri.parse(widget.data.btnLink!));
                              } else {
                                await UrlLaunchController.launchInWebViewOrVC(
                                    Uri.parse(widget.data.btnLink!));
                              }
                            },
                            child: Container(
                              height: 27,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: HexColor("#00B074")),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText(
                                      text: widget.data.button!,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      size: 13,
                                    ),
                                    SvgPicture.asset(
                                      "assets/icon/Send.svg",
                                      color: Colors.white,
                                      height: 15,
                                      width: 12,
                                    )
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
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget followButton(VoidCallback onTap, String title) {
    //  ActionWare stream = context.watch<ActionWare>();
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: 21,
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
            borderRadius: BorderRadius.circular(5)),
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
}
