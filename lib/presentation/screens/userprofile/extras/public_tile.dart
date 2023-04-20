import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/model/following_model.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/userprofile/user_profile_screen.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/action_controller.dart';
import 'package:makanaki/services/middleware/action_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';

import '../../../../model/public_profile_model.dart';

class PublicFollowTile extends StatelessWidget {
  final PublicUserData data;
  const PublicFollowTile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    ActionWare stream = context.watch<ActionWare>();
    Temp name = context.watch<Temp>();
    return InkWell(
      onTap: () {
        PageRouting.pushToPage(
            context,
            UsersProfile(
              username: data.username!,
            ));
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Row(
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
                      Container(
                        //  color: Colors.red,
                        constraints: BoxConstraints(maxWidth: 120),
                        child: RichText(
                            maxLines: 2,
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
              data.username! == name.userName
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  followAction(context);
                                },
                                child: !stream.followIds.contains(data.id!)
                                    ? followCardButton("Follow", true)
                                    : unfollowCardButton("Unfollow")),
                          ],
                        ),
                      ),
                    ),
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

  Widget cardButton(String title, bool isColor) {
    return Container(
      decoration: BoxDecoration(
          color: isColor ? HexColor(primaryColor) : Colors.transparent,
          border: Border.all(width: 1, color: HexColor(primaryColor)),
          borderRadius: BorderRadius.circular(15),
          shape: BoxShape.rectangle),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: AppText(
          text: title,
          color: isColor ? HexColor(backgroundColor) : HexColor(primaryColor),
        ),
      ),
    );
  }

  Widget followCardButton(String title, bool isColor) {
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
