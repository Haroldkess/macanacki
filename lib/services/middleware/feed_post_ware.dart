import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:makanaki/model/feed_post_model.dart';
import 'package:makanaki/model/gender_model.dart';
import 'package:makanaki/services/backoffice/feed_post_office.dart';
import 'package:makanaki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:makanaki/services/backoffice/user_profile_office.dart';
import 'package:makanaki/services/controllers/feed_post_controller.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../model/profile_feed_post.dart';
import '../../model/user_profile_model.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../backoffice/db.dart';

class FeedPostWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  int _index = 0;
  FeedData _feedData = FeedData();
  List<FeedPost> _feedPosts = [];
  List<File> cachedFilePosts = [];
  List<FeedPost> cachedPosts = [];

  ProfileFeedModel _profileFeedData = ProfileFeedModel();
  List<ProfileFeedDatum> _profileFeedPosts = [];
  int get index => _index;
  bool get loadStatus => _loadStatus;
  bool get loadStatus2 => _loadStatus2;
  FeedData get feedData => _feedData;
  List<FeedPost> get feedPosts => _feedPosts;

  ProfileFeedModel get profileFeedData => _profileFeedData;
  List<ProfileFeedDatum> get profileFeedPosts => _profileFeedPosts;

  Future<void> addCached(FeedPost post) async {
    List<FeedPost> check =
        cachedPosts.where((element) => element.id == post.id).toList();

    //  if (check.isEmpty) {
    cachedPosts.add(post);
    emitter("000000000000000000   ----------  ADDED ${cachedPosts.length} ------- 0000000000000");
    // } else {
    //  log("   ---------- DID NOT  ADD ------- ");
    //  }

    //   FeedData feedData = FeedData(data: cachedPosts);

    //  try {
    // var incomingData = jsonDecode(jsonEncode(feedData.toJson()));

    // Database.create(Database.videoKey, incomingData);
    // var data = await Database.read(Database.videoKey);
    // var decode = await jsonDecode(jsonEncode(data));
    // var existingData = FeedData.fromJson(decode);
    // cachedPosts.addAll(existingData.data!);
    //  } catch (e) {
    //   log(e.toString());
    // }

    notifyListeners();
  }

  Future addCachedFromDb(FeedData data) async {
    cachedPosts.addAll(data.data!);
    notifyListeners();
  }

  void disposeValue() async {
    _feedData = FeedData();
    _feedPosts = [];
    _profileFeedData = ProfileFeedModel();
    _profileFeedPosts = [];
    _index = 0;

    notifyListeners();
  }

  Future<void> addSingleComment(ProfileComment comment, int id) async {
    profileFeedPosts
        .where((element) => id == element.id)
        .single
        .comments!
        .add(comment);
    // _comments.add(comment);
    notifyListeners();
  }

  void disposeValue2() async {
    _profileFeedData = ProfileFeedModel();
    _profileFeedPosts = [];
    _index = 0;

    notifyListeners();
  }

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

  Future<bool> getFeedPostFromApi(int pageNum) async {
    late bool isSuccessful;
    List<FeedPost> _moreFeedPosts = [];

    try {
      http.Response? response = await getFeedPost(pageNum)
          .whenComplete(() => emitter("user feed posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get feed posts data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = FeedData.fromJson(jsonData["data"]);
        _feedData = incomingData;
        _feedData.data!.shuffle();
        emitter(pageNum.toString());

        if (pageNum == 1) {
          _feedPosts = _feedData.data!;
        } else {
          _moreFeedPosts = incomingData.data!;
          _feedPosts.addAll(_moreFeedPosts);
        }
        if (_moreFeedPosts.isNotEmpty) {
          _moreFeedPosts.clear();
        }

        //  log("get feed posts data  request success");
        isSuccessful = true;
      } else {
        // log("get feed posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      // log("get feed posts data  request failed");
      // log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  void remove(id) {
    _feedPosts.removeWhere((element) => element.id == id);
    _profileFeedPosts.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Future clearPost() async {
    _profileFeedData = ProfileFeedModel();

    _profileFeedPosts.clear();
    notifyListeners();
  }

  Future<bool> getUserPostFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getUserFeedPost()
          .whenComplete(() => emitter("user posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = ProfileFeedModel.fromJson(jsonData);

        _profileFeedData = incomingData;

        _profileFeedPosts = _profileFeedData.data!;
        //  log("get user posts data  request success");
        isSuccessful = true;
      } else {
        // log("get user posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //   log("get user posts data  request failed");
      // log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}

class VideosController {
  static Future addVideosOffline(BuildContext context) async {
    FeedPostWare vid = Provider.of(context, listen: false);
    var data = await Database.read(Database.videoKey);

    if (data == null) {
      return;
    }
    log(data.toString());
    var decode = await jsonDecode(jsonEncode(data));
    var existingData = FeedData.fromJson(decode);
    vid.addCachedFromDb(existingData);
    log(existingData.toString());
  }

  static Future makeRequest(context, token) async {}
}
