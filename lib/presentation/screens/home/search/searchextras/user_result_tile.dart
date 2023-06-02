import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../model/search_user_model.dart';
import '../../../../../services/controllers/action_controller.dart';
import '../../../../../services/middleware/action_ware.dart';
import '../../../userprofile/user_profile_screen.dart';
import '../../profile/profile_screen.dart';

class UserResultTile extends StatelessWidget {
  final UserSearchData data;
  final String username;
  const UserResultTile({super.key, required this.data, required this.username});

  @override
  Widget build(BuildContext context) {
    ActionWare stream = context.watch<ActionWare>();
    return InkWell(
      onTap: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();

        if (pref.getString(userNameKey) == data.username) {
          // ignore: use_build_context_synchronously
          PageRouting.pushToPage(context, const ProfileScreen());
        } else {
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
                                text: TextSpan(
                                    text: "${data.username}",
                                    style: GoogleFonts.spartan(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                            fontSize: 13)),
                                    children: [
                                      TextSpan(
                                        text: "",
                                        style: GoogleFonts.spartan(
                                            textStyle: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                fontSize: 14)),
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
                          data.verification == null
                              ? const SizedBox.shrink()
                              : SvgPicture.asset("assets/icon/badge.svg",
                                  height: 15, width: 15)
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
                  child: username == data.username
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
    var w = (size.width - 4 * 1) / 6;
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
              child: Center(child: Image.network(url))),
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
          size: 13,
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
          size: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
