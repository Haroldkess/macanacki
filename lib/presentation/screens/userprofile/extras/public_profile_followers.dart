import 'package:flutter/material.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:provider/provider.dart';
import 'package:numeral/numeral.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../allNavigation.dart';
import '../followers_following.dart';

class PublicProfileFollowersStatistics extends StatelessWidget {
  const PublicProfileFollowersStatistics({super.key});

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
            onTap: () => PageRouting.pushToPage(
                context,
                const FollowersAndFollowingScreen(
                  isFollowing: true,
                  title: "Maggi’s Followers",
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  // color: Colors.amber,
                  alignment: Alignment.center,
                  child: AppText(
                    text: Numeral(
                            stream.publicUserProfileModel.noOfFollowers == null
                                ? 10
                                : stream.publicUserProfileModel.noOfFollowers!)
                        .format(),
                    fontWeight: FontWeight.w600,
                    size: 20,
                  ),
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  //color: Colors.amber,
                  child: AppText(
                    text: "Followers",
                    fontWeight: FontWeight.w400,
                    size: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                alignment: Alignment.center,
                // color: Colors.amber,
                child: AppText(
                  text: Numeral(
                          stream.publicUserProfileModel.noOfFollowing == null
                              ? 10
                              : stream.publicUserProfileModel.noOfFollowing!)
                      .format(),
                  fontWeight: FontWeight.w600,
                  size: 20,
                ),
              ),
              Container(
                width: 70,
                // color: Colors.amber,
                alignment: Alignment.center,
                child: AppText(
                  text: "Following",
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

class PublicLoaderFollowers extends StatelessWidget {
  const PublicLoaderFollowers({super.key});

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
                width: 100,
                // color: Colors.amber,
                alignment: Alignment.center,
                child: AppText(
                  text: const Numeral(10).format(),
                  fontWeight: FontWeight.w600,
                  size: 20,
                ),
              ),
              Container(
                width: 70,
                alignment: Alignment.center,
                //color: Colors.amber,
                child: AppText(
                  text: "Followers",
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
                width: 100,
                alignment: Alignment.center,
                // color: Colors.amber,
                child: AppText(
                  text: const Numeral(10).format(),
                  fontWeight: FontWeight.w600,
                  size: 20,
                ),
              ),
              Container(
                width: 70,
                // color: Colors.amber,
                alignment: Alignment.center,
                child: AppText(
                  text: "Following",
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
