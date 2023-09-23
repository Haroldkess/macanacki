import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:macanacki/model/public_user_follower_and_following_model.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../backoffice/user_profile_ext_office.dart';

class UserProfileExtWare extends ChangeNotifier {
  ////////////@@@AutoScroll [State]
  PagingController<int, PublicUserFollowerAndFollowingModel> pagingController =
      PagingController(firstPageKey: 1);
  bool _isLastPage = false;
  int _pageNumber = 1;
  bool _loading = false;
  int _numberOfPostsPerRequest = 10;
  int _nextPageTrigger = 3;
  ScrollController scrollController = ScrollController();
  List<PublicUserFollowerAndFollowingModel> _allPublicUserExtData = [];
  String _search = "";
  String _requestMode = "normal";
  String _username = "";

  //////////////////////////////////

  ////////////////////@@@AutoScroll [Getters]
  bool get loading => _loading;
  String get search => _search;
  String get requestMode => _requestMode;

  ////////////////////////////////////////////

  ////////////////////@@@@AutoScroll [Mutation]
  void updateLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void updateRequestMode(String value) {
    if (_requestMode == value) {
      return;
    } else {
      _requestMode = value;
      disposeAutoScroll();
      pagingController.refresh();
    }

    notifyListeners();
  }

  void updateSearch(String value) {
    _search = value;
    disposeAutoScroll();
    pagingController.refresh();
    if (value == "") updateRequestMode("normal");
    notifyListeners();
  }

  void updateIsLastPage(bool value) {
    _isLastPage = value;
    notifyListeners();
  }

  void initializePagingController() {
    pagingController = PagingController(firstPageKey: 1);
    disposeAutoScroll();
  }

  void updatePageNumber(int value) {
    _pageNumber = value;
    notifyListeners();
  }

  void updateUsername(String value) {
    _username = value;
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

  void updateAllPublicUserExtData(
      List<PublicUserFollowerAndFollowingModel> value) {
    _allPublicUserExtData.addAll(value);
    notifyListeners();
  }

  void disposeAutoScroll() {
    _isLastPage = false;
    _pageNumber = 1;
    _loading = false;
    _numberOfPostsPerRequest = 10;
    _nextPageTrigger = 3;
    _allPublicUserExtData.clear();
    notifyListeners();
  }

  ////////////////////////////////////////////////

  Future<bool> getUserPublicFollowersFromApi() async {
    late bool isSuccessful;
    if (loading == true || _isLastPage == true) return false;
    try {
      updateLoading(true);

      http.Response? response = await getUserPublicFollowers(
              _username, _pageNumber, _numberOfPostsPerRequest, _search)
          .whenComplete(() => emitter("user posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Yes, Gotten");
        final jsonData = jsonDecode(response.body);
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ${jsonData.toString()}");
        int recordCount = jsonData['record_count'];
        print("------------POSSSSSSSSSSSSSSSSSSSSt Total Count ${recordCount}");

        List<PublicUserFollowerAndFollowingModel> newItems = [];
        for (final x in jsonData['data']) {
          print("&&&&&&&&&&&&&&&& --- $x");
          newItems.add(PublicUserFollowerAndFollowingModel.fromJson(x));
        }
        emitter("doneeeeeeeeeeeeeeee looping");

        updateAllPublicUserExtData(newItems);
        updatePageNumber(_pageNumber + 1);
        updateIsLastPage(_allPublicUserExtData.length >= recordCount);

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
      emitter(e.toString());
    } finally {
      updateLoading(false);
    }

    notifyListeners();

    return isSuccessful;
  }

  Future<bool> getUserPublicFollowingsFromApi() async {
    print(
        "@@@@@@@@@@@@@@@@@@@@@@@@@@ Public [UserPost] Inside getUserPostFromApi");
    late bool isSuccessful;
    print(
        "@@@@@@@@@@@@@@@@@@@@@@@@@@ Public Before checking Loading and isLastPage");
    if (loading == true || _isLastPage == true) return false;

    print(
        "@@@@@@@@@@@@@@@@@@@@@@@@@@ Public After checking Loading and isLastPage");

    try {
      updateLoading(true);

      http.Response? response = await getUserPublicFollowings(
              _username, _pageNumber, _numberOfPostsPerRequest, _search)
          .whenComplete(() => emitter("user posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Yes, Gotten");
        final jsonData = jsonDecode(response.body);
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ${jsonData.toString()}");
        int recordCount = jsonData['record_count'];
        print("------------POSSSSSSSSSSSSSSSSSSSSt Total Count ${recordCount}");

        List<PublicUserFollowerAndFollowingModel> newItems = [];
        for (final x in jsonData['data']) {
          print("&&&&&&&&&&&&&&&& --- $x");
          newItems.add(PublicUserFollowerAndFollowingModel.fromJson(x));
        }

        updateAllPublicUserExtData(newItems);
        updatePageNumber(_pageNumber + 1);
        updateIsLastPage(_allPublicUserExtData.length >= recordCount);

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
