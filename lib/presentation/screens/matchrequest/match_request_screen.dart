import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/widgets/buttons.dart';

import '../../widgets/text.dart';

class MatchRequestScreen extends StatelessWidget {
  const MatchRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: height * 0.58, child: buildCard(url)),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: "Maggie, ",
                                  style: GoogleFonts.spartan(
                                    color: HexColor(darkColor),
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: [
                                TextSpan(
                                  text: "32",
                                  style: GoogleFonts.spartan(
                                      color: HexColor("#C0C0C0"), fontSize: 20),
                                )
                              ])),
                          Image.asset(
                            "assets/pic/verified.png",
                            height: 27,
                            width: 27,
                            color: HexColor(primaryColor),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: HexColor("#00B074"),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              AppText(
                                text: "Online Now",
                                size: 14,
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset("assets/icon/location.svg"),
                              const SizedBox(
                                width: 5,
                              ),
                              AppText(
                                text: "2 km away",
                                size: 14,
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )),
              const SizedBox(
                height: 35,
              ),
              Container(
                height: 58,
                width: 280,
                child: AppButton(
                    width: 280,
                    height: 58,
                    color: primaryColor,
                    text: "Match Back",
                    backColor: primaryColor,
                    onTap: () {},
                    curves: 37,
                    textColor: "#FFFFFF"),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 58,
                width: 280,
                child: AppButton(
                    width: 280,
                    height: 58,
                    color: "#F5F2F9",
                    text: "Maybe Later",
                    backColor: "#F5F2F9",
                    onTap: () {},
                    curves: 37,
                    textColor: "#8B8B8B"),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
          Positioned(
            top: 40,
            child: Container(
              width: width,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: "Match Request",
                      size: 20,
                      fontWeight: FontWeight.w800,
                      color: HexColor("#FFFFFF"),
                    ),
                    InkWell(
                      onTap: () => PageRouting.popToPage(context),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: HexColor("#FFFFFF"),
                            border: Border.all(
                                width: 1.0,
                                color: HexColor("#FFFFFF"),
                                style: BorderStyle.solid)),
                        child: Icon(
                          Icons.clear,
                          color: HexColor("#8B8B8B"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildCard(String image) => ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  alignment: const Alignment(-0.3, 0),
                  image: NetworkImage(image),
                  fit: BoxFit.cover)),
        ),
      );
}
