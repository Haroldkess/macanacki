import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makanaki/model/all_liked_model.dart';
import 'package:makanaki/model/comments_model.dart';
import 'package:makanaki/model/following_model.dart';
import 'package:makanaki/model/reg_email_model.dart';
import 'package:makanaki/presentation/widgets/debug_emitter.dart';
import 'package:makanaki/services/backoffice/actions_office.dart';
import 'package:makanaki/services/backoffice/registeration_office.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/register_model.dart';
import '../../presentation/widgets/snack_msg.dart';
import '../temps/temps_id.dart';

class ActionWare extends ChangeNotifier {
  bool _loadStatus = false;
  bool _loadStatus2 = false;
  bool _loadStatus3 = false;
  bool _isDoubleTapped = false;

  bool _loadStatusFollower = false;

  bool _loadStatusAllLiked = false;
  bool _loadStatusAllComments = false;
  bool _loadStatusAllFollowing = false;

  String _message = 'Something went wrong';
  String _message2 = 'Something went wrong';
  String _token = "";

  List<int> _likeIds = [];
  List<int> _followIds = [];
  List<int> _commentIds = [];
  List<AllLikedData> _allLikedData = [];
  List<FollowingData> _allFollowingData = [];
  List<LikedCommentData> _allLikedCommentData = [];
  int _addLike = 1;

  List<AllLikedData> get allLiked => _allLikedData;
  List<FollowingData> get allFollowing => _allFollowingData;
  List<LikedCommentData> get allLikedComments => _allLikedCommentData;
  int get addLike => _addLike;
  List<int> get likeIds => _likeIds;
  List<int> get followIds => _followIds;
  List<int> get commentId => _commentIds;

  String get message => _message;
  String get message2 => _message2;

  bool get loadStatus => _loadStatus;
  bool get isDoubleTapped => _isDoubleTapped;

  bool get loadStatus2 => _loadStatus2;
  bool get loadStatus3 => _loadStatus3;
  bool get loadStatusFollower => _loadStatusFollower;

  bool get loadStatusAllLiked => _loadStatusAllLiked;

  bool get loadStatusAllComments => _loadStatusAllComments;
  bool get loadStatusAllFollowing => _loadStatusAllFollowing;

  void disposeValue() async {
    _likeIds.clear();
    _followIds.clear();
    _commentIds.clear();
    _allLikedData.clear();
    _allFollowingData.clear();
    _allLikedCommentData.clear();

    _likeIds = [];
    _followIds = [];
    _commentIds = [];
    _allLikedData = [];
    _allFollowingData = [];
    _allLikedCommentData = [];
    notifyListeners();
  }

  void addTapped(bool tap) {
    _isDoubleTapped = tap;
    notifyListeners();
  }

  Future<void> tempAddLikeId(int id) async {
    if (_likeIds.contains(id)) {
      _likeIds.removeWhere((element) => id == element);
    } else {
      _likeIds.add(id);
    }

    notifyListeners();
  }

  Future<void> addLikeId(int id) async {
    if (_likeIds.contains(id)) return;
    _likeIds.add(id);

    notifyListeners();
  }

  Future<void> removeLikeId(int id) async {
    _likeIds.removeWhere((element) => id == element);

    notifyListeners();
  }

  Future<void> addFollowId(int id) async {
    if (_followIds.contains(id)) return;

    _followIds.add(id);

    notifyListeners();
  }

  Future<void> removeFollowId(int id) async {
    _followIds.removeWhere((element) => id == element);

    notifyListeners();
  }

   Future<void> performOfflineFollow(int id) async {
    if (_followIds.contains(id)) {
      _followIds.removeWhere((element) => id == element);
    } else {
      _followIds.add(id);
    }

    //  log(_commentIds.toString());

    notifyListeners();
  }


  Future<void> addCommentId(int id) async {
    if (_commentIds.contains(id)) {
      _commentIds.removeWhere((element) => id == element);
    } else {
      _commentIds.add(id);
    }

    //  log(_commentIds.toString());

    notifyListeners();
  }

  Future<void> isLoading(bool isLoad) async {
    _loadStatus = isLoad;
    notifyListeners();
  }

  Future<void> isLoadingFollow(bool isLoad) async {
    _loadStatusFollower = isLoad;
    notifyListeners();
  }

  Future<void> isLoading2(bool isLoad2) async {
    _loadStatus2 = isLoad2;
    notifyListeners();
  }

  Future<void> isLoading3(bool isLoad3) async {
    _loadStatus3 = isLoad3;
    notifyListeners();
  }

  Future<void> isLoadingAllLikes(bool status) async {
    _loadStatusAllLiked = status;
    notifyListeners();
  }

  Future<void> isLoadingAllComments(bool status) async {
    _loadStatusAllComments = status;
    notifyListeners();
  }

  Future<void> isLoadingAllFollowing(bool status) async {
    _loadStatusAllFollowing = status;
    notifyListeners();
  }

