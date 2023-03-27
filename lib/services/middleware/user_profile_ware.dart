import 'package:flutter/cupertino.dart';
import 'package:makanaki/model/public_profile_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:makanaki/services/backoffice/user_profile_office.dart';

import '../../model/user_profile_model.dart';

class UserProfileWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  UserData _userProfileModel = UserData();
  PublicUserData _publicUserProfileModel = PublicUserData();

  int _index = 0;

  int get index => _index;

  bool get loadStatus => _loadStatus;
  bool get loadStatus2 => _loadStatus2;
  UserData get userProfileModel => _userProfileModel;
  PublicUserData get publicUserProfileModel => _publicUserProfileModel;

  void changeIndex(int fig) {
    _index = fig;
    notifyListeners();
  }

  Future<void> isLoading(bool isLoad) async {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<void> isLoading2(bool isLoad) async {
    _loadStatus2 = isLoad;
    notifyListeners();
  }

  void resetPublicUser() {
    _publicUserProfileModel = PublicUserData();
    notifyListeners();
  }

  Future<bool> getUserProfileFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getUserProfile()
          .whenComplete(() => log("user profile data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        log("get user profile data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = UserProfileModel.fromJson(jsonData);
        _userProfileModel = incomingData.data!;

        log("get user profile data  request success");
        isSuccessful = true;
      } else {
        log("get user profile data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log("get user profile data  request failed");
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> getPublicUserProfileFromApi(String username) async {
    late bool isSuccessful;
    try {
      http.Response? response = await getUserPublicProfile(username)
          .whenComplete(() => log("user profile data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        log("get user profile data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = PublicProfileModel.fromJson(jsonData);
        _publicUserProfileModel = incomingData.data!;

        log("get user profile data  request success");
        isSuccessful = true;
      } else {
        log("get user profile data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log("get user profile data  request failed");
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
