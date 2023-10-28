import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/screens/userprofile/user_profile_screen.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/swipe_ware.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../../../model/swiped_user_model.dart';
import '../../../../../services/controllers/action_controller.dart';
import '../../../../../services/controllers/swipe_users_controller.dart';
import '../../../../../services/middleware/action_ware.dart';
import '../../../../../services/middleware/chat_ware.dart';
import '../../../../../services/middleware/gift_ware.dart';
import '../../../../uiproviders/screen/card_provider.dart';
import '../../../../widgets/filter_address_modal.dart';
import '../../../../widgets/snack_msg.dart';
import '../../../userprofile/testing_profile.dart';
import '../../diamond/balance/diamond_balance_screen.dart';
import '../../diamond/diamond_modal/buy_modal.dart';
import '../../diamond/diamond_modal/give_modal.dart';
import '../../profile/profileextras/not_mine_buttons.dart';

class TinderCard extends StatefulWidget {
  final List<SwipedUser> users;
  const TinderCard({super.key, required this.users});

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  bool show = false;

  // List<String> _urlImages = [
  //   "https://images.pexels.com/photos/3992656/pexels-photo-3992656.png?cs=srgb&dl=pexels-kebs-visuals-3992656.jpg&fm=jpg"
  //       "https://img.freepik.com/free-photo/portrait-dark-skinned-cheerful-woman-with-curly-hair-touches-chin-gently-laughs-happily-enjoys-day-off-feels-happy-enthusiastic-hears-something-positive-wears-casual-blue-turtleneck_273609-43443.jpg?w=2000",
  //   "https://media.istockphoto.com/id/1369508766/photo/beautiful-successful-latin-woman-smiling.jpg?b=1&s=170667a&w=0&k=20&c=owOOPDbI6VOp1xYA4smdTNSHxjcJGRtGfVXx24g6J4c=",
  //   "https://img.freepik.com/free-photo/happiness-wellbeing-confidence-concept-cheerful-attractive-african-american-woman-curly-haircut-cross-arms-chest-self-assured-powerful-pose-smiling-determined-wear-yellow-sweater_176420-35063.jpg?w=2000",
  //   "https://images.unsplash.com/photo-1599842057874-37393e9342df?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mjh8fGdpcmx8ZW58MHx8MHx8&w=1000&q=80",
  //   "https://guardian.ng/wp-content/uploads/2016/12/adi.jpg",
  //   "https://media.istockphoto.com/id/1347431090/photo/fit-woman-standing-outdoors-after-a-late-afternoon-trail-run.jpg?b=1&s=170667a&w=0&k=20&c=6g2hGmKckPzapXNLHWGRMCpPMJidJVsutxU-XrsIjBU="
  // ];
  int indexer = 0;
  @override
  void initState() {
    super.initState();
    Future.forEach(
        widget.users,
        (element) => _swipeItems.add(SwipeItem(
            content: Content(
              text: element.username == null ? "" : element.username!,
            ),
            likeAction: () async {
              //  print(widget.users[indexer].id!.toString());
              // print(widget.users[indexer].username!.toString());
              ActionWare action =
                  Provider.of<ActionWare>(context, listen: false);

              final int newIndex = indexer;

              SharedPreferences pref = await SharedPreferences.getInstance();
              if (!action.followIds.contains(widget.users[newIndex].id)) {
                if (widget.users[newIndex].username ==
                    pref.getString(userNameKey)) {
                  //  print("cant follow yoou");
                } else {
                  // ignore: use_build_context_synchronously
                  followAction(
                    context,
                    widget.users[newIndex].id!,
                    widget.users[newIndex].username!,
                  );
                  // ignore: use_build_context_synchronously

                  // ignore: use_build_context_synchronously
                  // showToast2(context,
                  //     "You just followed ${widget.users[newIndex].username}",
                  //     isError: false);
                }
              } else {
                ///print("can not follow your self");
              }
            },
            nopeAction: () {
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text("Nope"),
              //   duration: Duration(milliseconds: 500),
              // ));
            },
            superlikeAction: () {
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text("Superliked "),
              //   duration: Duration(milliseconds: 500),
              // ));
            },
            onSlideUpdate: (SlideRegion? region) async {
              if (region != null) {
                if (region.index == 1) {
                  setState(() {
                    show = true;
                  });
                } else {
                  setState(() {
                    show = false;
                  });
                }
              } else {
                setState(() {
                  show = false;
                });
              }
            })));

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ActionWare stream = context.watch<ActionWare>();
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
    ChatWare myChat = context.watch<ChatWare>();
    return Column(
      children: [
        SizedBox(
          height: height * 0.62,
          child: SwipeCards(
            matchEngine: _matchEngine!,
            itemBuilder: (BuildContext context, int index) {
              return buildCard(
                  context,
                  widget.users[index].profilephoto == null
                      ? "https://t4.ftcdn.net/jpg/04/00/24/31/360_F_400243185_BOxON3h9avMUX10RsDkt3pJ8iQx72kS3.jpg"
                      : widget.users[index].profilephoto!,
                  widget.users[index].username == null
                      ? ""
                      : widget.users[index].username!,
                  widget.users[index].id!);
            },
            onStackFinished: () async {
              setState(() {
                _swipeItems.clear();
                Future.forEach(
                    widget.users,
                    (element) => _swipeItems.add(SwipeItem(
                        content: Content(
                          text: element.username ?? "",
                        ),
                        likeAction: () async {
                          //if (tapped) return;
                          //   print(widget.users[indexer].id!.toString());
                          //  print(widget.users[indexer].username!.toString());
                          ActionWare action =
                              Provider.of<ActionWare>(context, listen: false);

                          final int newIndex = indexer;

                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          if (!action.followIds
                              .contains(widget.users[newIndex].id)) {
                            if (widget.users[newIndex].username ==
                                pref.getString(userNameKey)) {
                              //   print("cant follow yoou");
                            } else {
                              // ignore: use_build_context_synchronously
                              followAction(
                                context,
                                widget.users[newIndex].id!,
                                widget.users[newIndex].username!,
                              );
                              // ignore: use_build_context_synchronously

                              // ignore: use_build_context_synchronously
                              // showToast2(context,
                              //     "You just followed ${widget.users[newIndex].username}",
                              //     isError: false);
                              // setState(() {
                              //   tapped = false;
                              // });
                            }
                          } else {
                            //   print("can not follow your self");
                          }

                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text("Liked"),
                          //   duration: Duration(milliseconds: 500),
                          // ));
                        },
                        nopeAction: () {
                          //  print("nopr");
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text("Nope"),
                          //   duration: Duration(milliseconds: 500),
                          // ));
                        },
                        superlikeAction: () {
                          //  print("super");
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text("Superliked "),
                          //   duration: Duration(milliseconds: 500),
                          // ));
                        },
                        onSlideUpdate: (SlideRegion? region) async {
                          //  if(region.name)
                          if (region != null) {
                            if (region.index == 1) {
                              setState(() {
                                show = true;
                              });
                            } else {
                              setState(() {
                                show = false;
                              });
                            }
                          } else {
                            setState(() {
                              show = false;
                            });
                          }
                        })));

                _matchEngine = MatchEngine(swipeItems: _swipeItems);
              });
              setState(() {
                indexer = 0;
              });
              SwipeWare swipe = Provider.of<SwipeWare>(context, listen: false);
              if (swipe.filterName == "Women") {
                await SwipeController.retrievSwipeController(
                    context, "female", swipe.country, swipe.state, swipe.city);
              } else if (swipe.filterName == "Men") {
                await SwipeController.retrievSwipeController(
                    context, "male", swipe.country, swipe.state, swipe.city);
              } else {
                await SwipeController.retrievSwipeController(
                    context,
                    swipe.filterName.toLowerCase(),
                    swipe.country,
                    swipe.state,
                    swipe.city);
              }

              // _matchEngine!.currentItem!.resetMatch();
              //    _matchEngine!.cycleMatch();
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text("Stack Finished"),
              //   duration: Duration(milliseconds: 500),
              // ));
            },
            itemChanged: (SwipeItem item, int index) {
              setState(() {
                indexer = index;
                tapped = false;
              });
              // print("item: ${item.content.text}, index: ${this.index}");
            },
            upSwipeAllowed: true,
            fillSpace: true,
          ),
        ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences pref =
                                await SharedPreferences.getInstance();
                            if (pref.getString(userNameKey) ==
                                widget.users[indexer].username!) {
                              // ignore: use_build_context_synchronously
                              showToast2(context, "This is your page",
                                  isError: true);
                            } else {
                              if (widget.users[indexer].username == null) {
                                return;
                              }
                              // ignore: use_build_context_synchronously
                              PageRouting.pushToPage(
                                  context,
                                  TestProfile(
                                    username: widget.users[indexer].username!,
                                    extended: false,
                                    page: "swipe",
                                  ));
                            }
                          },
                          child: Container(
                            height: 20,
                            constraints:
                                BoxConstraints(maxWidth: 250, minHeight: 10),
                            //     color: Colors.amber,
                            child: Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(maxWidth: 250),
                                  child: RichText(
                                      maxLines: 1,
                                      overflow: TextOverflow.visible,
                                      text: TextSpan(
                                          text:
                                              widget.users[indexer].username ??
                                                  "",
                                          style: GoogleFonts.leagueSpartan(
                                            color: HexColor(darkColor),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "",
                                              style: GoogleFonts.leagueSpartan(
                                                  color: HexColor("#C0C0C0"),
                                                  fontSize: 20),
                                            )
                                          ])),
                                ),

                                widget.users[indexer].verified == 1 &&
                                        widget.users[indexer].activePlan != sub
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
                              constraints: BoxConstraints(maxWidth: 200),
                              child: AppText(
                                text:
                                    "${widget.users[indexer].country ?? ""}, ${widget.users[indexer].state ?? ""}, ${widget.users[indexer].city ?? ""} ",
                                size: 14,
                                fontWeight: FontWeight.w500,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              AppText(
                                text: "Suggested account",
                                size: 12,
                                fontWeight: FontWeight.w500,
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
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => filterAdressModals(context),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: HexColor(primaryColor),
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.filter_list_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ))
      ],
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
    ActionWare action = Provider.of<ActionWare>(context, listen: false);
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
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: const Alignment(-0.3, 0),
                        image: CachedNetworkImageProvider(image),
                        fit: BoxFit.cover)),
              ),
              show && username == widget.users[indexer].username
                  ? Align(
                      alignment: Alignment.topCenter,
                      child:
                          SvgPicture.asset("assets/icon/slide_following.svg"),
                    )
                  : const SizedBox.shrink()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              stream.followIds.contains(id)
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            height: height,
                            width: width,
                            child: Card(
                              color: Colors.transparent,
                              shadowColor: HexColor(primaryColor),
                              elevation: 20,
                              child: ProfileActionButtonNotThisUsers(
                                icon: "assets/icon/follow.svg",
                                isSwipe: true,
                                onClick: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();

                                  await animateButton(0.0, true).whenComplete(
                                      () => mounted
                                          ? _matchEngine!.currentItem!.like()
                                          : null);
                                  mounted ? animateButton(60.0, false) : null;

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
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        height: height,
                        width: width,
                        child: Card(
                          color: Colors.transparent,
                          shadowColor: HexColor(primaryColor),
                          elevation: 20,
                          child: ProfileActionButtonNotThisUsers(
                            icon: "assets/icon/diamond.svg",
                            isSwipe: true,
                            onClick: () async {
                              if (int.tryParse(GiftWare.instance.gift.value.data
                                      .toString())! <
                                  50) {
                                buyDiamondsModal(
                                    context, GiftWare.instance.rate.value.data);
                              } else {
                                giveDiamondsModal(context, username);
                              }
                            },
                            color: null,
                          ),
                        ),
                      )),
                ),
              )
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
