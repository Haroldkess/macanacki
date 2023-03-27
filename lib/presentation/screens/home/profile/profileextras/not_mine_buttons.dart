import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/profile/edit_profile.dart';
import 'package:makanaki/presentation/screens/home/profile/profileextras/profile_action_buttons.dart';
import 'package:makanaki/presentation/screens/home/settings/settings_screen.dart';
import 'package:makanaki/presentation/screens/userprofile/followers_following.dart';
import 'package:provider/provider.dart';

import '../../../../../model/search_user_model.dart';
import '../../../../../services/controllers/action_controller.dart';
import '../../../../../services/middleware/action_ware.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../widgets/text.dart';

class ProfileActionButtonNotThisUsers extends StatelessWidget {
  final String icon;
  VoidCallback onClick;
  String color;
  bool isSwipe;

  ProfileActionButtonNotThisUsers(
      {super.key,
      required this.icon,
      required this.onClick,
      required this.color, required this.isSwipe});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),
          //set border radius more than 50% of height and width to make circle
        ),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              icon,
              height: isSwipe ?  30 : null,
              width:  isSwipe ?  30 : null,
              color: HexColor(color),
            ),
          ),
        ),
      ),
    );
  }
}

class UserProfileActions extends StatelessWidget {
  const UserProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    ActionWare stream = context.watch<ActionWare>();
    UserProfileWare data = context.watch<UserProfileWare>();
    return Container(
      width: width * 0.7,
      height: height * 0.25,
      //  color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => PageRouting.pushToPage(context, const EditProfile()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileActionButtonNotThisUsers(
                  icon: "assets/icon/userheart.svg",
                  isSwipe: false,
                  onClick: () {},
                  color: "#FFC1D6",
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  //color: Colors.amber,
                  child: AppText(
                    text: "Match",
                    fontWeight: FontWeight.w400,
                    size: 12,
                    color: HexColor("#797979"),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              print("dfdd");
              await followAction(context, data.publicUserProfileModel.id!,
                  data.publicUserProfileModel.username!);
            },
            child: AnimatedContainer(
              duration: Duration(seconds: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ProfileActionButtonNotThisUsers(
                    icon: "assets/icon/follow.svg",
                     isSwipe: false,
                    onClick: () async {
                      await followAction(
                        context,
                        data.publicUserProfileModel.id!,
                        data.publicUserProfileModel.username!,
                      );
                    },
                    color: !stream.followIds
                            .contains(data.publicUserProfileModel.id)
                        ? "#F94C84"
                        : "#FFC1D6",
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AnimatedContainer(
                    width: 70,
                    alignment: Alignment.center,
                    //color: Colors.amber,
                    duration: Duration(seconds: 2),

                    child: !stream.followIds
                            .contains(data.publicUserProfileModel.id)
                        ? AppText(
                            text: "Follow",
                            fontWeight: FontWeight.w400,
                            size: 12,
                            color: HexColor("#797979"),
                          )
                        : AppText(
                            text: "Unfollow",
                            fontWeight: FontWeight.w400,
                            size: 12,
                            color: HexColor("#797979"),
                          ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileActionButtonNotThisUsers(
                   isSwipe: false,
                  icon: "assets/icon/userchat.svg",
                  onClick: () {},
                  color: "#FFC1D6",
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  //color: Colors.amber,
                  child: AppText(
                    text: "Message",
                    fontWeight: FontWeight.w400,
                    size: 12,
                    color: HexColor("#797979"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> followAction(
      BuildContext context, int id, String username) async {
    ActionWare provide = Provider.of<ActionWare>(context, listen: false);

    //provide.addFollowId(id);
    await ActionController.followOrUnFollowController(context, username, id);
  }
}
