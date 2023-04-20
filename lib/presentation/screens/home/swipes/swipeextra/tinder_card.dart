import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/screens/userprofile/user_profile_screen.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/middleware/swipe_ware.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../../../model/swiped_user_model.dart';
import '../../../../../services/controllers/action_controller.dart';
import '../../../../../services/controllers/swipe_users_controller.dart';
import '../../../../../services/middleware/action_ware.dart';
import '../../../../uiproviders/screen/card_provider.dart';
import '../../../../widgets/snack_msg.dart';
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ActionWare stream = context.watch<ActionWare>();
    ActionWare action = Provider.of<ActionWare>(context, listen: false);

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
                          text: element.username!,
                        ),
                        likeAction: () async {
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
                              showToast2(context,
                                  "You just followed ${widget.users[newIndex].username}",
                                  isError: false);
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
              await SwipeController.retrievSwipeController(context);

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    if (pref.getString(userNameKey) ==
                        widget.users[indexer].username!) {
                      // ignore: use_build_context_synchronously
                      showToast2(context, "This is your page", isError: true);
                    } else {
                      // ignore: use_build_context_synchronously
                      PageRouting.pushToPage(
                          context,
                          UsersProfile(
                              username: widget.users[indexer].username!));
                    }
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: RichText(
                            text: TextSpan(
                                text: "${widget.users[indexer].username}",
                                style: GoogleFonts.spartan(
                                  color: HexColor(darkColor),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                              TextSpan(
                                text: "",
                                style: GoogleFonts.spartan(
                                    color: HexColor("#C0C0C0"), fontSize: 20),
                              )
                            ])),
                      ),
                      // Image.asset(
                      //   "assets/pic/verified.png",
                      //   height: 27,
                      //   width: 27,
                      // )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 5,
                          backgroundColor: widget.users[indexer].mode == null ||
                                  widget.users[indexer].mode == "offline"
                              ? Colors.red
                              : HexColor("#00B074"),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        AppText(
                          text: "${widget.users[indexer].mode ?? "offline"}",
                          size: 12,
                          fontWeight: FontWeight.w500,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/icon/location.svg"),
                          const SizedBox(
                            width: 5,
                          ),
                          AppText(
                            text:
                                "${Numeral(widget.users[indexer].distance == null ? 0 : widget.users[indexer].distance!)} km away",
                            size: 12,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ))
      ],
    );
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
                        image: NetworkImage(image),
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
                        image: NetworkImage(image),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                      _matchEngine!.currentItem!.like();
                      if (username == pref.getString(userNameKey)) {
                        print("can n ot follow your self");
                      } else {
                        // ignore: use_build_context_synchronously
                        await followAction(
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
          )
        ],
      ),
    );
  }
}

Future<void> followAction(BuildContext context, int id, String username) async {
  await ActionController.followOrUnFollowController(context, username, id);
}

class Content {
  final String text;

  Content({
    required this.text,
  });
}
