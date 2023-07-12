import 'package:flutter/cupertino.dart';
import 'package:macanacki/model/public_profile_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/backoffice/user_profile_office.dart';
import 'package:macanacki/services/temps/temps_id.dart';

import '../../model/gender_model.dart';
import '../../model/register_model.dart';
import '../../model/user_profile_model.dart';
import '../../presentation/screens/onboarding/business/business_modal.dart';
import '../../presentation/widgets/debug_emitter.dart';

class UserProfileWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  bool _deleting = false;
  UserData _userProfileModel = UserData();
  PublicUserData _publicUserProfileModel = PublicUserData();

  int _index = 0;

  int _userindex = 0;

  int _publicindex = 0;

  int get index => _index;

  int get userIndex => _userindex;

  int get publicIndex => _publicindex;

  bool get loadStatus => _loadStatus;
  bool get loadStatus2 => _loadStatus2;
  bool get deleting => _deleting;
  UserData get userProfileModel => _userProfileModel;
  PublicUserData get publicUserProfileModel => _publicUserProfileModel;
  String id = "";
  VerifyUserModel verifyUserModel = VerifyUserModel();
  GenderList genderData = GenderList();
  RegisterBusinessModel registerBusinessModel = RegisterBusinessModel();

  void addId(String myId) {
    id = myId;
    notifyListeners();
  }

  Future<void> saveBusinessInfo(
    VerifyUserModel v,
    GenderList g,
    RegisterBusinessModel r,
  ) async {
    verifyUserModel = v;
    genderData = g;
    registerBusinessModel = r;

    notifyListeners();
  }

  void disposeValue() async {
    _userProfileModel = UserData();
    _publicUserProfileModel = PublicUserData();

    notifyListeners();
  }

  Future<void> addSingleComment(PublicComment comment, int id) async {
    _publicUserProfileModel.posts!
        .where((element) => id == element.id)
        .single
        .comments!
        .add(comment);
    // _comments.add(comment);
    notifyListeners();
  }

  void changeIndex(int fig) {
    _index = fig;
    notifyListeners();
  }

  void changeUserIndex(int fig) {
    _userindex = fig;
    notifyListeners();
  }

  void changePublicIndex(int fig) {
    _publicindex = fig;
    notifyListeners();
  }

  Future<void> isLoading(bool isLoad) async {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<void> isDeleting(bool del) async {
    _deleting = del;
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

  Future<bool> getUserProfileFromApi(context) async {
    late bool isSuccessful;
    try {
      http.Response? response = await getUserProfile()
          .whenComplete(() => emitter("user profile data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        // log("get user profile data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = UserProfileModel.fromJson(jsonData);
        _userProfileModel = incomingData.data!;

        await runTask(context, _userProfileModel.username,
            _userProfileModel.profilephoto);

        // log("get user profile data  request success");
        isSuccessful = true;
      } else {
        //  log("get user profile data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //  log("get user profile data  request failed");
      //  log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> getPublicUserProfileFromApi(String username) async {
    late bool isSuccessful;
    try {
      http.Response? response = await getUserPublicProfile(username)
          .whenComplete(() => emitter("user profile data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        // log("get user profile data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = PublicProfileModel.fromJson(jsonData);
        _publicUserProfileModel = incomingData.data!;

        //   log("get user profile data  request success");
        isSuccessful = true;
      } else {
        //   log("get user profile data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      // log("get user profile data  request failed");
      //   log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> deleteUserFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await deletePubProfile()
          .whenComplete(() => emitter("user profile data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        // log("get user profile data request failed");
      } else if (response.statusCode == 200) {
        // var jsonData = jsonDecode(response.body);

        // var incomingData = PublicProfileModel.fromJson(jsonData);
        // _publicUserProfileModel = incomingData.data!;

        //   log("get user profile data  request success");
        isSuccessful = true;
      } else {
        //   log("get user profile data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      // log("get user profile data  request failed");
      //   log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
