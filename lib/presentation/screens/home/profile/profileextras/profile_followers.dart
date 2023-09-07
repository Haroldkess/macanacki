import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/profile/followers_following.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:provider/provider.dart';
import 'package:numeral/numeral.dart';
import '../../../../../services/middleware/user_profile_ware.dart';

class ProfileFollowersStatistics extends StatelessWidget {
  const ProfileFollowersStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    int test = 123723478621589;

    UserProfileWare stream = context.watch<UserProfileWare>();
    return Container(
      width: width * 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              PageRouting.pushToPage(
                  context,
                  FollowersAndFollowingScreen(
                      title: stream.userProfileModel.username,
                      isFollowing: false));
              print("followers");
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      color: HexColor("#C0C0C0").withOpacity(.4), width: 1),
                  borderRadius: BorderRadius.circular(38)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 85,
                    // color: Colors.amber,
                    alignment: Alignment.center,
                    child: AppText(
                      text: Numeral(stream.userProfileModel.noOfFollowers ?? 0)
                          .format(fractionDigits: 1),
                      fontWeight: FontWeight.w600,
                      size: 18,
                    ),
                  ),
                  AppText(
                    text: "Followers",
                    fontWeight: FontWeight.w500,
                    size: 10,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              print("following");
              PageRouting.pushToPage(
                  context,
                  FollowersAndFollowingScreen(
                      title: stream.userProfileModel.username,
                      isFollowing: true));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                      color: HexColor("#C0C0C0").withOpacity(.4), width: 1),
                  borderRadius: BorderRadius.circular(38)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 85,
                    alignment: Alignment.center,
                    // color: Colors.amber,
                    child: AppText(
                      text: Numeral(stream.userProfileModel.noOfFollowing!)
                          .format(fractionDigits: 1),
                      fontWeight: FontWeight.w600,
                      size: 18,
                    ),
                  ),
                  AppText(
                    text: "Following",
                    fontWeight: FontWeight.w500,
                    size: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileFollowersStatisticsShimmer extends StatelessWidget {
  const ProfileFollowersStatisticsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    int test = 123723478621589;

    UserProfileWare stream = context.watch<UserProfileWare>();
    return Container(
      width: width * 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                color: baseColor,
                // color: Colors.amber,
                alignment: Alignment.center,
                child: AppText(
                  text: Numeral(0).format(),
                  fontWeight: FontWeight.w600,
                  size: 20,
                ),
              ),
              Container(
                width: 70,
                color: baseColor,
                alignment: Alignment.center,
                //color: Colors.amber,
                child: AppText(
                  text: "    ",
                  fontWeight: FontWeight.w400,
                  size: 12,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                color: baseColor,
                alignment: Alignment.center,
                // color: Colors.amber,
                child: AppText(
                  text: Numeral(0).format(),
                  fontWeight: FontWeight.w600,
                  size: 20,
                ),
              ),
              Container(
                width: 70,
                color: baseColor,
                // color: Colors.amber,
                alignment: Alignment.center,
                child: AppText(
                  text: "     ",
                  fontWeight: FontWeight.w400,
                  size: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
