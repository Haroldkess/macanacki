import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/notification/notificationextra/notification_list.dart';
import 'package:macanacki/presentation/widgets/text.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: AppText(
          text: "Notifications",
          color: textWhite,
          size: 24,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          InkWell(
            onTap: () => PageRouting.popToPage(context),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1.0,
                      color: HexColor("#C0C0C0"),
                      style: BorderStyle.solid)),
              child: Icon(
                Icons.clear,
                color: HexColor("#8B8B8B"),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: const NotificationList(),
    );
  }
}
