// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/config/pay_ext.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/operations_ext.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/profile_info.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/profile_post_grid.dart';
import 'package:macanacki/presentation/screens/home/profile/promote_post/promote_screen.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:macanacki/services/controllers/feed_post_controller.dart';
import 'package:macanacki/services/controllers/user_profile_controller.dart';
import 'package:macanacki/services/middleware/notification_ware..dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../config/pay_wall.dart';
import '../../../../model/gender_model.dart';
import '../../../../services/controllers/plan_controller.dart';
import '../../../../services/middleware/feed_post_ware.dart';
import '../../../allNavigation.dart';
import '../../../constants/params.dart';
import '../../../operations.dart';
import '../../../uiproviders/screen/tab_provider.dart';
import '../../../widgets/debug_emitter.dart';
import '../../../widgets/dialogue.dart';
import '../../../widgets/drawer.dart';
import '../../notification/notification_screen.dart';
import '../../onboarding/business/business_info.dart';
import '../../onboarding/business/business_verification.dart';
import '../../onboarding/business/sub_plan.dart';
import '../diamond/balance/diamond_balance_screen.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  TabController? _tabController;

  bool showMore = false;
  int seeMoreVal = 100;
  // String myUsername = "";
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  final ScrollController _controller = ScrollController(keepScrollOffset: true);

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _onRefresh() async {
    await _getUserPost(true);
  }

  int _activeIndex = 0;

  final List<String> _tabs = ["others", "audio"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);
    _getUserPost(false);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      FeedPostWare stream = Provider.of<FeedPostWare>(context, listen: false);

      FeedPostWare streamAudio =
          Provider.of<FeedPostWare>(context, listen: false);

      stream.initializePagingController();

      _controller.addListener(() {
        if (_controller.position.atEdge) {
          bool isTop = _controller.position.pixels == 0;
          if (isTop) {
            //  print("PARENT IS AT THE TOP");
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (mounted) {
                scrolNotify.instance.changeTabOne(true);
                scrolNotify.instance.changeTabTwo(true);
              }
            });
          } else {
            // print("PARENT IS AT THE BOTTOM");
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (mounted) {
                scrolNotify.instance.changeTabOne(false);
                scrolNotify.instance.changeTabTwo(false);
                // setState(() {

                //   physc = false;
                // });
              }
            });
          }
        } else if (_controller.position.pixels >
            (_controller.position.maxScrollExtent - 30)) {
          // print("WE HERE SOME PIXELS BEFORE END");
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              scrolNotify.instance.changeTabOne(false);
              scrolNotify.instance.changeTabTwo(false);
              // setState(() {

              //   physc = false;
              // });
            }
          });
        }
      });

      if (stream.tabIndex == 0) {
        stream.getUserPostFromApi();
      } else {
        stream.getUserPostAudioFromApi();
      }

      // streamAudio.getUserPostAudioFromApi();
    });

    Operations.controlSystemColor();
  }

  @override
  void dispose() {
    _tabController!.dispose();

    super.dispose();
  }

  static const _indicatorSize = 150.0;

  /// Whether to render check mark instead of spinner
  bool _renderCompleteState = false;

  ScrollDirection prevScrollDirection = ScrollDirection.idle;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    FeedPostWare stream = context.watch<FeedPostWare>();
    FeedPostWareAudio audio = context.watch<FeedPostWareAudio>();
    NotificationWare notify = context.watch<NotificationWare>();

    UserProfileWare user = context.watch<UserProfileWare>();

    return SafeArea(
        child: Scaffold(
      key: key,
      backgroundColor: HexColor("#F5F2F9"),
      drawer: DrawerSide(
        scafKey: key,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          List<Package> verificationPackages = await PayExt.fetchPackagesFromOfferings(identifier: 'promotion');
          if(!context.mounted) return;
          await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: Colors.brown,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return FractionallySizedBox(
                    heightFactor: 0.95,
                    child: Paywall(
                      isOneTimePurchase: false,
                      showTermsOfUseAndPrivacyPolicy: true,
                      title: "Verification Packages",
                      description: "Unlock the full verification experience",
                      packages: verificationPackages,
                      onError: (String e){

                        showToast2(context, "Payment not verified try again", isError: true);
                        Navigator.pop(context);

                      },
                      onSucess: (){
                        //PaymentController.verifyOnServerExt(context, isBusiness, isPayOnly);
                      },

                    ),
                  );
                });
          },
          );
        },
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          //  PersistentNavController.instance.toggleHide();
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
            if (PersistentNavController.instance.hide.value == true) {
              PersistentNavController.instance.toggleHide();
            }
          });
        },
        child: CustomRefreshIndicator(
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
                  automaticallyImplyLeading: false,

                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () => key.currentState!.openDrawer(),
                          child: SvgPicture.asset(
                            "assets/icon/drawer.svg",
                            height: 15,
                            width: 20,
                          )),
                      // myIcon("assets/icon/macanackiicon.svg", primaryColor, 16.52,
                      //     70, false),
                      InkWell(
                        onTap: () => PageRouting.pushToPage(
                            context, const NotificationScreen()),
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              "assets/icon/notification.svg",
                            ),
                            notify.readAll
                                ? SizedBox.shrink()
                                : Positioned(
                                    right: 5,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Center(
                                            child: AppText(
                                              text: notify.notifyData.length > 9
                                                  ? ""
                                                  : "",
                                              size: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),

                        // myIcon("assets/icon/notification.svg", "#828282",
                        //     19.13, 17.31, true),
                      ),
                    ],
                  ),
                  // floating: true,
                  pinned: true,

                  backgroundColor: HexColor("#F5F2F9"),
                  expandedHeight: 370,
                  foregroundColor: Colors.amber,
                  flexibleSpace: const FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: ProfileInfo(
                      isMine: true,
                    ),
                  ),
                ),
                user.userProfileModel.aboutMe != null
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
                                      text: user.userProfileModel.aboutMe!
                                                      .length >=
                                                  seeMoreVal &&
                                              showMore == false
                                          ? user.userProfileModel.aboutMe!
                                              .substring(0, seeMoreVal - 3)
                                          : user.userProfileModel.aboutMe!,
                                      style: GoogleFonts.leagueSpartan(
                                          textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: HexColor(darkColor)
                                            .withOpacity(0.6),
                                        decorationStyle:
                                            TextDecorationStyle.solid,
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
                                        user.userProfileModel.aboutMe!.length <
                                                seeMoreVal
                                            ? const TextSpan(text: "")
                                            : TextSpan(
                                                text: showMore
                                                    ? ""
                                                    : "...see more",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: HexColor(darkColor)
                                                      .withOpacity(0.6),
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
                          PageRouting.pushToPage(
                              context, const DiamondBalanceScreen());
                        },
                        name: "Account balance",
                        icon: "assets/icon/diamond.svg",
                        color: null,
                        isVerified: false,
                      ),
                      ProfileQuickLinks(
                        onClick: () async {
                          PageRouting.pushToPage(
                              context, const PromoteScreen());
                        },
                        name: "Promote post",
                        icon: "assets/icon/promote.svg",
                        color: Colors.grey,
                        isVerified: false,
                      ),
                      ProfileQuickLinks(
                        onClick: () => Operations.verifyOperation(context),
                        name: "Verify account",
                        icon: "assets/icon/badge.svg",
                        color: HexColor("#0597FF"),
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
                          ? ProfilePostGrid(
                              ware: stream,
                              parentController: _controller,
                              tabKey: Key('Tab${entry.key}'),
                              tabName: entry.value,
                              isHome: 1,
                            )
                          : ProfilePostAudioGrid(
                              ware: stream,
                              parentController: _controller,
                              tabKey: Key('Tab${entry.key}'),
                              tabName: entry.value,
                              isHome: 1,
                            );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
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
                top: -1,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.red,
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  _getUserPost(bool isRefreshed) async {
    // Initializing Post State
    FeedPostWare stream = Provider.of<FeedPostWare>(context, listen: false);
    FeedPostWare streamAudio =
        Provider.of<FeedPostWare>(context, listen: false);

    // Initializing ShaaredPrefernec and
    SharedPreferences pref = await SharedPreferences.getInstance();
    // bool isFirstTime = pref.getBool(isFirstTimeKey)!;

    if (isRefreshed == false) {
      if (stream.profileFeedPosts.isNotEmpty) {
      } else {
        await FeedPostController.getUserPostController(context);
      }
      if (stream.profileFeedPostsAudio.isNotEmpty) {
      } else {
        await FeedPostController.getUserPostAudioController(context);
      }
    } else {
      stream.disposeAutoScroll();
      // streamAudio.disposeAutoScroll();
      stream.pagingController.refresh();
      stream.pagingController2.refresh();
      //streamAudio.pagingController.refresh();
      await UserProfileController.retrievProfileController(context, false);
      await FeedPostController.getUserPostController(context);
      await FeedPostController.getUserPostAudioController(context);
    }
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
              SvgPicture.asset(icon,
                  height: name == "Promote post" || isVerified ? 22 : 19,
                  width: name == "Promote post" || isVerified ? 22 : 19,
                  color: isVerified ? null : color),
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
