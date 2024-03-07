import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/model/feed_post_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/screens/userprofile/user_profile_screen.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/feed_post_controller.dart';
import 'package:macanacki/services/middleware/swipe_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../../../model/royalty_model.dart';
import '../../../../../model/swiped_user_model.dart';
import '../../../../../services/controllers/action_controller.dart';
import '../../../../../services/controllers/swipe_users_controller.dart';
import '../../../../../services/middleware/action_ware.dart';
import '../../../../../services/middleware/chat_ware.dart';
import '../../../../../services/middleware/feed_post_ware.dart';
import '../../../../../services/middleware/gift_ware.dart';
import '../../../../uiproviders/screen/card_provider.dart';
import '../../../../uiproviders/screen/tab_provider.dart';
import '../../../../widgets/dialogue.dart';
import '../../../../widgets/filter_address_modal.dart';
import '../../../../widgets/loader.dart';
import '../../../../widgets/snack_msg.dart';
import '../../../userprofile/testing_profile.dart';
import '../../diamond/balance/diamond_balance_screen.dart';
import '../../diamond/diamond_modal/buy_modal.dart';
import '../../diamond/diamond_modal/give_modal.dart';
import '../../profile/profileextras/not_mine_buttons.dart';

class ProfileAds extends StatefulWidget {
  final RoyalData post;
  const ProfileAds({super.key, required this.post});

  @override
  State<ProfileAds> createState() => _ProfileAdsState();
}

