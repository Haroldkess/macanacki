import 'package:flutter/cupertino.dart';
import 'package:makanaki/model/gender_model.dart';
import 'package:makanaki/model/notification_model.dart';
import 'package:makanaki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:makanaki/services/backoffice/notification_office.dart';

class NotificationWare extends ChangeNotifier {
  bool _loadStatus = false;
  String message = "Cant get gender at the moment";
  NotificationModel notification = NotificationModel();
  List<NotifyData> notifyData = [];

  bool get loadStatus => _loadStatus;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<bool> getNotificationFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getNotification()
          .whenComplete(() => log("notificationi gotten successfully"));
      if (response == null) {
        isSuccessful = false;
     //   log("get gender request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = NotificationModel.fromJson(jsonData);
        notification = incomingData;
        notifyData = notification.data!;

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
