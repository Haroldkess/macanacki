import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/follow_tile.dart';
import 'package:provider/provider.dart';

import '../../../../../model/following_model.dart';
import '../../../../constants/colors.dart';
import '../../../../uiproviders/screen/find_people_provider.dart';
import '../../../../widgets/text.dart';

class FollowFollowingList extends StatelessWidget {
  List<FollowingData> data;
  String what;
  FollowFollowingList({super.key, required this.data, required this.what});

  @override
  Widget build(BuildContext context) {
    FindPeopleProvider search = context.watch<FindPeopleProvider>();

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
        : StreamBuilder(
            stream: null,
            builder: (context, snapshot) {
              List<FollowingData> searched = search.SearchInProfile.isEmpty
                  ? data
                  : data.where((element) {
                      return element.username!
                          .toLowerCase()
                          .contains(search.SearchInProfile.toLowerCase());
                    }).toList();
              return ListView.builder(
                itemCount: searched.length,
                itemBuilder: (context, index) {
                  FollowingData followerData = searched[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: FollowTile(
                      data: followerData,
                    ),
                  );
                },
              );
            });
  }
}
