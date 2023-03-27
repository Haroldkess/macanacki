import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/profile/profileextras/profile_info.dart';
import 'package:makanaki/presentation/screens/home/profile/profileextras/profile_post_grid.dart';
import 'package:makanaki/services/controllers/feed_post_controller.dart';
import 'package:provider/provider.dart';

import '../../../../services/middleware/feed_post_ware.dart';
import '../../../allNavigation.dart';
import '../../../uiproviders/screen/tab_provider.dart';
import '../../notification/notification_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    FeedPostWare stream = context.watch<FeedPostWare>();

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
                  myIcon("assets/icon/makanakiicon.svg", primaryColor, 16.52,
                      70, false),
                  InkWell(
                    onTap: () => PageRouting.pushToPage(
                        context, const NotificationScreen()),
                    child: myIcon("assets/icon/notification.svg", "#828282",
                        19.13, 17.31, true),
                  ),
                ],
              ),
              // floating: true,
              pinned: true,
              backgroundColor: HexColor("#F5F2F9"),
              expandedHeight: height / 1.8,
              flexibleSpace: const FlexibleSpaceBar(
                background: ProfileInfo(
                  isMine: true,
                ),
              ),
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

    if (isRefreshed == false) {
      if (ware.profileFeedPosts.isNotEmpty) {
        return;
      }
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        await FeedPostController.getUserPostController(context);
      });
    } else {
      await FeedPostController.getUserPostController(context);
    }
  }
}
