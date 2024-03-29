import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../../model/feed_post_model.dart';
import '../../../services/controllers/action_controller.dart';
import '../../../services/middleware/action_ware.dart';
import '../../../services/temps/temps_id.dart';
import '../../allNavigation.dart';
import '../../constants/colors.dart';
import '../../screens/home/profile/profile_screen.dart';
import '../../screens/userprofile/user_profile_screen.dart';
import '../../uiproviders/screen/tab_provider.dart';
import '../hexagon_avatar.dart';
import '../text.dart';

class FollowSection extends StatefulWidget {
  final FeedPost data;
  String page;
  final List<String> media;
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
    var w = 30.0;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: width * 0.7),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      TabProvider action =
                          Provider.of<TabProvider>(context, listen: false);
                      if (widget.data.media!.length > 1) {
                        for (var i = 0; i < widget.data.media!.length; i++) {
                          if (widget.data.media![i].contains(".mp4")) {
                            if (action.controller != null) {
                              if (action.controller!.value.isInitialized) {
                                action.controller!.pause();
                              }
                            }
                            // widget.controller!.pause();
                          }
                        }
                      } else {
                        if (widget.data.media!.first.contains(".mp4")) {
                          widget.controller!.pause();
                        }
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
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            HexagonWidget.pointy(
                              width: w,
                              elevation: 2.0,
                              color: Colors.white,
                              cornerRadius: 2.0,
                              child: AspectRatio(
                                aspectRatio: HexagonType.POINTY.ratio,
                         
                              ),
                            ),
                            HexagonAvatar(
                              url: widget.data.user!.profilephoto!,
                              w: w,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5.5,
                        ),
                        Row(
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 100),
                              child: AppText(
                                text: widget.data.user!.username!,
                                size: 15,
                                fontWeight: FontWeight.w700,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                color: HexColor(backgroundColor),
                              ),
                            ),
                            widget.data.user!.verified == 0 ||
                                    widget.data.user!.verified == null
                                ? const SizedBox.shrink()
                                : SvgPicture.asset("assets/icon/badge.svg",
                                    height: 13, width: 13)
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
                    child: SingleChildScrollView(
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
                                color:
                                    HexColor(backgroundColor).withOpacity(0.9),
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
                  ),
                ],
              ),
            ),
            SizedBox(
              height: widget.data.user!.gender == "Business" ? 10 : 0,
            ),
            SizedBox(
              height: widget.data.user!.gender == "Business" &&
                      widget.data.btnLink != null &&
                      widget.data.button != null
                  ? 40
                  : 10,
            )
          ],
        ),
      ),
    );
  }



}
