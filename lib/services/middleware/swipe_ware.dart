import 'package:flutter/cupertino.dart';
import 'package:makanaki/model/gender_model.dart';
import 'package:makanaki/model/swiped_user_model.dart';
import 'package:makanaki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:makanaki/services/backoffice/swiped_users_office.dart';

class SwipeWare extends ChangeNotifier {
  bool _loadStatus = false;
  String message = "Cant get people at the moment";

  SwipeData swipeData = SwipeData();

  List<SwipedUser> swipedUser = [];
 

  bool get loadStatus => _loadStatus;

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<bool> getSwipeFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getSwipedUsers()
          .whenComplete(() => log("swwipe users gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        log("swwipe users request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = SwipeData.fromJson(jsonData["data"]);
        swipedUser = incomingData.data!;

        log("swipe users request success");
        isSuccessful = true;
      } else {
        log("swipe users  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log("swwipe users request failed");
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
