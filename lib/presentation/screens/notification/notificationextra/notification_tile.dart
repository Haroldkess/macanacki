import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/model/notification_model.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:makanaki/presentation/screens/matchrequest/match_request_screen.dart';
import 'package:makanaki/presentation/widgets/text.dart';

import '../../../widgets/hexagon_avatar.dart';

class NotificationTile extends StatelessWidget {
  final NotifyData item;
  const NotificationTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 8;
    return ListTile(
      onTap: () async {
        if (item.type == "follow") {
          PageRouting.pushToPage(
              context,
              MatchRequestScreen(
                userName: item.username!,
                id: item.userId!,
                img: item.picture!,
              ));
        }
      },
      leading: item.picture == null
          ? SvgPicture.asset(
              "assets/icon/crown.svg",
              color: HexColor(primaryColor),
            )
          : SizedBox(
              width: 30,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  HexagonWidget.pointy(
                    width: w + 4.0 - 15,
                    elevation: 7.0,
                    color: Colors.white,
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
                  HexagonAvatar(url: item.picture!, w: w + 4.0 - 15),
                ],
              ),
            ),
      title: AppText(
        text: item.title!,
        color: HexColor("#222222"),
        size: 14,
        fontWeight: FontWeight.w700,
      ),
      subtitle: AppText(
        text: item.body!,
        color: HexColor("#8B8B8B"),
        size: 12,
        fontWeight: FontWeight.w500,
      ),
      trailing: Container(
        height: 60,
        //color: Colors.amber,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // item.isRequest || item.isVerify
              //     ? const SizedBox.shrink()
              //     : Icon(
              //         Icons.more_horiz,
              //         color: HexColor(darkColor),
              //       ),
              AppText(
                text: timeago.format(item.createdAt!),
                size: 10,
                fontWeight: FontWeight.w500,
                color: HexColor("#222222"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
