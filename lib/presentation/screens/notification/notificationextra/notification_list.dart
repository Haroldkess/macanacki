import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/model/notification_model.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/screens/notification/notificationextra/notification_tile.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/services/controllers/notification_controller.dart';
import 'package:macanacki/services/middleware/notification_ware..dart';
import 'package:provider/provider.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    NotificationWare stream = context.watch<NotificationWare>();
    return stream.loadStatus
        ? Center(child: Loader(color: HexColor(primaryColor)))
        : ListView.builder(
            itemCount: stream.notifyData.length,
            itemBuilder: (context, index) {
              NotifyData notif = stream.notifyData[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: NotificationTile(
                  item: notif,
                ),
              );
            });
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationController.retrievNotificationController(context, true);
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: HexColor(backgroundColor)));
  }
}
