import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/operations.dart';
import 'package:makanaki/presentation/screens/home/profile/createpost/create_post_screen.dart';
import 'package:makanaki/presentation/screens/home/profile/edit_profile.dart';
import 'package:makanaki/presentation/screens/home/settings/settings_screen.dart';

import '../../../../widgets/text.dart';

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
            padding: const EdgeInsets.all(8.0),
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
                ProfileActionButton(
                  icon: "assets/icon/edit.svg",
                  onClick: () =>
                      PageRouting.pushToPage(context, const EditProfile()),
                  color: "#C0C0C0",
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  //color: Colors.amber,
                  child: AppText(
                    text: "Edit",
                    fontWeight: FontWeight.w400,
                    size: 12,
                    color: HexColor("#797979"),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () =>
                Operations.pickForPost(context,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ProfileActionButton(
                  icon: "assets/icon/post.svg",
                  onClick: () =>
                      Operations.pickForPost(context),
                  color: "#F94C84",
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  //color: Colors.amber,
                  child: AppText(
                    text: "Post",
                    fontWeight: FontWeight.w400,
                    size: 12,
                    color: HexColor("#797979"),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () =>
                PageRouting.pushToPage(context, const SettingsScreen()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfileActionButton(
                  icon: "assets/icon/setting.svg",
                  onClick: () =>
                      PageRouting.pushToPage(context, const SettingsScreen()),
                  color: "#C0C0C0",
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  //color: Colors.amber,
                  child: AppText(
                    text: "Settings",
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
}
