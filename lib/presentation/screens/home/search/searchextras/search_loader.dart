import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:shimmer/shimmer.dart';

class SearchLoader extends StatelessWidget {
  const SearchLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor.withOpacity(0.4),
      child: Stack(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  dp(context, url),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "     , ",
                              style: GoogleFonts.leagueSpartan(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      fontSize: 14)),
                              children: [
                            TextSpan(
                              text: "   ",
                              style: GoogleFonts.leagueSpartan(
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
                      const SizedBox(
                        height: 10,
                      ),
                      AppText(
                        text: "Online",
                        fontWeight: FontWeight.w500,
                        size: 12,
                        color: HexColor("#0597FF"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            right: 10.0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  cardButton("Profile", false),
                  const SizedBox(
                    width: 20,
                  ),
                  cardButton("Match", true),
                ],
              ),
            ),
          )
        ],
      ),
    );
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
}
