// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/profile/profileextras/profile_info.dart';
import 'package:makanaki/presentation/screens/home/profile/profileextras/profile_post_grid.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/feed_post_controller.dart';
import 'package:makanaki/services/controllers/user_profile_controller.dart';
import 'package:makanaki/services/middleware/notification_ware..dart';
import 'package:makanaki/services/middleware/user_profile_ware.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/middleware/feed_post_ware.dart';
import '../../../allNavigation.dart';
import '../../../uiproviders/screen/tab_provider.dart';
import '../../notification/notification_screen.dart';

class ProfileScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scafKey;
  const ProfileScreen({super.key, this.scafKey});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    FeedPostWare stream = context.watch<FeedPostWare>();
    NotificationWare notify = context.watch<NotificationWare>();

    UserProfileWare user = context.watch<UserProfileWare>();

    return Scaffold(
      backgroundColor: HexColor("#F5F2F9"),
      body: RefreshIndicator(
        onRefresh: () => _getUserPost(true),
        backgroundColor: HexColor(primaryColor),
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,

              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () => widget.scafKey!.currentState!.openDrawer(),
                      child: SvgPicture.asset(
                        "assets/icon/drawer.svg",
                        height: 15,
                        width: 20,
                      )),
                  // myIcon("assets/icon/makanakiicon.svg", primaryColor, 16.52,
                  //     70, false),
                  InkWell(
                    onTap: () => PageRouting.pushToPage(
                        context, const NotificationScreen()),
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          "assets/icon/notification.svg",
                        ),
                        Positioned(
                          right: 0,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 15,
                              width: 20,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Center(
                                  child: AppText(
                                    text: notify.notifyData.length > 99
                                        ? "99+"
                                        : notify.notifyData.length.toString(),
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
              expandedHeight: height * .6,
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
                          child: AppText(
                            text: user.userProfileModel.aboutMe!,
                            align: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                            size: 12,
                          ),
                        )),
                      ],
                    ),
                  )
                : const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
            SliverToBoxAdapter(
              child: stream.loadStatus2
                  ? const ProfilePostGridLoader()
                  : const ProfilePostGrid(),
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
  }

  @override
  void dispose() {
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   TabProvider provide = Provider.of<TabProvider>(context, listen: false);
    //   provide.changeIndex(0);
    // });
    super.dispose();
  }

  _getUserPost(bool isRefreshed) async {
    FeedPostWare ware = Provider.of<FeedPostWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool isFirstTime = pref.getBool(isFirstTimeKey)!;

    if (isRefreshed == false && isFirstTime == false) {
      if (ware.profileFeedPosts.isNotEmpty) {
        return;
      }

      await FeedPostController.getUserPostController(context);
    } else {
      await UserProfileController.retrievProfileController(context, false);
      await FeedPostController.getUserPostController(context);
    }
  }
}
