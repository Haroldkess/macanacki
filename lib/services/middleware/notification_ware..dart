import 'package:flutter/cupertino.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/model/notification_model.dart';
import 'package:macanacki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/backoffice/notification_office.dart';
import 'package:macanacki/services/controllers/notification_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/widgets/debug_emitter.dart';

class NotificationWare extends ChangeNotifier {
  bool _loadStatus = false;
  String message = "Cant get gender at the moment";
  NotificationModel notification = NotificationModel();
  List<NotifyData> notifyData = [];

  bool get loadStatus => _loadStatus;
  bool readAll = false;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  void addNotifyStat(bool isLoad) {
    readAll = isLoad;
    notifyListeners();
  }

  Future<bool> getNotificationFromApi(bool fromPage) async {
    late bool isSuccessful;
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      http.Response? response = await getNotification()
          .whenComplete(() => emitter("notificationi gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get gender request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = NotificationModel.fromJson(jsonData);
        notification = incomingData;
        notifyData = notification.data!;
        //  emitter(notifyData.first.body!);

        if (fromPage) {
          if (pref.containsKey(lastMsgKey)) {
            if (pref
                .getString(lastMsgKey)!
                .toLowerCase()
                .contains(notifyData.first.body!.toLowerCase())) {
              log("found last message${notifyData.first.body!}");
              readAll = true;
              pref.setBool(readAllKey, true);
              pref.setString(lastMsgKey, notifyData.first.body!);
            } else {
              readAll = false;
              pref.setBool(readAllKey, false);
              pref.setString(lastMsgKey, notifyData.first.body!);
            }
          } else {
            // readAll = false;
            pref.setBool(readAllKey, false);
            pref.setString(lastMsgKey, notifyData.first.body!);
          }
        } else {
          if (pref.containsKey(lastMsgKey)) {
            if (pref
                .getString(lastMsgKey)!
                .toLowerCase()
                .contains(notifyData.first.body!.toLowerCase())) {
              pref.setBool(readAllKey, true);
              pref.setString(lastMsgKey, notifyData.first.body!);
              readAll = true;
            } else {
              readAll = false;
              pref.setBool(readAllKey, false);
              pref.setString(lastMsgKey, notifyData.first.body!);
            }
          } else {
            pref.setBool(readAllKey, false);
            pref.setString(lastMsgKey, notifyData.first.body!);
          }
        }

        isSuccessful = true;
      } else {
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //   log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
