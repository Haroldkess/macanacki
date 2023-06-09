import 'package:flutter/cupertino.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/model/notification_model.dart';
import 'package:macanacki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/backoffice/notification_office.dart';

import '../../presentation/widgets/debug_emitter.dart';

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
          .whenComplete(() => emitter("notificationi gotten successfully"));
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
