import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/follow_list.dart';
import 'package:macanacki/presentation/screens/userprofile/extras/follow_search.dart';
import 'package:macanacki/presentation/screens/userprofile/extras/list_follows.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/action_controller.dart';
import 'package:macanacki/services/middleware/action_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ext_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

import '../../uiproviders/screen/find_people_provider.dart';

class PublicUserFollowerFollowingScreen extends StatefulWidget {
  final String title;
  final bool isFollowing;

  const PublicUserFollowerFollowingScreen({
    super.key,
    required this.title,
    required this.isFollowing,
  });

  @override
  State<PublicUserFollowerFollowingScreen> createState() =>
      _PublicUserFollowerFollowingScreenState();
}

class _PublicUserFollowerFollowingScreenState
    extends State<PublicUserFollowerFollowingScreen> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    // if (widget.isFollowing) {

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      UserProfileWare user =
          Provider.of<UserProfileWare>(context, listen: false);

      user.getPublicUserProfileFromApi(widget.title);
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      FindPeopleProvider search =
          Provider.of<FindPeopleProvider>(context, listen: false);
      search.search("");
      UserProfileExtWare ext =
          Provider.of<UserProfileExtWare>(context, listen: false);
      ext.updateUsername(widget.title);
    });
    // } else {
    //   SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
    //     await ActionController.retrievAllUserFollowersController(context);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    ActionWare stream = context.watch<ActionWare>();
    UserProfileWare user = context.watch<UserProfileWare>();
    UserProfileExtWare ware = context.watch<UserProfileExtWare>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundSecondary,
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size(0, 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, bottom: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    FollowSearch(
                        controller: controller,
                        onChanged: (val) {
                          ware.updateRequestMode("search");
                          ware.updateSearch(val);
                          if (widget.isFollowing == 'Following') {
                            ware.getUserPublicFollowingsFromApi();
                          } else {
                            ware.getUserPublicFollowersFromApi();
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
          title: AppText(
            text: widget.isFollowing
                ? "Following ${widget.title}"
                : "${widget.title} Followers",
            color: textWhite,
            size: 14,
            fontWeight: FontWeight.w700,
          ),
          centerTitle: true,
          leading: BackButton(color: textWhite),
          elevation: 0,
          backgroundColor: HexColor(backgroundColor),
          toolbarHeight: 110,
        ),
        body: PublicFollowFollowingList(
            data: widget.isFollowing
                ? user.publicUserProfileModel.followings ?? []
                : user.publicUserProfileModel.followers ?? [],
            what: widget.isFollowing ? "Following" : "Followers",
            ware: ware),
      ),
    );
  }
}
