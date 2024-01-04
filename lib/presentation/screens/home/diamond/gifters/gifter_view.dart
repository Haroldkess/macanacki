import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:numeral/numeral.dart';

import '../../../../../model/gift_diamond_history_model.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/params.dart';
import '../../../../widgets/loader.dart';
import '../../../../widgets/text.dart';

class GifterView extends StatelessWidget {
  final GifterInfo data;
  const GifterView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: HexColor(backgroundColor),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Row(
                children: [
                  dp(
                      context,
                      data.sender!.profilephoto == null
                          ? ""
                          : data.sender!.profilephoto!),
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
                                    text: "${data.sender!.username}",
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: textWhite,
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                            fontSize: 13)),
                                    children: [
                                      TextSpan(
                                        text: "",
                                        style: GoogleFonts.roboto(
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
                          SizedBox(
                            width: 4,
                          ),
                          data.sender!.verified == 1
                              ? SvgPicture.asset(
                                  "assets/icon/badge.svg",
                                  height: 15,
                                  width: 15,
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      AppText(
                        text:
                            "${Numeral(data.sender!.noOfFollowers!).format()} followers",
                        fontWeight: FontWeight.w500,
                        size: 10,
                        color: Colors.green,
                        // color: HexColor("#0597FF"),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      AppText(
                        text: Operations.times(data.createdAt!),
                        fontWeight: FontWeight.w500,
                        size: 13,
                        color: Colors.grey.withOpacity(.7),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () {},
                          child: giftButton("${data.value}", true)),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dp(BuildContext context, String url) {
    var w = 58.0;
    return Stack(
      children: [
        HexagonWidget.pointy(
          width: w,
          elevation: 2.0,
          color: backgroundSecondary,
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

  Widget giftButton(String title, bool isColor) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundSecondary,
          border: Border.all(
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          shape: BoxShape.rectangle),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Row(
          children: [
            const SizedBox(
              width: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: SvgPicture.asset(
                "assets/icon/diamond.svg",
                height: 13,
                width: 13,
                //   color: HexColor(diamondColor),
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            AppText(
              text: "${Numeral(num.tryParse(title.toString())!).format()}",
              color: textWhite,
              size: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
