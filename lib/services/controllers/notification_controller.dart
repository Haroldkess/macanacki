import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/middleware/gender_ware.dart';
import 'package:makanaki/services/middleware/notification_ware..dart';
import 'package:provider/provider.dart';

class NotificationController {
  static Future<void> retrievNotificationController(BuildContext context) async {
    NotificationWare ware = Provider.of<NotificationWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .getNotificationFromApi()
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading(false);
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
       showToast2(context, "An error occured", isError: true);
    }
  }
}
