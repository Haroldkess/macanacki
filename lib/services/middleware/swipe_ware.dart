import 'package:flutter/cupertino.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/model/swiped_user_model.dart';
import 'package:macanacki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/backoffice/swiped_users_office.dart';

import '../../presentation/widgets/debug_emitter.dart';

class SwipeWare extends ChangeNotifier {
  bool _loadStatus = false;
  String message = "Cant get people at the moment";

  SwipeData swipeData = SwipeData();
  String filterName = "All";

  List<SwipedUser> swipedUser = [];

  bool get loadStatus => _loadStatus;

  void changeFilter(String filter) {
    filterName = filter;
    notifyListeners();
  }

  void disposeValue() async {
    swipeData = SwipeData();

    swipedUser = [];
    message = "";

    notifyListeners();
  }

  void isLoading(bool isLoad) {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<bool> getSwipeFromApi(String type) async {
    late bool isSuccessful;
    try {
      http.Response? response = await getSwipedUsers(type)
          .whenComplete(() => emitter("swwipe users gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //  log("swwipe users request failed");
      } else if (response.statusCode == 200) {
        emitter("200");
        var jsonData = jsonDecode(response.body);

        var incomingData = SwipeUserModel.fromJson(jsonData);
        swipedUser = incomingData.data!;

        //  log("swipe users request success");
        isSuccessful = true;
      } else {
        //  log("swipe users  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      emitter(e.toString());
      isSuccessful = false;
      // log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
