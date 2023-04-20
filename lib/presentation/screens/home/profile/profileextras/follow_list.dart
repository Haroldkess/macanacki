import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/home/profile/profileextras/follow_tile.dart';

import '../../../../../model/following_model.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/text.dart';

class FollowFollowingList extends StatelessWidget {
  List<FollowingData> data;
  String what;
  FollowFollowingList({super.key, required this.data, required this.what});

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
                AppText(
                  text: "Oops you have no $what",
                  fontWeight: FontWeight.w400,
                )
              ],
            ),
          )
        : ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              FollowingData followerData = data[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: FollowTile(
                  data: followerData,
                ),
              );
            },
          );
  }
}
