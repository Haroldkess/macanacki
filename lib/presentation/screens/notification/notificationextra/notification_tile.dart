import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/matchrequest/match_request_screen.dart';
import 'package:makanaki/presentation/screens/notification/notificationextra/notification_image.dart';
import 'package:makanaki/presentation/widgets/text.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification item;
  const NotificationTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => PageRouting.pushToPage(context, const MatchRequestScreen()),
      leading: NotificationImage(item: item),
      title: AppText(
        text: item.title,
        color: HexColor("#222222"),
        size: 14,
        fontWeight: FontWeight.w400,
      ),
      subtitle: AppText(
        text: item.title,
        color: HexColor("#8B8B8B"),
        size: 12,
        fontWeight: FontWeight.w400,
      ),
      trailing: Container(
        height: 60,
        //color: Colors.amber,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisAlignment: item.isRequest || item.isVerify
                ? MainAxisAlignment.end
                : MainAxisAlignment.spaceBetween,
            children: [
              item.isRequest || item.isVerify
                  ? const SizedBox.shrink()
                  : Icon(
                      Icons.more_horiz,
                      color: HexColor(darkColor),
                    ),
              AppText(
                text: item.time,
                size: 10,
                fontWeight: FontWeight.w400,
                color: HexColor("#222222"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
