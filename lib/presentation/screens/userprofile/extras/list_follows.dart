import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/model/public_profile_model.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/home/profile/profileextras/follow_tile.dart';
import 'package:makanaki/presentation/screens/userprofile/extras/public_tile.dart';

import '../../../../../model/following_model.dart';
import '../../../constants/colors.dart';
import '../../../widgets/text.dart';

class PublicFollowFollowingList extends StatelessWidget {
  List<PublicUserData> data;
  String what;
  PublicFollowFollowingList(
      {super.key, required this.data, required this.what});

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/icon/crown.svg",
                  height: 30,
                  width: 30,
                  color: HexColor(primaryColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                AppText(text: "User has no $what")
              ],
            ),
          )
        : ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              PublicUserData followerData = data[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: PublicFollowTile(
                  data: followerData,
                ),
              );
            },
          );
  }
}
