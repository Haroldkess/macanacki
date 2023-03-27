import 'package:flutter/cupertino.dart';
import 'package:makanaki/model/feed_post_model.dart';
import 'package:makanaki/model/gender_model.dart';
import 'package:makanaki/services/backoffice/feed_post_office.dart';
import 'package:makanaki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:makanaki/services/backoffice/user_profile_office.dart';

import '../../model/profile_feed_post.dart';
import '../../model/user_profile_model.dart';

class FeedPostWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  int _index = 0;
  FeedData _feedData = FeedData();
  List<FeedPost> _feedPosts = [];

  ProfileFeedModel _profileFeedData = ProfileFeedModel();
  List<FeedPost> _profileFeedPosts = [];
  int get index => _index;
  bool get loadStatus => _loadStatus;
  bool get loadStatus2 => _loadStatus2;
  FeedData get feedData => _feedData;
  List<FeedPost> get feedPosts => _feedPosts;

  ProfileFeedModel get profileFeedData => _profileFeedData;
  List<FeedPost> get profileFeedPosts => _profileFeedPosts;

  Future<void> isLoading(bool isLoad) async {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<void> indexChange(int num) async {
    _index = num;
    notifyListeners();
  }

  Future<void> isLoading2(bool isLoad) async {
    _loadStatus2 = isLoad;
    notifyListeners();
  }

  Future<bool> getFeedPostFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getFeedPost()
          .whenComplete(() => log("user feed posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        log("get feed posts data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = FeedData.fromJson(jsonData["data"]);

        _feedData = incomingData;

        _feedPosts = _feedData.data!;

        log("get feed posts data  request success");
        isSuccessful = true;
      } else {
        log("get feed posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log("get feed posts data  request failed");
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> getUserPostFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getUserFeedPost()
          .whenComplete(() => log("user posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = ProfileFeedModel.fromJson(jsonData);

        _profileFeedData = incomingData;

        _profileFeedPosts = _feedData.data!;
        log("get user posts data  request success");
        isSuccessful = true;
      } else {
        log("get user posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log("get user posts data  request failed");
      log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
