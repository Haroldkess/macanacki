import 'package:flutter/material.dart';
import 'package:makanaki/presentation/model/ui_model.dart';
import 'package:makanaki/presentation/screens/notification/notificationextra/notification_tile.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: appNotification.length,
        itemBuilder: (context, index) {
          AppNotification notif = appNotification[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical:  10
            ),
            child: NotificationTile(
              item: notif,
            ),
          );
        });
  }
}
