import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/uiproviders/screen/tab_provider.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/notification_ware..dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../services/controllers/chat_controller.dart';
import '../../../services/controllers/feed_post_controller.dart';
import '../../../services/controllers/user_profile_controller.dart';
import '../../../services/middleware/chat_ware.dart';
import '../../../services/middleware/feed_post_ware.dart';
import '../../../services/middleware/gift_ware.dart';
import '../../../services/middleware/user_profile_ware.dart';
import '../../../services/middleware/video/video_ware.dart';
import '../../allNavigation.dart';
import '../../constants/colors.dart';
import '../../widgets/app_bar.dart';
import '../home/diamond/diamond_modal/buy_modal.dart';
import '../home/diamond/diamond_modal/give_modal.dart';
import '../home/profile/profileextras/profile_info.dart';
import '../home/profile/profileextras/profile_post_grid.dart';
import '../notification/notification_screen.dart';
import 'extras/public_profile_info.dart';

class UsersProfile extends StatefulWidget {
  final String username;
  const UsersProfile({super.key, required this.username});

  @override
  State<UsersProfile> createState() => _UsersProfileState();
}

class _UsersProfileState extends State<UsersProfile>
    with SingleTickerProviderStateMixin {
  bool showMore = false;
  int seeMoreVal = 100;
  TabController? _tabController;
  // String myUsername = "";
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  final ScrollController _controller = ScrollController();
  late UserProfileWare stream;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final List<String> _tabs = ["others", "audio"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      UserProfileWare stream =
          Provider.of<UserProfileWare>(context, listen: false);
      stream.disposeAutoScroll();
      stream.initializePagingController();
      getData(true);
      _controller.addListener(() {
        if (_controller.position.atEdge) {
          bool isTop = _controller.position.pixels == 0;
          if (isTop) {
            //  print("PARENT IS AT THE TOP");
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (mounted) {
                scrolNotifyPublic.instance.changeTabOne(true);
                scrolNotifyPublic.instance.changeTabTwo(true);
              }
            });
          } else {
            // print("PARENT IS AT THE BOTTOM");
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (mounted) {
                scrolNotifyPublic.instance.changeTabOne(false);
                scrolNotifyPublic.instance.changeTabTwo(false);
                // setState(() {

                //   physc = false;
                // });
              }
            });
          }
        } else if (_controller.position.pixels >
            (_controller.position.maxScrollExtent - 25)) {
          print("WE HERE SOME PIXELS BEFORE END");
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              scrolNotifyPublic.instance.changeTabOne(false);
              scrolNotifyPublic.instance.changeTabTwo(false);
              // setState(() {

              //   physc = false;
              // });
            }
          });
        }
      });

      // Listening to scroll event
      // _controller.addListener(() {
      //   if (_controller.position.atEdge) {
      //     bool isTop = _controller.position.pixels == 0;
      //     if (isTop) {
      //       print('At the top');
      //     } else {
      //       print('At the bottom');

      //       // Add new page
      //       // Add scrollController listener
      //       EasyDebounce.debounce(
      //           'myx-debouncer',
      //           const Duration(milliseconds: 500),
      //           () async => await stream.getUserPublicPostFromApi(
      //               username: widget.username));

      //       // print(pageKey);
      //       // print("Inside page key");
      //     }
      //   }
      // });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ChatWare chatWare = Provider.of<ChatWare>(context, listen: false);
      chatWare.isLoading(false);
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: HexColor(backgroundColor)));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      try {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          VideoWareHome.instance.pauseAnyVideo();
        });
      } catch (e) {}
    });
  }

  Future<void> _onRefresh() async {
    stream = Provider.of<UserProfileWare>(context, listen: false);
    await getData(true);
    stream.disposeAutoScroll();
    stream.pagingController.refresh();
    stream.pagingController2.refresh();
    // monitor network fetch
    //   await Future.delayed(Duration(milliseconds: 1000));
    // await _getUserPost(true);
    // if failed,use refreshFailed()
    // _refreshController.refreshCompleted();
  }

  static const _indicatorSize = 150.0;

  /// Whether to render check mark instead of spinner
  bool _renderCompleteState = false;

  ScrollDirection prevScrollDirection = ScrollDirection.idle;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    stream = context.watch<UserProfileWare>();
    NotificationWare notify = context.watch<NotificationWare>();

    return SafeArea(
      child: Scaffold(

        backgroundColor: HexColor("#F5F2F9"),
        body: CustomRefreshIndicator(
          onStateChanged: (change) {
            /// set [_renderCompleteState] to true when controller.state become completed
            if (change.didChange(to: IndicatorState.complete)) {
              setState(() {
                _renderCompleteState = true;
              });

              /// set [_renderCompleteState] to false when controller.state become idle
            } else if (change.didChange(to: IndicatorState.idle)) {
              setState(() {
                _renderCompleteState = false;
              });
            }
          },
          builder: (
            BuildContext context,
            Widget child,
            IndicatorController controller,
          ) {
            return Stack(
              children: <Widget>[
                AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget? _) {
                    if (controller.scrollingDirection ==
                            ScrollDirection.reverse &&
                        prevScrollDirection == ScrollDirection.forward) {
                      // controller.stopDrag();
                    }

                    prevScrollDirection = controller.scrollingDirection;

                    final containerHeight = controller.value * _indicatorSize;

                    return Container(
                      alignment: Alignment.center,
                      height: containerHeight,
                      child: OverflowBox(
                        maxHeight: 40,
                        minHeight: 40,
                        maxWidth: 40,
                        minWidth: 40,
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          alignment: Alignment.center,
                          child: _renderCompleteState
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.white),
                                    value: controller.isDragging ||
                                            controller.isArmed
                                        ? controller.value.clamp(0.0, 1.0)
                                        : null,
                                  ),
                                ),
                          decoration: BoxDecoration(
                            color: _renderCompleteState
                                ? Colors.greenAccent
                                : HexColor(primaryColor),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(0.0, controller.value * _indicatorSize),
                      child: child,
                    );
                  },
                  animation: controller,
                ),
              ],
            );
          },
          notificationPredicate: (notification) {
            // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
            return notification.depth == 0;
          },
          onRefresh: () async {
            await _onRefresh();
          },
          child: ExtendedNestedScrollView(
            controller: _controller,

            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  leading: BackButton(color: Colors.black),
                  // title: Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     // myIcon("assets/icon/macanackiicon.svg", primaryColor, 16.52,
                  //     //     70, false),
                  //     InkWell(
                  //       onTap: () => PageRouting.pushToPage(
                  //           context, const NotificationScreen()),
                  //       child: Stack(
                  //         children: [
                  //           SvgPicture.asset(
                  //             "assets/icon/notification.svg",
                  //           ),
                  //           notify.readAll
                  //               ? SizedBox.shrink()
                  //               : Positioned(
                  //                   right: 5,
                  //                   child: Align(
                  //                     alignment: Alignment.topCenter,
                  //                     child: Container(
                  //                       height: 10,
                  //                       width: 10,
                  //                       decoration: const BoxDecoration(
                  //                           shape: BoxShape.circle,
                  //                           color: Colors.red),
                  //                       child: Padding(
                  //                         padding: const EdgeInsets.all(0.0),
                  //                         child: Center(
                  //                           child: AppText(
                  //                             text: notify.notifyData.length > 9
                  //                                 ? ""
                  //                                 : "",
                  //                             size: 8,
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 )
                  //         ],
                  //       ),

                  //       // myIcon("assets/icon/notification.svg", "#828282",
                  //       //     19.13, 17.31, true),
                  //     ),
                  //   ],
                  // ),
                  // floating: true,
                  pinned: true,
                  backgroundColor: HexColor("#F5F2F9"),
                  expandedHeight: 370,
                  flexibleSpace: FlexibleSpaceBar(
                    background: stream.loadStatus2
                        ? const PublicLoader()
                        : PublicProfileInfo(
                            isMine: false,
                          ),
                  ),
                ),
                stream.publicUserProfileModel.aboutMe != null
                    ? SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: showMore ? 3 : 2,
                                  text: TextSpan(
                                      text: stream.publicUserProfileModel
                                                      .aboutMe!.length >=
                                                  seeMoreVal &&
                                              showMore == false
                                          ? stream
                                              .publicUserProfileModel.aboutMe!
                                              .substring(0, seeMoreVal - 3)
                                          : stream
                                              .publicUserProfileModel.aboutMe!,
                                      style: GoogleFonts.leagueSpartan(
                                          textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: HexColor(darkColor)
                                            .withOpacity(0.6),
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 10,
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
                                        stream.publicUserProfileModel.aboutMe!
                                                    .length <
                                                seeMoreVal
                                            ? const TextSpan(text: "")
                                            : TextSpan(
                                                text: showMore
                                                    ? " "
                                                    : "...see more",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: HexColor(darkColor)
                                                      .withOpacity(0.6),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                recognizer: tapGestureRecognizer
                                                  ..onTap = () async {
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
                            )),
                          ],
                        ),
                      )
                    : const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProfileQuickLinks(
                        onClick: () {
                          // showToast2(context, "Feature coming soon");
                        },
                        name: "Block Account",
                        icon: "assets/icon/block.svg",
                        color: Colors.grey,
                        isVerified: false,
                      ),
                      ProfileQuickLinks(
                        onClick: () async {},
                        name: "report Account",
                        icon: "assets/icon/report.svg",
                        color: Colors.grey,
                        isVerified: false,
                      ),
                      ProfileQuickLinks(
                        onClick: () {
                          if (int.tryParse(GiftWare.instance.gift.value.data
                                  .toString())! <
                              50) {
                            buyDiamondsModal(
                                context, GiftWare.instance.rate.value.data);
                          } else {
                            giveDiamondsModal(context,
                                stream.publicUserProfileModel.username!);
                          }
                        },
                        name: "Give Diamond",
                        icon: "assets/icon/diamond.svg",
                        color: null,
                        isVerified: true,
                      )
                    ],
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ];
            },
            restorationId: 'Tab${_tabController!.index}',
            // innerScrollPositionKeyBuilder: () {
            //   return Key('Tab${_tabController.index}');
            // },

            pinnedHeaderSliverHeightBuilder: () {
              final double statusBarHeight = MediaQuery.of(context).padding.top;
              var pinnedHeaderHeight =
                  //statusBar height
                  statusBarHeight +
                      //pinned SliverAppBar height in header
                      kToolbarHeight;
              return pinnedHeaderHeight;
            },
            onlyOneScrollInBody: true,
            body: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.grey,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.grey,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
                  labelPadding: EdgeInsets.only(bottom: 10),
                  onTap: (index) {
                    FeedPostWare ind =
                        Provider.of<FeedPostWare>(context, listen: false);
                    ind.changeTabIndex(index);
                  },
                  tabs: _tabs
                      .map((String tab) => tab == "others"
                          ? Container(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                "assets/icon/vid.svg",
                                color: Colors.grey,
                              ))
                          : Container(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset("assets/icon/aud.svg",
                                  color: Colors.grey)))
                      .toList(),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _tabs.asMap().entries.map((entry) {
                      return entry.value == "others"
                          ? PublicProfilePostGrid(
                              ware: stream,
                              parentController: _controller,
                              tabKey: Key('Tab${entry.key}'),
                              tabName: entry.value,
                              username: widget.username,
                              isHome: 1,
                            )
                          : PublicProfilePostAudioGrid(
                              ware: stream,
                              parentController: _controller,
                              tabKey: Key('Tab${entry.key}'),
                              tabName: entry.value,
                              username: widget.username,
                              isHome: 1,
                            );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),

        // CustomScrollView(
        //   controller: _controller,
        //   slivers: [

        //     SliverToBoxAdapter(
        //       // child: stream.loadStatus2
        //       //     ? const ProfilePostGridLoader()
        //       //     : const PublicProfilePostGrid(),
        //       child: PublicProfilePostGrid(ware: stream),
        //     ),
        //     const SliverToBoxAdapter(
        //       child: SizedBox(height: 20),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Widget myIcon(String svgPath, String hexString, double height, double width,
      bool isNotification) {
    return Stack(
      children: [
        SvgPicture.asset(
          svgPath,
          height: height,
          width: width,
          color: HexColor(hexString),
        ),
        isNotification
            ? const Positioned(
                right: 2.0,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.red,
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  Future<void> getData(bool isRef) async {
    if (isRef) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        UserProfileWare user = Provider.of(context, listen: false);
        await UserProfileController.retrievPublicProfileController(
            context, widget.username);

        //Re-initializing pagingController
        user.disposeAutoScroll();
        user.initializePagingController();
        user.getUserPublicPostFromApi(username: widget.username);
        user.getUserPublicPostAudioFromApi(username: widget.username);
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        UserProfileWare user = Provider.of(context, listen: false);
        if (user.publicUserProfileModel.username == null) {
          user.getUserPublicPostFromApi(username: widget.username);
          user.getUserPublicPostAudioFromApi(username: widget.username);
          await UserProfileController.retrievPublicProfileController(
              context, widget.username);
          user.getUserPublicPostFromApi(username: widget.username);
          user.getUserPublicPostAudioFromApi(username: widget.username);
        } else {
          if (user.publicUserProfileModel.username == widget.username) {
            await UserProfileController.retrievPublicProfileController(
                context, widget.username);
            user.getUserPublicPostFromApi(username: widget.username);
            user.getUserPublicPostAudioFromApi(username: widget.username);

            return;
          } else {
            user.getUserPublicPostFromApi(username: widget.username);
            user.getUserPublicPostAudioFromApi(username: widget.username);
            await UserProfileController.retrievPublicProfileController(
                context, widget.username);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emitter("Disposinggggggggggggggggg");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stream.disposeAutoScroll();
    });
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ProfileQuickLinks extends StatelessWidget {
  String name;
  String icon;
  VoidCallback onClick;
  Color? color;
  bool isVerified;
  ProfileQuickLinks(
      {super.key,
      required this.name,
      required this.icon,
      required this.color,
      required this.isVerified,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onClick,
      child: Card(
        //  elevation: 10,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(80),
        //   //set border radius more than 50% of height and width to make circle
        // ),
        child: Container(
          height: 61,
          width: size.width * 0.28,
          decoration: BoxDecoration(
              color: HexColor(backgroundColor),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(icon, height: 19, width: 19, color: color),
              const SizedBox(
                height: 10,
              ),
              AppText(
                text: name,
                size: 12,
                fontWeight: FontWeight.w400,
                color: HexColor("#828282"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
