import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/model/ui_model.dart';

import '../../../../allNavigation.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/hexagon_avatar.dart';
import '../../../../widgets/text.dart';
import '../chat/chat_screen.dart';

class MatchedBox extends StatelessWidget {
  final AppUser matches;
  const MatchedBox({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 8;
    return Container(
      height: 178,
      color: HexColor(backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                Container(
                  width: 68,
                  height: 62,
                  child: Stack(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          HexagonWidget.pointy(
                            width: w + 4.0,
                            // elevation: 30.0,
                            color: HexColor(primaryColor),
                            cornerRadius: 10.0,
                            //  padding: 10,
                            child: AspectRatio(
                              aspectRatio: HexagonType.POINTY.ratio,
                              // child: Image.asset(
                              //   'assets/tram.jpg',
                              //   fit: BoxFit.fitWidth,
                              // ),
                            ),
                          ),
                          HexagonAvatar(url: matches.imageUrl, w: w),
                        ],
                      ),
                      const Positioned(
                        right: 15,
                        top: 6,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, bottom: 0),
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Colors.green,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                RichText(
                    text: TextSpan(
                        text: "${matches.name}, ",
                        style: GoogleFonts.leagueSpartan(
                            color: HexColor(darkColor), fontSize: 20),
                        children: [
                      TextSpan(
                        text: matches.age,
                        style: GoogleFonts.leagueSpartan(
                            color: HexColor("#C0C0C0"), fontSize: 20),
                      )
                    ])),
                const SizedBox(
                  height: 16,
                ),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        fixedSize: const Size(112, 28),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                            color: HexColor("#FFC1D6"),
                            width: 1.0,
                            style: BorderStyle.solid)),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icon/messages.svg",
                          color: HexColor("#FFC1D6"),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        InkWell(
                          // onTap: () => PageRouting.pushToPage(
                          //     context,  ChatScreen(user: matches,)),
                          child: AppText(
                            text: "Chat now",
                            size: 12,
                            color: HexColor("#F94C84"),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