class _ProfileAdsState extends State<ProfileAds> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];

  bool show = false;

  int indexer = 0;
  @override
  void initState() {
    super.initState();
  }

  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ActionWare stream = context.watch<ActionWare>();
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
    ChatWare myChat = context.watch<ChatWare>();
    FeedPostWare feed = context.watch<FeedPostWare>();
    return feed.loadRoyal
        ? Loader(
            color: textPrimary,
          )
        : SizedBox(
            height: Get.height,
            width: Get.width,
            child: feed.royalUser.isSuperAdmin == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icon/royalty.svg",
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AppText(
                          text: "No Royalty found!!",
                          color: textPrimary,
                        ),
                      ],
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        // SafeArea(
                        //   child: Row(
                        //     children: [
                        //       IconButton(
                        //           onPressed: () => PageRouting.popToPage(context),
                        //           icon: Icon(
                        //             Icons.arrow_back_ios,
                        //             color: textPrimary,
                        //           )),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 10),
                        SizedBox(
                            height: height * 0.62,
                            child: buildCard(
                                context,
                                widget.post.profilephoto == null
                                    ? "https://t4.ftcdn.net/jpg/04/00/24/31/360_F_400243185_BOxON3h9avMUX10RsDkt3pJ8iQx72kS3.jpg"
                                    : widget.post.profilephoto!,
                                widget.post.username == null
                                    ? ""
                                    : widget.post.username!,
                                widget.post.id!)),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            SharedPreferences pref =
                                                await SharedPreferences
                                                    .getInstance();
                                            if (pref.getString(userNameKey) ==
                                                widget.post.username!) {
                                              // ignore: use_build_context_synchronously
                                              showToast2(
                                                  context, "This is your page",
                                                  isError: true);
                                            } else {
                                              if (widget.post.username ==
                                                  null) {
                                                return;
                                              }
                                              // ignore: use_build_context_synchronously
                                              PageRouting.pushToPage(
                                                  context,
                                                  TestProfile(
                                                    username:
                                                        widget.post.username!,
                                                    extended: false,
                                                    page: "swipe",
                                                  ));
                                            }
                                          },
                                          child: Container(
                                            height: 20,
                                            constraints: BoxConstraints(
                                                maxWidth: 250, minHeight: 10),
                                            //     color: Colors.amber,
                                            child: Row(
                                              children: [
                                                Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth: 250),
                                                  child: RichText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.visible,
                                                      text: TextSpan(
                                                          text: widget.post
                                                                  .username ??
                                                              "",
                                                          style: GoogleFonts
                                                              .roboto(
                                                            color: textWhite,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: "",
                                                              style: GoogleFonts
                                                                  .leagueSpartan(
                                                                      color: HexColor(
                                                                          "#C0C0C0"),
                                                                      fontSize:
                                                                          20),
                                                            )
                                                          ])),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),

                                                widget.post.verified == 1 &&
                                                        widget.post
                                                                .activePlan !=
                                                            sub
                                                    ? SvgPicture.asset(
                                                        "assets/icon/badge.svg",
                                                        height: 15,
                                                        width: 15,
                                                      )
                                                    : const SizedBox.shrink()
                                                // Image.asset(
                                                //   "assets/pic/verified.png",
                                                //   height: 27,
                                                //   width: 27,
                                                // )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icon/location.svg",
                                              color: Colors.green,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              constraints:
                                                  BoxConstraints(maxWidth: 200),
                                              child: AppText(
                                                text:
                                                    "${widget.post.country ?? ""}, ${widget.post.state ?? ""}, ${widget.post.city ?? ""} ",
                                                size: 14,
                                                fontWeight: FontWeight.w500,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                color: textPrimary,
                                              ),
                                            )
                                            // CircleAvatar(
                                            //   radius: 5,
                                            //   backgroundColor: myChat.allSocketUsers
                                            //           .where((element) =>
                                            //               element.userId.toString() ==
                                            //               widget.users[indexer].id.toString())
                                            //           .toList()
                                            //           .isEmpty
                                            //       ? Colors.red
                                            //       : HexColor("#00B074"),
                                            // ),
                                            // const SizedBox(
                                            //   width: 5,
                                            // ),
                                            // AppText(
                                            //   text: myChat.allSocketUsers
                                            //           .where((element) =>
                                            //               element.userId.toString() ==
                                            //               widget.users[indexer].id.toString())
                                            //           .toList()
                                            //           .isEmpty
                                            //       ? "offline"
                                            //       : "online",
                                            //   size: 12,
                                            //   fontWeight: FontWeight.w500,
                                            // )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: [
                                              AppText(
                                                text: widget.post.gender
                                                            ?.toLowerCase() ==
                                                        "female"
                                                    ? "Queen Of Macanacki kingdom"
                                                    : widget.post.gender
                                                                ?.toLowerCase() ==
                                                            "male"
                                                        ? "King Of Macanacki kingdom"
                                                        : "Not royalty",
                                                size: 12,
                                                fontWeight: FontWeight.w500,
                                                color: textPrimary,
                                              )
                                              // SvgPicture.asset("assets/icon/location.svg"),
                                              // const SizedBox(
                                              //   width: 5,
                                              // ),
                                              // AppText(
                                              //   text:
                                              //       "${Numeral(widget.users[indexer].distance == null ? 0 : widget.users[indexer].distance!)} km away",
                                              //   size: 12,
                                              //   fontWeight: FontWeight.w500,
                                              // )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
          );
  }

  double height = 60;
  double width = 60;

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

  Widget buildCard(
      BuildContext context, String image, String username, int id) {
    ActionWare stream = context.watch<ActionWare>();
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    TabProvider tab = context.watch<TabProvider>();
    FeedPostWare feed = context.watch<FeedPostWare>();
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: const Alignment(-0.3, 0),
                        image: CachedNetworkImageProvider(image),
                        fit: BoxFit.cover)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      // height: Get.height,
                      // width: Get.width,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                Shimmer.fromColors(
                                    baseColor: HexColor(backgroundColor),
                                    highlightColor: Colors.grey.withOpacity(.2),
                                    period: Duration(seconds: 1),
                                    child: Container(
                                      color: HexColor(backgroundColor),
                                    )),
                        errorWidget: (context, url, error) =>
                            CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url,
                                  downloadProgress) =>
                              Shimmer.fromColors(
                                  baseColor: HexColor(backgroundColor),
                                  highlightColor: Colors.grey.withOpacity(.2),
                                  period: Duration(seconds: 1),
                                  child: Container(
                                    color: HexColor(backgroundColor),
                                  )),
                          errorWidget: (context, url, error) =>
                              CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url,
                                          downloadProgress) =>
                                      Shimmer.fromColors(
                                          baseColor: HexColor(backgroundColor),
                                          highlightColor:
                                              Colors.grey.withOpacity(.2),
                                          period: Duration(seconds: 1),
                                          child: Container(
                                            color: HexColor(backgroundColor),
                                          )),
                                  errorWidget: (context, url, error) =>
                                      SizedBox()),
                        ),
                      ),
                    ),
                    Container(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: const Alignment(-0.3, 0),
                        image: CachedNetworkImageProvider(image),
                        fit: BoxFit.cover)),
              ),
              show && username == widget.post.username
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: SvgPicture.asset(
                        "assets/icon/slide_following.svg",
                        color: const Color.fromARGB(255, 22, 44, 23),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      //  duration: Duration(seconds: 1),
                      height: height,
                      width: width,
                      child: Card(
                        color: Colors.transparent,
                        shadowColor: backgroundSecondary,
                        elevation: 10,
                        child: tab.filterNameHome.toLowerCase() == "queen"
                            ? ProfileActionButtonNotThisUsers(
                                icon: "assets/icon/prev.svg",
                                isSwipe: true,
                                onClick: () async {
                                  if (tab.filterNameHome == "King") {
                                    tab.changeFilterHome("Queen");
                                    FeedPostController.getRoyaltyController(
                                        context, "queen");
                                  } else {
                                    tab.changeFilterHome("King");
                                    FeedPostController.getRoyaltyController(
                                        context, "king");
                                  }
                                },
                                color: primaryColor,
                              )
                            : ProfileActionButtonNotThisUsers(
                                icon: "assets/icon/follow.svg",
                                isSwipe: true,
                                onClick: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  try {
                                    await HapticFeedback.heavyImpact();
                                  } catch (e) {}

                                  // await animateButton(0.0, true)
                                  //     .whenComplete(() => null);
                                  // mounted ? animateButton(60.0, false) : null;

                                  if (username == pref.getString(userNameKey)) {
                                    emitter("can n ot follow your self");
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    followAction(
                                      context,
                                      id,
                                      username,
                                    );
                                  }
                                },
                                color: stream.followIds.contains(id)
                                    ? "#00A300"
                                    : primaryColor,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              ((tab.filterNameHome.toLowerCase() == "queen") &&
                          (user.userProfileModel.gender!.toLowerCase() ==
                                  "Business" ||
                              user.userProfileModel.gender!.toLowerCase() ==
                                  "male")) ||
                      ((tab.filterNameHome.toLowerCase() == "king") &&
                          (user.userProfileModel.gender!.toLowerCase() ==
                                  "Business" ||
                              user.userProfileModel.gender!.toLowerCase() ==
                                  "female"))
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            //  duration: Duration(seconds: 1),
                            height: height,
                            width: width,
                            child: Card(
                              color: Colors.transparent,
                              shadowColor: backgroundSecondary,
                              elevation: 10,
                              child: feed.loadNg || feed.loadNotNg
                                  ? Loader(color: textPrimary)
                                  : ProfileActionButtonNotThisUsers(
                                      icon: "assets/icon/royalty.svg",
                                      isSwipe: true,
                                      onClick: () async {
                                        try {
                                          await HapticFeedback.heavyImpact();
                                        } catch (e) {}

                                        // ignore: use_build_context_synchronously
                                        Get.dialog(CrownDialogue(
                                            svg: "royalty",
                                            title: "De-Throne",
                                            message:
                                                "Get crowned the new ${widget.post.gender!.toLowerCase() == "female" ? "Queen" : "King"} of Macanacki kingdom",
                                            confirmText: user.userProfileModel
                                                        .country!
                                                        .toLowerCase() ==
                                                    "Nigeria".toLowerCase()
                                                ? "Yes"
                                                : "- 50 diamonds",
                                            cancelText: "Go back",
                                            context: context,
                                            feed: feed,
                                            onPressedCancel: () {
                                              // UrlLaunchController.launchWebViewOrVC(
                                              //     Uri.parse(
                                              //         publicUserProfileModel.website!));
                                              Get.back();
                                            },
                                            onPressed: () async {
                                              if (user.userProfileModel.country!
                                                      .toLowerCase() ==
                                                  "Nigeria".toLowerCase()) {
                                                FeedPostController
                                                    .deThroneNgController(
                                                        context);
                                              } else {
                                                FeedPostController
                                                    .deThroneController(
                                                        context);
                                              }

                                              Get.back();
                                            }));

                                        // await animateButton(0.0, true)
                                        //     .whenComplete(() => null);
                                        // mounted ? animateButton(60.0, false) : null;

                                        // if (username == pref.getString(userNameKey)) {
                                        //   emitter("can n ot follow your self");
                                        // } else {
                                        //   // ignore: use_build_context_synchronously
                                        //   followAction(
                                        //     context,
                                        //     id,
                                        //     username,
                                        //   );
                                        // }
                                      },
                                      color: primaryColor,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      //  duration: Duration(seconds: 1),
                      height: height,
                      width: width,
                      child: Card(
                        color: Colors.transparent,
                        shadowColor: backgroundSecondary,
                        elevation: 10,
                        child: tab.filterNameHome.toLowerCase() == "queen"
                            ? ProfileActionButtonNotThisUsers(
                                icon: "assets/icon/follow.svg",
                                isSwipe: true,
                                onClick: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  try {
                                    await HapticFeedback.heavyImpact();
                                  } catch (e) {}

                                  // await animateButton(0.0, true)
                                  //     .whenComplete(() => null);
                                  // mounted ? animateButton(60.0, false) : null;

                                  if (username == pref.getString(userNameKey)) {
                                    emitter("can n ot follow your self");
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    followAction(
                                      context,
                                      id,
                                      username,
                                    );
                                  }
                                },
                                color: stream.followIds.contains(id)
                                    ? "#00A300"
                                    : primaryColor,
                              )
                            : ProfileActionButtonNotThisUsers(
                                icon: "assets/icon/next.svg",
                                isSwipe: true,
                                onClick: () async {
                                  if (tab.filterNameHome == "King") {
                                    tab.changeFilterHome("Queen");
                                    FeedPostController.getRoyaltyController(
                                        context, "queen");
                                  } else {
                                    tab.changeFilterHome("King");
                                    FeedPostController.getRoyaltyController(
                                        context, "king");
                                  }
                                },
                                color: primaryColor,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Future<void> followAction(context, int id, String username) async {
  ActionController.followOrUnFollowController(context, username, id);
//  JustFollow.follow(username, id);
}

class Content {
  final String text;

  Content({
    required this.text,
  });
}
