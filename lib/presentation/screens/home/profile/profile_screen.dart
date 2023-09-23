// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
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
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  bool showMore = false;
  int seeMoreVal = 100;
  // String myUsername = "";
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    FeedPostWare stream = context.watch<FeedPostWare>();
    NotificationWare notify = context.watch<NotificationWare>();

    UserProfileWare user = context.watch<UserProfileWare>();

    return Scaffold(
      key: key,
      backgroundColor: HexColor("#F5F2F9"),
      drawer: DrawerSide(
        scafKey: key,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getUserPost(true);
        },
        backgroundColor: HexColor(primaryColor),
        color: Colors.white,
        child: CustomScrollView(
          controller: _controller,
          slivers: [
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
              // foregroundColor: Colors.amber,
              flexibleSpace: const FlexibleSpaceBar(
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
                                  text: user.userProfileModel.aboutMe!.length >=
                                              seeMoreVal &&
                                          showMore == false
                                      ? user.userProfileModel.aboutMe!
                                          .substring(0, seeMoreVal - 3)
                                      : user.userProfileModel.aboutMe!,
                                  style: GoogleFonts.leagueSpartan(
                                      textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: HexColor(darkColor).withOpacity(0.6),
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
                                    user.userProfileModel.aboutMe!.length <
                                            seeMoreVal
                                        ? const TextSpan(text: "")
                                        : TextSpan(
                                            text: showMore ? "" : "...see more",
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
                      // showToast2(context, "Feature coming soon");
                    },
                    name: "Switch Account",
                    icon: "assets/icon/switch.svg",
                    color: Colors.grey,
                    isVerified: false,
                  ),
                  ProfileQuickLinks(
                    onClick: () async {
                      PageRouting.pushToPage(context, const PromoteScreen());
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
            SliverToBoxAdapter(
              child: ProfilePostGrid(ware: stream),
            )
          ],
        ),
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

  @override
  void initState() {
    super.initState();

    _getUserPost(false);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      FeedPostWare stream = Provider.of<FeedPostWare>(context, listen: false);

      //Re-initializing pagingController
      stream.initializePagingController();

      _controller.addListener(() {
        if (_controller.position.atEdge) {
          bool isTop = _controller.position.pixels == 0;
          if (isTop) {
            print('At the top');
          } else {
            print('At the bottom');
            //
            EasyDebounce.debounce(
                'my-debouncer',
                const Duration(milliseconds: 500),
                () async => await stream.getUserPostFromApi());
            // print(pageKey);
            // print("Inside page key");
          }
        }
      });

      stream.getUserPostFromApi();
    });

    Operations.controlSystemColor();
  }

  @override
  void dispose() {
    // WidgetsBinding.instance
    //     .addPostFrameCallback((_) => s.disposeAutoScroll());

    super.dispose();
  }

  _getUserPost(bool isRefreshed) async {
    // Initializing Post State
    FeedPostWare stream = Provider.of<FeedPostWare>(context, listen: false);

    // Initializing ShaaredPrefernec and
    SharedPreferences pref = await SharedPreferences.getInstance();
    // bool isFirstTime = pref.getBool(isFirstTimeKey)!;

    if (isRefreshed == false) {
      if (stream.profileFeedPosts.isNotEmpty) {
        return;
      }

      await FeedPostController.getUserPostController(context);
    } else {
      stream.disposeAutoScroll();
      stream.pagingController.refresh();
      await UserProfileController.retrievProfileController(context, false);
      await FeedPostController.getUserPostController(context);
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
  Color color;
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
                  height: 22, width: 25, color: isVerified ? null : color),
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