  Future<bool> followOrUnFollowFromApi(
    String username,
    int userId,
  ) async {
    late bool isSuccessful;
    try {
      http.Response? response = await followAndUnfollow(username)
          .whenComplete(() => log("Follow request done"));
      if (response == null) {
        _message = "Something went wrong";
        isSuccessful = false;
        //   log("Follow request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        _message = jsonData["message"].toString();
        //   log("Follow request success");
        isSuccessful = true;
      } else {
        var jsonData = jsonDecode(response.body);
        _message = jsonData["message"].toString();
        //    log("Follow request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //   log("Follow request failed");
      //   log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> likeOrDislikeromApi(
    int postId,
  ) async {
    late bool isSuccessful;
    try {
      http.Response? response = await likeOrDislike(postId)
          .whenComplete(() => emitter("like action request done"));
      if (response == null) {
        isSuccessful = false;
        emitter("like action request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        _message2 = jsonData["message"];
        // if (jsonData["message"] == "Post Liked") {
        //   log("like ooooo ${jsonData["data"][0]["post_id"]}");
        //   if (!_likeIds.contains(jsonData["data"][0]["post_id"])) {
        //     _likeIds.add(jsonData["data"][0]["post_id"]);
        //   }
        // } else {}

        //  log("like action request success");
        isSuccessful = true;
      } else {
        //   log("like action request failed");
        // ignore: use_build_context_synchronously
        //showToast(context, ain"something went wrong. pls try ag", Colors.red);
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //  log("like action request failed");
      //  log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> likeCommentFromApi(
    int postId,
    int commentId,
  ) async {
    late bool isSuccessful;
    try {
      http.Response? response = await likeComment(postId, commentId)
          .whenComplete(() => emitter("like action request done"));
      if (response == null) {
        isSuccessful = false;
        //  log("like action request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData["message"] == "Comment Liked") {
          //  log("comment ooooo ${jsonData["data"][0]["comment_id"]}");
          if (!_commentIds.contains(jsonData["data"][0]["comment_id"])) {
            _commentIds.add(jsonData["data"][0]["comment_id"]);
          }
        } else {}

        // log("like action request success");
        isSuccessful = true;
      } else {
        // log("like action request failed");
        // ignore: use_build_context_synchronously
        //showToast(context, ain"something went wrong. pls try ag", Colors.red);
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //  log("like action request failed");
      // log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  // get following, post likes, commentlikes,

  Future<bool> getlikeFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getAllLikedPost()
          .whenComplete(() => emitter("get likes action request done"));
      if (response == null) {
        isSuccessful = false;
        //   log("get likes action request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        LikededModel incommingData = LikededModel.fromJson(jsonData);
        _allLikedData = incommingData.data!;

        //  log("get likes action request success");
        isSuccessful = true;
      } else {
        //  log("get likes action request failed");
        // ignore: use_build_context_synchronously
        //showToast(context, ain"something went wrong. pls try ag", Colors.red);
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //   log("get likes action request failed");
      //  log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> getLikeCommentFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getAllLikedComment()
          .whenComplete(() => emitter("coment likes  action request done"));
      if (response == null) {
        isSuccessful = false;
        //  log("coment likes action request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        LikedCommentModel incommingData = LikedCommentModel.fromJson(jsonData);
        _allLikedCommentData = incommingData.data!;

        // log("coment likes action request success");
        isSuccessful = true;
      } else {
        // log("coment likes action request failed");
        // ignore: use_build_context_synchronously
        //showToast(context, ain"something went wrong. pls try ag", Colors.red);
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      // log("coment likes action request failed");
      // log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> getFollowingFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getAllFollowing()
          .whenComplete(() => emitter("all following action request done"));
      if (response == null) {
        isSuccessful = false;
          emitter("all following  action request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        FollowingModel incommingData = FollowingModel.fromJson(jsonData);
        _allFollowingData = incommingData.data!;

        //  log("all following  action request success");
        isSuccessful = true;
      } else {
         emitter("all following  action request failed");
        // ignore: use_build_context_synchronously
        //showToast(context, ain"something went wrong. pls try ag", Colors.red);
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //   log("all following  action request failed");
        emitter(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> getFollowersFromApi() async {
    late bool isSuccessful;
    try {
      http.Response? response = await getAllFollowers()
          .whenComplete(() => emitter("all followers action request done"));
      if (response == null) {
        isSuccessful = false;
        //   log("all following  action request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        FollowingModel incommingData = FollowingModel.fromJson(jsonData);
        _allFollowingData = incommingData.data!;

        // log("all followers  action request success");
        isSuccessful = true;
      } else {
        //  log("all followers  action request failed");
        // ignore: use_build_context_synchronously
        //showToast(context, ain"something went wrong. pls try ag", Colors.red);
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
      //  log("all following  action request failed");
      // log(e.toString());
    }

    notifyListeners();

    return isSuccessful;
  }
}
