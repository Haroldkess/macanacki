import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/not_mine_buttons.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/profile_action_buttons.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/profile_followers.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/profile_image_name.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../services/controllers/user_profile_controller.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../userprofile/extras/public_profile_info.dart';

class ProfileInfo extends StatefulWidget {
  final bool isMine;
  const ProfileInfo({super.key, required this.isMine});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    UserProfileWare stream = context.watch<UserProfileWare>();

    return stream.loadStatus
        ? PublicLoader()
        : Container(
            color: Colors.grey.shade900,
            child: Container(
              //  height: height / 2,
              width: width,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  color: Colors.black,
                  // HexColor(backgroundColor),
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.elliptical(250, 200),
                      bottomRight: Radius.elliptical(250, 200))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  stream.loadStatus
                      ? Shimmer.fromColors(
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                          child: const ProfileImageAndNameShimmer())
                      : const ProfileImageAndName(),
                  stream.loadStatus
                      ? Shimmer.fromColors(
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                          child: const ProfileFollowersStatisticsShimmer())
                      : const ProfileFollowersStatistics(),
                  widget.isMine
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: AllProfileActions(
                            isMine: widget.isMine,
                          ),
                        )
                      : UserProfileActions()
                ],
              ),
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    UserProfileWare userData =
        Provider.of<UserProfileWare>(context, listen: false);
    if (userData.userProfileModel.email != null) {
      if (userData.userProfileModel.email!.isNotEmpty) {
        return;
      }
    }
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await UserProfileController.retrievProfileController(context, false);
    });
  }
}
