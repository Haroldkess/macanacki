import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:macanacki/model/common/data.dart';
import 'package:macanacki/model/feed_post_model.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/preload/preload_controller.dart';
import 'package:macanacki/services/backoffice/feed_post_office.dart';
import 'package:macanacki/services/backoffice/gender_office.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:macanacki/services/backoffice/user_profile_office.dart';
import 'package:macanacki/services/controllers/feed_post_controller.dart';
import 'package:macanacki/services/middleware/video/video_ware.dart';
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
  PagingController<int, ProfileFeedDatum> pagingController2 =
      PagingController(firstPageKey: 1);
  bool _isLastPage = false;
  bool _isLastPageAudio = false;
  int _pageNumber = 1;
  int _pageNumberAudio = 1;
  bool _loading = false;
  bool _loadingAudio = false;
  int _numberOfPostsPerRequest = 10;
  int _nextPageTrigger = 3;
  ScrollController scrollController = ScrollController();
//////////////////////////////////

  ////////////////////@@@AutoScroll [Getters]
  bool get loading => _loading;
  ////////////////////////////////////////////
  bool get loadingAudio => _loadingAudio;
  ////////////////////@@@@AutoScroll [Mutation]
  void updateLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void updateLoadingAudio(bool value) {
    _loadingAudio = value;
    notifyListeners();
  }

  void updateIsLastPage(bool value, bool audio) {
    if (audio) {
      _isLastPageAudio = value;
    } else {
      _isLastPage = value;
    }

    notifyListeners();
  }

  void updatePageNumber(int value, bool audio) {
    if (audio) {
      _pageNumberAudio = value;
    } else {
      _pageNumber = value;
    }

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
    pagingController2 = PagingController(firstPageKey: 1);
    disposeAutoScroll();
  }

  Future updateProfileFeedPosts(List<ProfileFeedDatum> value) async {
    //   List<ProfileFeedDatum> data = [..._profileFeedPosts, ...value].distinct();
    // List<ProfileFeedDatum> others = [];
    // List<ProfileFeedDatum> mp3 = [];

    // await Future.wait([
    //   Future.forEach(data, (element) {
    //     IList<ProfileFeedDatum> check =
    //         _profileFeedPosts.where((val) => val.id == element.id).toIList();
    //     if (check.isEmpty) {
    //       _profileFeedPosts.add(element);
    //     } else {
    //       // others.add(element);
    //     }
    //   })
    // ]);

    // for (var element in data) {
    //   IList<ProfileFeedDatum> check =
    //       _profileFeedPosts.where((val) => val.id == element.id).toIList();
    //   if (check.isEmpty) {
    //     _profileFeedPosts.add(element);
    //   } else {
    //     // others.add(element);
    //   }
    // }

    // _profileFeedPosts = [...others].distinct();

    // _profileFeedPostsAudio = [...mp3].distinct();

    _profileFeedPosts = [..._profileFeedPosts, ...value].distinct();
    notifyListeners();
  }

  Future updateProfileFeedPostsAudio(List<ProfileFeedDatum> value) async {
    // List<ProfileFeedDatum> data =
    //     [..._profileFeedPostsAudio, ...value].distinct();
    // List<ProfileFeedDatum> others = [];
    // List<ProfileFeedDatum> mp3 = []

    // await Future.wait([
    //   Future.forEach(data, (element) {
    //     IList<ProfileFeedDatum> check = _profileFeedPostsAudio
    //         .where((val) => val.id == element.id)
    //         .toIList();
    //     if (check.isEmpty) {
    //       _profileFeedPostsAudio.add(element);
    //     } else {
    //       // others.add(element);
    //     }
    //   })
    // ]);

    // for (var element in data) {
    //   IList<ProfileFeedDatum> check =
    //       _profileFeedPostsAudio.where((val) => val.id == element.id).toIList();
    //   if (check.isEmpty) {
    //     _profileFeedPostsAudio.add(element);
    //   } else {
    //     // others.add(element);
    //   }
    // }

    // _profileFeedPosts = [...others].distinct();

    // _profileFeedPostsAudio = [...mp3].distinct();

    _profileFeedPostsAudio = [..._profileFeedPostsAudio, ...value].distinct();
    notifyListeners();
  }

  void disposeAutoScroll() {
    print("dispose autoscroll");
    _isLastPage = false;
    _isLastPageAudio = false;
    _pageNumber = 1;
    _pageNumberAudio = 1;
    _loading = false;
    _numberOfPostsPerRequest = 10;
    _nextPageTrigger = 3;
    _profileFeedPosts.clear();
    _profileFeedPosts = [];
    _profileFeedPostsAudio.clear();
    _profileFeedPostsAudio = [];
    notifyListeners();
  }
  ////////////////////////////////////////////////

  MUXClient muxClient = MUXClient();
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  bool _loadStatusReferesh = false;
  int _index = 0;
  FeedData _feedData = FeedData();
  ProfileFeedModel holdData = ProfileFeedModel();

  ProfileFeedModel holdDataAudio = ProfileFeedModel();

  List<FeedPost> _feedPosts = [];
  List<Data?> _feedStreamPosts = [];
  List<File> cachedFilePosts = [];
  List<FeedPost> cachedPosts = [];
  List<String> thumbs = [];
  bool? isVisible;

  int tabIndex = 0;

  ProfileFeedModel _profileFeedData = ProfileFeedModel();
  List<ProfileFeedDatum> _profileFeedPosts = [];
  List<ProfileFeedDatum> _profileFeedPostsAudio = [];
  int get index => _index;
  bool get loadStatus => _loadStatus;
  bool get loadStatus2 => _loadStatus2;
  bool get loadStatusReferesh => _loadStatusReferesh;
  FeedData get feedData => _feedData;
  List<FeedPost> get feedPosts => _feedPosts;
  List<Data?> get feedStreamPosts => _feedStreamPosts;

  ProfileFeedModel get profileFeedData => _profileFeedData;
  List<ProfileFeedDatum> get profileFeedPosts => _profileFeedPosts;
  List<ProfileFeedDatum> get profileFeedPostsAudio => _profileFeedPostsAudio;

  void changeVisibility(bool val) {
    isVisible = val;
    notifyListeners();
  }

  Future changeTabIndex(int val) async {
    tabIndex = val;
    print(tabIndex);
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
    //_profileFeedData = ProfileFeedModel();
    _profileFeedPostsAudio = [];
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

  Future<bool> getFeedPostFromApi(int pageNum, [String? filter]) async {
    late bool isSuccessful;
    List<FeedPost> _moreFeedPosts = [];
    print("000000000000000000000000000000000000 xxxxxx");

    try {
      final preloadController = PreloadController.to;
      http.Response? response = await getFeedPost(pageNum, filter).whenComplete(
          () => emitter("user feed posts data gotten successfully"));
      if (response == null) {
        print("000000000000000000000000000000000000 0");
        isSuccessful = false;
        //   log("get feed posts data request failed");
      } else if (response.statusCode == 200) {
        print("000000000000000000000000000000000000 1");
        var jsonData = jsonDecode(response.body);
        print(jsonData);

        var incomingData = FeedData.fromJson(jsonData["data"]);
        print("000000000000000000000000000000000000 2");

        _feedData = incomingData;

        // Martins
        if (incomingData.data != null) {
          for (var element in incomingData.data!) {
            preloadController.addPreload(id: element.id!, vod: element.vod!);
          }
        }
        print("000000000000000000000000000000000000 3");

        if (pageNum == 1) {
          _feedPosts = incomingData.data!;

          try {
            var lister = incomingData.data!
                .where((element) => !element.mux!.first.contains("https"))
                .toList();

            if (lister.isNotEmpty) {
              log("loading them");
              Future.forEach(
                  lister,
                  (element) =>
                      VideoWareHome.instance.getVideoFromApi(element.id!));
            }
          } catch (e) {
            log(e.toString());
          }

          // for (var element in _feedData.data!) {
          //   if (!element.media!.first.contains("https")) {
          //     log("loading them");
          //     VideoWareHome.instance.getVideoFromApi(element.id!);
          //   } else {}
          // }
        } else {
          _moreFeedPosts = incomingData.data!;
          _feedPosts.addAll(_moreFeedPosts);

          final data = _moreFeedPosts;
          try {
            var lister = incomingData.data!
                .where((element) => !element.mux!.first.contains("https"))
                .toList();

            if (lister.isNotEmpty) {
              log("loading them");
              Future.forEach(
                  lister,
                  (element) =>
                      VideoWareHome.instance.getVideoFromApi(element.id!));
            }
          } catch (e) {
            log(e.toString());
          }
          // for (var element in incomingData.data!) {
          //   if (!element.media!.first.contains("https")) {
          //     log("loading them");
          //     VideoWareHome.instance.getVideoFromApi(element.id!);
          //   } else {}
          // }
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
        print(
            "000000000000000000000000000000000000 Status Code *** ${response.statusCode}");
        print("&&&&& ${response.body.toString()}");
        // log("get feed posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      // log("get feed posts data  request failed");
      log(e.toString());
      print("000000000000000000000000000000000000 4");
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
    final data3 =
        _profileFeedPostsAudio.where((element) => element.id == id).toList();
    if (data1.isNotEmpty) {
      _feedPosts.removeWhere((element) => element.id == id);
    }
    if (data2.isNotEmpty) {
      _profileFeedPosts.removeWhere((element) => element.id == id);
    }
    if (data3.isNotEmpty) {
      _profileFeedPostsAudio.removeWhere((element) => element.id == id);
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
    List<ProfileFeedDatum> others = [];
    List<ProfileFeedDatum> mp3 = [];
    final preloadController = PreloadController.to;

    log(feedData.currentPage.toString());
    if (loading == true || _isLastPage == true) return false;

    try {
      updateLoading(true);
      http.Response? response = await getUserFeedPost(
              _pageNumber, _numberOfPostsPerRequest, "videos_images")
          .whenComplete(
              () => emitter("user video posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        int recordCount = jsonData['record_count'];
        var incomingData = ProfileFeedModel.fromJson(jsonData);

        if (incomingData.data != null) {
          for (var element in incomingData.data!) {
            preloadController.addPreload(id: element.id!, vod: element.vod!);
          }
        }
        // holdData = incomingData;

        // await Future.wait([
        //   Future.forEach(
        //       incomingData.data!,
        //       (element) => element.media!.first.contains(".mp3")
        //           ? mp3.add(element)
        //           : others.add(element))
        // ]);
        List<ProfileFeedDatum> newItems = incomingData.data!;

        await updateProfileFeedPosts(newItems);

        updatePageNumber(_pageNumber + 1, false);
        updateIsLastPage(profileFeedPosts.length >= recordCount, false);

        if (_isLastPage == true) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, _pageNumber);
        }

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          VideoWare.instance.getVideoPostFromApi(_profileFeedPosts);
        });

        isSuccessful = true;
      } else {
        // log("get user posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log(e.toString());
    } finally {
      updateLoading(false);
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> getUserPostAudioFromApi() async {
    late bool isSuccessful;
    List<ProfileFeedDatum> others = [];
    List<ProfileFeedDatum> mp3 = [];
    if (loadingAudio == true || _isLastPageAudio == true) return false;

    try {
      updateLoadingAudio(true);
      http.Response? response = await getUserFeedPost(
              _pageNumberAudio, _numberOfPostsPerRequest, "audios")
          .whenComplete(() => emitter("user audio data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        int recordCount = jsonData['record_count'];
        var incomingData = ProfileFeedModel.fromJson(jsonData);
        List<ProfileFeedDatum> newItems = incomingData.data!;

        // await Future.wait([
        //   Future.forEach(
        //       incomingData.data!,
        //       (element) => element.media!.first.contains(".mp3")
        //           ? mp3.add(element)
        //           : others.add(element))
        // ]);

        await updateProfileFeedPostsAudio(newItems);
        // updateProfileFeedPostsAudio(newItems2);
        updatePageNumber(_pageNumberAudio + 1, true);
        updateIsLastPage((profileFeedPostsAudio.length) >= recordCount, true);

        if (_isLastPageAudio == true) {
          //pagingController.appendLastPage(newItems);
          pagingController2.appendLastPage(newItems);
        } else {
          //  pagingController.appendPage(newItems, _pageNumber);
          pagingController2.appendPage(newItems, _pageNumberAudio);
        }

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          VideoWare.instance.getAudioPostFromApi(_profileFeedPostsAudio);
        });

        isSuccessful = true;
      } else {
        // log("get user posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log(e.toString());
    } finally {
      updateLoadingAudio(false);
    }

    notifyListeners();

    return isSuccessful;
  }
}

class FeedPostWareAudio extends ChangeNotifier {
////////////@@@AutoScroll [State]

  PagingController<int, ProfileFeedDatum> pagingController =
      PagingController(firstPageKey: 1);

  bool _isLastPageAudio = false;

  int _pageNumberAudio = 1;
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

  void updateIsLastPage(bool value, bool audio) {
    if (audio) {
      _isLastPageAudio = value;
    } else {}

    notifyListeners();
  }

  void updatePageNumber(int value, bool audio) {
    if (audio) {
      _pageNumberAudio = value;
    } else {}

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

  void updateProfileFeedPosts(List<ProfileFeedDatum> value) async {
    _profileFeedPosts = [..._profileFeedPosts, ...value].distinct();
    notifyListeners();
  }

  void updateProfileFeedPostsAudio(List<ProfileFeedDatum> value) async {
    _profileFeedPostsAudio = [..._profileFeedPostsAudio, ...value].distinct();
    notifyListeners();
  }

  void disposeAutoScroll() {
    print("dispose autoscroll");
    _isLastPageAudio = false;
    _pageNumberAudio = 1;
    _loading = false;
    _numberOfPostsPerRequest = 10;
    _nextPageTrigger = 3;
    _profileFeedPosts.clear();
    _profileFeedPostsAudio.clear();
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

  int tabIndex = 0;

  ProfileFeedModel _profileFeedData = ProfileFeedModel();
  List<ProfileFeedDatum> _profileFeedPosts = [];
  List<ProfileFeedDatum> _profileFeedPostsAudio = [];
  int get index => _index;
  bool get loadStatus => _loadStatus;
  bool get loadStatus2 => _loadStatus2;
  bool get loadStatusReferesh => _loadStatusReferesh;
  FeedData get feedData => _feedData;
  List<FeedPost> get feedPosts => _feedPosts;
  List<Data?> get feedStreamPosts => _feedStreamPosts;

  ProfileFeedModel get profileFeedData => _profileFeedData;
  List<ProfileFeedDatum> get profileFeedPosts => _profileFeedPosts;
  List<ProfileFeedDatum> get profileFeedPostsAudio => _profileFeedPostsAudio;

  void changeVisibility(bool val) {
    isVisible = val;
    notifyListeners();
  }

  Future changeTabIndex(int val) async {
    tabIndex = val;
    print(tabIndex);
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
    final preloadController = PreloadController.to;

    try {
      http.Response? response = await getFeedPost(pageNum).whenComplete(
          () => emitter("user feed posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get feed posts data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = FeedData.fromJson(jsonData["data"]);

        if (incomingData.data != null) {
          for (var element in incomingData.data!) {
            preloadController.addPreload(id: element.id!, vod: element.vod!);
          }
        }
        _feedData = incomingData;
        //  _feedData.data!.shuffle();
        //emitter(pageNum.toString());

        if (pageNum == 1) {
          _feedPosts = incomingData.data!;
          try {
            var lister = incomingData.data!
                .where((element) => !element.mux!.first.contains("https"))
                .toList();

            if (lister.isNotEmpty) {
              log("loading them");
              Future.forEach(
                  lister,
                  (element) =>
                      VideoWareHome.instance.getVideoFromApi(element.id!));
            }
          } catch (e) {
            log(e.toString());
          }

          // for (var element in _feedData.data!) {
          //   if (!element.media!.first.contains("https")) {
          //     log("loading them");
          //     VideoWareHome.instance.getVideoFromApi(element.id!);
          //   } else {}
          // }
        } else {
          _moreFeedPosts = incomingData.data!;
          _feedPosts.addAll(_moreFeedPosts);

          final data = _moreFeedPosts;
          try {
            var lister = incomingData.data!
                .where((element) => !element.mux!.first.contains("https"))
                .toList();

            if (lister.isNotEmpty) {
              log("loading them");
              Future.forEach(
                  lister,
                  (element) =>
                      VideoWareHome.instance.getVideoFromApi(element.id!));
            }
          } catch (e) {
            log(e.toString());
          }
          // for (var element in incomingData.data!) {
          //   if (!element.media!.first.contains("https")) {
          //     log("loading them");
          //     VideoWareHome.instance.getVideoFromApi(element.id!);
          //   } else {}
          // }
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
      log(e.toString());
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

  Future<bool> getUserPostAudioFromApi() async {
    log("GETTING AUDIO");
    late bool isSuccessful;
    List<ProfileFeedDatum> others = [];
    List<ProfileFeedDatum> mp3 = [];
    if (loading == true || _isLastPageAudio == true) return false;

    try {
      updateLoading(true);
      http.Response? response = await getUserFeedPost(
              _pageNumberAudio, _numberOfPostsPerRequest, "audios")
          .whenComplete(() => emitter("user audio data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        int recordCount = jsonData['record_count'];
        var incomingData = ProfileFeedModel.fromJson(jsonData);
        List<ProfileFeedDatum> newItems = incomingData.data!;

        // await Future.wait([
        //   Future.forEach(
        //       incomingData.data!,
        //       (element) => element.media!.first.contains(".mp3")
        //           ? mp3.add(element)
        //           : others.add(element))
        // ]);

        updateProfileFeedPostsAudio(newItems);
        // updateProfileFeedPostsAudio(newItems2);
        updatePageNumber(_pageNumberAudio + 1, true);
        updateIsLastPage((profileFeedPostsAudio.length) >= recordCount, true);

        if (_isLastPageAudio == true) {
          //pagingController.appendLastPage(newItems);
          pagingController.appendLastPage(newItems);
        } else {
          //  pagingController.appendPage(newItems, _pageNumber);
          pagingController.appendPage(newItems, _pageNumberAudio);
        }

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          VideoWare.instance.getVideoPostFromApi(_profileFeedPosts);
        });

        isSuccessful = true;
      } else {
        // log("get user posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      log(e.toString());
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
