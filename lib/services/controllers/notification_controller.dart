// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/middleware/gender_ware.dart';
import 'package:macanacki/services/middleware/notification_ware..dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/widgets/debug_emitter.dart';

const String lastMsgKey = "lastMsgKey";
const String readAllKey = "readAllKey";

class NotificationController {
  static Future<void> retrievNotificationController(
      BuildContext context, bool fromPage) async {
    NotificationWare ware =
        Provider.of<NotificationWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware.getNotificationFromApi(fromPage).whenComplete(
        () => emitter("everything from api and provider is done"));

    if (isDone) {
      checkNotification(context);
      ware.isLoading(false);
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, "An error occured", isError: true);
    }
  }

  static Future<void> checkNotification(context) async {
    NotificationWare ware =
        Provider.of<NotificationWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.getBool(readAllKey) == true) {
      ware.addNotifyStat(true);
    } else {
      ware.addNotifyStat(false);
    }
  }
}
