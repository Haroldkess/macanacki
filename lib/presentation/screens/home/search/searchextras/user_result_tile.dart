import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../model/search_user_model.dart';
import '../../../../../services/controllers/action_controller.dart';
import '../../../../../services/middleware/action_ware.dart';
import '../../../../uiproviders/screen/tab_provider.dart';
import '../../../../widgets/loader.dart';
import '../../../userprofile/user_profile_screen.dart';
import '../../profile/profile_screen.dart';

class UserResultTile extends StatelessWidget {
  final UserSearchData data;
  final String username;
  const UserResultTile({super.key, required this.data, required this.username});

  @override
  Widget build(BuildContext context) {
    ActionWare stream = context.watch<ActionWare>();
    UserProfileWare user = context.watch<UserProfileWare>();
    return InkWell(
      onTap: () async {
        TabProvider action = Provider.of<TabProvider>(context, listen: false);

        SharedPreferences pref = await SharedPreferences.getInstance();

        if (pref.getString(userNameKey) == data.username) {
          // ignore: use_build_context_synchronously
          //    PageRouting.pushToPage(context, const ProfileScreen());
          action.tapTrack(0);
          action.changeIndex(4);
          action.pageController!.animateToPage(
            4,
            duration: const Duration(milliseconds: 1),
            curve: Curves.easeIn,
          );
        } else {
          if (data.username == null) {
            return;
          }
          // ignore: use_build_context_synchronously
          PageRouting.pushToPage(
              context,
              UsersProfile(
                username: data.username!,
              ));
        }
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  dp(context,
                      data.profilephoto == null ? "" : data.profilephoto!),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            //  color: Colors.red,
                            constraints: BoxConstraints(maxWidth: 120),
                            child: RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                    text: data.username ?? "...",
                                    style: GoogleFonts.spartan(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                            fontSize: 12)),
                                    children: [
                                      TextSpan(
                                        text: "",
                                        style: GoogleFonts.spartan(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                fontSize: 12)),
                                      ),
                                      // TextSpan(

                                      //   text: data.isMatched ? "Matched" : " ",
                                      //   style: GoogleFonts.spartan(
                                      //       textStyle: TextStyle(
                                      //           fontWeight: FontWeight.w400,
                                      //           color: HexColor("#0597FF"),
                                      //           decorationStyle: TextDecorationStyle.solid,
                                      //           fontSize: 10)),
                                      // )
                                    ])),
                          ),
                          data.verified == 1 &&
                                  data.activePlan != sub
                              ? SvgPicture.asset("assets/icon/badge.svg",
                                  height: 15, width: 15)
                              : const SizedBox.shrink()
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppText(
                        text:
                            "${Numeral(data.noOfFollowers!).format()} followers",
                        fontWeight: FontWeight.w500,
                        size: 10,
                        color: HexColor("#0597FF"),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: user.userProfileModel.username == data.username
                      ? const SizedBox.shrink()
                      : InkWell(
                          onTap: () {
                            followAction(context);
                          },
                          child: !stream.followIds.contains(data.id!)
                              ? followCardButton("Follow", true)
                              : unfollowCardButton("Unfollow")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> followAction(BuildContext context) async {
    ActionWare provide = Provider.of<ActionWare>(context, listen: false);

    await ActionController.followOrUnFollowController(
        context, data.username!, data.id!);
  }

  Widget dp(BuildContext context, String url) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = 59.0;
    return Stack(
      children: [
        HexagonWidget.pointy(
          width: w,
          elevation: 2.0,
          color: Colors.white,
          cornerRadius: 20.0,
          child: AspectRatio(
            aspectRatio: HexagonType.POINTY.ratio,
            // child: Image.asset(
            //   'assets/tram.jpg',
            //   fit: BoxFit.fitWidth,
            // ),
          ),
        ),
        HexagonWidget.pointy(
          width: w,
          elevation: 0.0,
          color: HexColor("#5F5F5F"),
          padding: 2,
          cornerRadius: 20.0,
          child: AspectRatio(
              aspectRatio: HexagonType.POINTY.ratio,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: url,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: Loader(
                    color: HexColor(primaryColor),
                  )),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: HexColor(primaryColor),
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget followCardButton(String title, bool isColor) {
    return Container(
      decoration: BoxDecoration(
          color: isColor ? HexColor(primaryColor) : Colors.transparent,
          border: Border.all(width: 1, color: HexColor(primaryColor)),
          borderRadius: BorderRadius.circular(15),
          shape: BoxShape.rectangle),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: AppText(
          text: title,
          color: HexColor(backgroundColor),
          size: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget unfollowCardButton(String title) {
    return Container(
      decoration: BoxDecoration(
          color: HexColor(primaryColor),
          border: Border.all(width: 1, color: HexColor(primaryColor)),
          borderRadius: BorderRadius.circular(15),
          shape: BoxShape.rectangle),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: AppText(
          text: title,
          color: HexColor(backgroundColor),
          size: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
