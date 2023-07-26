import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/notification_ware..dart';
import 'package:provider/provider.dart';

import '../../../services/controllers/chat_controller.dart';
import '../../../services/controllers/feed_post_controller.dart';
import '../../../services/controllers/user_profile_controller.dart';
import '../../../services/middleware/chat_ware.dart';
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

class _UsersProfileState extends State<UsersProfile>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    UserProfileWare stream = context.watch<UserProfileWare>();
    NotificationWare notify = context.watch<NotificationWare>();

    return Scaffold(
      backgroundColor: HexColor("#F5F2F9"),
      body: RefreshIndicator(
        onRefresh: () => getData(true),
        backgroundColor: HexColor(primaryColor),
        color: Colors.white,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: true,
              leading: BackButton(color: Colors.black),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                      notify.readAll ? SizedBox.shrink():  Positioned(
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
                                    text: notify.notifyData.length > 9
                                        ? "9+"
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
              expandedHeight: 370,
              flexibleSpace: FlexibleSpaceBar(
                background: stream.loadStatus2
                    ? const PublicLoader()
                    : const PublicProfileInfo(
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
                          child: AppText(
                            text: stream.publicUserProfileModel.aboutMe!,
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
                  : const PublicProfilePostGrid(),
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
    getData(false);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ChatWare chatWare = Provider.of<ChatWare>(context, listen: false);
      chatWare.isLoading(false);
    });
  }

  Future<void> getData(bool isRef) async {
    if (isRef) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        UserProfileWare user = Provider.of(context, listen: false);
        await UserProfileController.retrievPublicProfileController(
            context, widget.username);
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        UserProfileWare user = Provider.of(context, listen: false);
        if (user.publicUserProfileModel.username == null) {
          await UserProfileController.retrievPublicProfileController(
              context, widget.username);
        } else {
          if (user.publicUserProfileModel.username == widget.username) {
            return;
          } else {
            await UserProfileController.retrievPublicProfileController(
                context, widget.username);
          }
        }
      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
