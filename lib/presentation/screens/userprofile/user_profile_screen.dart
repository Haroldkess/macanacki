import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../../services/controllers/feed_post_controller.dart';
import '../../../services/controllers/user_profile_controller.dart';
import '../../../services/middleware/feed_post_ware.dart';
import '../../../services/middleware/user_profile_ware.dart';
import '../../allNavigation.dart';
import '../../constants/colors.dart';
import '../../widgets/app_bar.dart';
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

class _UsersProfileState extends State<UsersProfile> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    UserProfileWare stream = context.watch<UserProfileWare>();

    return Scaffold(
      backgroundColor: HexColor("#F5F2F9"),
      body: RefreshIndicator(
        onRefresh: () => getData(),
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
              flexibleSpace: FlexibleSpaceBar(
                background: stream.loadStatus2
                    ? const PublicLoader()
                    : const PublicProfileInfo(
                        isMine: false,
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: stream.loadStatus2
                  ? const ProfilePostGridLoader()
                  : const PublicProfilePostGrid(),
            )
          ],
        ),
      ),
    );

    // Scaffold(
    //   appBar: AppHeader(color: HexColor(backgroundColor)),
    //   backgroundColor: HexColor("#F5F2F9"),
    //   body: SizedBox(
    //     height: height,
    //     child: SingleChildScrollView(
    //       child: Column(
    //         children: [
    //           const ProfileInfo(
    //             isMine: false,
    //           ),
    //           const SizedBox(
    //             height: 20,
    //           ),
    //           SizedBox(
    //               height: height * 200, child: const ProfilePostGridLoader())
    //         ],
    //       ),
    //     ),
    //   ),
    // );
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
    getData();
  }

  Future<void> getData() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await UserProfileController.retrievPublicProfileController(
          context, widget.username);
    });
  }
}
