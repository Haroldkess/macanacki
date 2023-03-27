import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/widgets/hexagon_avatar.dart';
import 'package:makanaki/presentation/widgets/text.dart';

class Matches extends StatelessWidget {
  const Matches({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 7;
    return SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: matches.length,
          itemBuilder: ((context, index) {
            String match = matches[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Container(
                height: 61,
                width: 61,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            HexagonWidget.pointy(
                              width: w + 5.0,
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
                            HexagonAvatar(url: url, w: w),
                          ],
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        AppText(
                          text: match,
                          color: HexColor("#8B8B8B"),
                          size: 14,
                        )
                      ],
                    ),
                    const Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 12, bottom: 10),
                        child: CircleAvatar(
                          radius: 5,
                          backgroundColor: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
