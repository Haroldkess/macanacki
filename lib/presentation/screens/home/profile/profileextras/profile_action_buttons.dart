import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/operations_ext.dart';
import 'package:macanacki/presentation/screens/home/profile/createpost/create_post_screen.dart';
import 'package:macanacki/presentation/screens/home/profile/edit_profile.dart';
import 'package:macanacki/presentation/screens/home/settings/settings_screen.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/text.dart';
import '../createpost/audio/create_audio_screen.dart';

class ProfileActionButton extends StatelessWidget {
  final String icon;
  VoidCallback onClick;
  String color;
  ProfileActionButton(
      {super.key,
      required this.icon,
      required this.onClick,
      required this.color});

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
            padding: EdgeInsets.all(icon == "assets/icon/post.svg" ? 11 : 8.0),
            child: SvgPicture.asset(
              icon,
              color: HexColor(color),
            ),
          ),
        ),
      ),
    );
  }
}

class AllProfileActions extends StatelessWidget {
  final bool isMine;
  const AllProfileActions({super.key, required this.isMine});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    UserProfileWare stream = context.watch<UserProfileWare>();
    return Container(
      width: 220,
      height: 80,
      //color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () => PageRouting.pushToPage(
                context,
                EditProfile(
                  aboutMe: stream.userProfileModel.aboutMe,
                  phone: stream.userProfileModel.phone,
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProfileActionButton(
                  icon: "assets/icon/edit.svg",
                  onClick: () => PageRouting.pushToPage(
                      context,
                      EditProfile(
                        aboutMe: stream.userProfileModel.aboutMe,
                        phone: stream.userProfileModel.phone,
                      )),
                  color: "#C0C0C0",
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  //color: Colors.amber,
                  child: AppText(
                    text: "Edit",
                    fontWeight: FontWeight.w400,
                    size: 10,
                    color: HexColor("#797979"),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              _showActionSheet(context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ProfileActionButton(
                  icon: "assets/icon/post.svg",
                  onClick: () {
                    _showActionSheet(context);
                  },
                  color: "#F94C84",
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  //color: Colors.amber,
                  child: AppText(
                    text: "Post",
                    fontWeight: FontWeight.w400,
                    size: 10,
                    color: HexColor("#797979"),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // PageRouting.pushToPage(context, const SettingsScreen());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProfileActionButton(
                  icon: "assets/icon/setting.svg",
                  onClick: () {
                    // PageRouting.pushToPage(context, const SettingsScreen())
                  },
                  color: "#C0C0C0",
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 50,
                  alignment: Alignment.center,
                  //color: Colors.amber,
                  child: AppText(
                    text: "Settings",
                    fontWeight: FontWeight.w400,
                    size: 10,
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

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            //isDefaultAction: true,
            onPressed: () {
              //Navigator.pop(context);
              OperationsExt.pickForPost(
                context,
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.image_search_outlined,
                  color: HexColor(primaryColor),
                ),
                SizedBox(width: 10),
                AppText(
                  text: "Post Images",
                  fontWeight: FontWeight.w400,
                  size: 18,
                  color: HexColor("#797979"),
                ),
              ],
            ),
          ),
          // CupertinoActionSheetAction(
          //   onPressed: () {
          //     //Navigator.pop(context);
          //     OperationsExt.pickVideoForPost(context);
          //   },
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.videocam_outlined,
          //         color: HexColor(primaryColor),
          //       ),
          //       SizedBox(width: 10),
          //       AppText(
          //         text: "Post Videos",
          //         fontWeight: FontWeight.w400,
          //         size: 18,
          //         color: HexColor("#797979"),
          //       ),
          //     ],
          //   ),
          // ),
          CupertinoActionSheetAction(
            onPressed: () {
              //Navigator.pop(context);

              PageRouting.pushToPage(context, const AudioScreen());
              // Operations.pickAudio(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.audiotrack_outlined,
                  color: HexColor(primaryColor),
                ),
                SizedBox(width: 10),
                AppText(
                  text: "   Post Audio",
                  fontWeight: FontWeight.w400,
                  size: 18,
                  color: HexColor("#797979"),
                ),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as delete or exit and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: AppText(
              text: "Cancel",
              fontWeight: FontWeight.w400,
              size: 18,
              color: HexColor(primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
