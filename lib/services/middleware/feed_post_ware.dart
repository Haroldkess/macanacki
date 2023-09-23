import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:macanacki/model/common/data.dart';
import 'package:macanacki/model/feed_post_model.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/services/backoffice/feed_post_office.dart';
import 'package:macanacki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/backoffice/user_profile_office.dart';
import 'package:macanacki/services/controllers/feed_post_controller.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../model/asset_data.dart';
import '../../model/profile_feed_post.dart';
import '../../model/user_profile_model.dart';
import '../../presentation/constants/string.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../backoffice/db.dart';
import '../backoffice/mux_client.dart';

class FeedPostWare extends ChangeNotifier {
////////////@@@AutoScroll [State]
  PagingController<int, ProfileFeedDatum> pagingController =
      PagingController(firstPageKey: 1);
  bool _isLastPage = false;
  int _pageNumber = 1;
  bool _loading = false;
  int _numberOfPostsPerRequest = 10;
  int _nextPageTrigger = 3;
  ScrollController scrollController = ScrollController();
//////////////////////////////////

  ////////////////////@@@AutoScroll [Getters]
  bool get loading => _loading;
  ////////////////////////////////////////////

  ////////////////////@@@@AutoScroll [Mutation]
  void updateLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void updateIsLastPage(bool value) {
    _isLastPage = value;
    notifyListeners();
  }

  void updatePageNumber(int value) {
    _pageNumber = value;
    notifyListeners();
  }

  void updateNumberOfPostsPerRequest(int value) {
    _numberOfPostsPerRequest = value;
    notifyListeners();
  }

  void updateNextPagePerTrigger(int value) {
    _nextPageTrigger = value;
    notifyListeners();
  }

  void initializePagingController() {
    pagingController = PagingController(firstPageKey: 1);
    disposeAutoScroll();
  }

  void updateProfileFeedPosts(List<ProfileFeedDatum> value) {
    _profileFeedPosts = [..._profileFeedPosts, ...value].distinct();
    notifyListeners();
  }

  void disposeAutoScroll() {
    print("dispose autoscroll");
    _isLastPage = false;
    _pageNumber = 1;
    _loading = false;
    _numberOfPostsPerRequest = 10;
    _nextPageTrigger = 3;
    _profileFeedPosts.clear();
    notifyListeners();
  }
  ////////////////////////////////////////////////

  MUXClient muxClient = MUXClient();
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  bool _loadStatusReferesh = false;
  int _index = 0;
  FeedData _feedData = FeedData();
  List<FeedPost> _feedPosts = [];
  List<Data?> _feedStreamPosts = [];
  List<File> cachedFilePosts = [];
  List<FeedPost> cachedPosts = [];
  List<String> thumbs = [];
  bool? isVisible;

  ProfileFeedModel _profileFeedData = ProfileFeedModel();
  List<ProfileFeedDatum> _profileFeedPosts = [];
  int get index => _index;
  bool get loadStatus => _loadStatus;
  bool get loadStatus2 => _loadStatus2;
  bool get loadStatusReferesh => _loadStatusReferesh;
  FeedData get feedData => _feedData;
  List<FeedPost> get feedPosts => _feedPosts;
  List<Data?> get feedStreamPosts => _feedStreamPosts;

  ProfileFeedModel get profileFeedData => _profileFeedData;
  List<ProfileFeedDatum> get profileFeedPosts => _profileFeedPosts;

  void changeVisibility(bool val) {
    isVisible = val;
    notifyListeners();
  }

  Future<void> addCached(FeedPost post) async {
    List<FeedPost> check =
        cachedPosts.where((element) => element.id == post.id).toList();

    //  if (check.isEmpty) {
    cachedPosts.add(post);
    emitter(
        "000000000000000000   ----------  ADDED ${cachedPosts.length} ------- 0000000000000");
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

  Future addThumbs(List<String> thum) async {
    thumbs.addAll(thum);
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

  Future<void> isLoadingReferesh(bool isLoad) async {
    _loadStatusReferesh = isLoad;
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
      http.Response? response = await getFeedPost(pageNum).whenComplete(
          () => emitter("user feed posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get feed posts data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = FeedData.fromJson(jsonData["data"]);
        _feedData = incomingData;
        //  _feedData.data!.shuffle();
        //emitter(pageNum.toString());

        if (pageNum == 1) {
          _feedPosts = _feedData.data!;
        } else {
          _moreFeedPosts = incomingData.data!;
          _feedPosts.addAll(_moreFeedPosts);
          // if (_moreFeedPosts.length > 5) {
          // //  _moreFeedPosts.shuffle();

          // } else {
          //   _feedPosts.addAll(_moreFeedPosts);
          // }
        }
        if (_moreFeedPosts.isNotEmpty) {
          _moreFeedPosts.clear();
        }

        //   await downloadThumbs(_feedPosts);

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

    //notifyListeners();

    return isSuccessful;
  }

  Future<void> initializeBeforeHand(FeedPost post) async {
    List<FeedPost> data = _feedPosts.where((val) => val.id == post.id).toList();
    if (data.isNotEmpty) {
      if (_feedPosts
              .where((val) => val.id == post.id)
              .toList()
              .first
              .controller ==
          null) {
        _feedPosts.where((val) => val.id == post.id).toList().first.controller =
            post.controller;
      }
    }

    notifyListeners();
  }

  Future<void> remove(id) async {
    final data1 = _feedPosts.where((element) => element.id == id).toList();
    final data2 =
        _profileFeedPosts.where((element) => element.id == id).toList();
    if (data1.isNotEmpty) {
      _feedPosts.removeWhere((element) => element.id == id);
    }
    if (data2.isNotEmpty) {
      _profileFeedPosts.removeWhere((element) => element.id == id);
    }

    notifyListeners();
  }

  Future clearPost() async {
    _profileFeedData = ProfileFeedModel();

    _profileFeedPosts.clear();
    notifyListeners();
  }

  Future<bool> getUserPostFromApi() async {
    late bool isSuccessful;
    if (loading == true || _isLastPage == true) return false;

    try {
      updateLoading(true);
      http.Response? response = await getUserFeedPost(
              _pageNumber, _numberOfPostsPerRequest)
          .whenComplete(() => emitter("user posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        int recordCount = jsonData['record_count'];
        var incomingData = ProfileFeedModel.fromJson(jsonData);
        List<ProfileFeedDatum> newItems = incomingData.data!;
        updateProfileFeedPosts(newItems);
        updatePageNumber(_pageNumber + 1);
        updateIsLastPage(profileFeedPosts.length >= recordCount);

        if (_isLastPage == true) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, _pageNumber);
        }

        isSuccessful = true;
      } else {
        // log("get user posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    } finally {
      updateLoading(false);
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
