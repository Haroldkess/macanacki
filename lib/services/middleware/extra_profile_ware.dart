import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:macanacki/model/public_profile_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/services/backoffice/user_profile_office.dart';
import 'package:macanacki/services/middleware/video/video_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';

import '../../model/gender_model.dart';
import '../../model/register_model.dart';
import '../../model/user_profile_model.dart';
import '../../presentation/screens/onboarding/business/business_modal.dart';
import '../../presentation/widgets/debug_emitter.dart';

// class AllProfile extends ChangeNotifier {
//   List<ExtraProfileWare> profiles = [];

//   void addToList(ExtraProfileWare extra) {
//     List<ExtraProfileWare> checkList =
//         profiles.where((element) => element.uniqueName.toLowerCase() == extra.uniqueName.toLowerCase()).toList();
//   }
// }

class ProfilesController extends GetxController {
  static ProfilesController get instance {
    return Get.find<ProfilesController>();
  }

  RxList<OtherUsers> profiles = <OtherUsers>[].obs;

  Future<void> addToProfileList(OtherUsers extra) async {
    List<OtherUsers> checkList = profiles
        .where((element) =>
            element.uniqueName.toLowerCase() == extra.uniqueName.toLowerCase())
        .toList();

    if (checkList.isEmpty) {
      profiles.add(extra);
    } else {
      // profiles.removeWhere((element) =>
      //     element.uniqueName.toLowerCase() == extra.uniqueName.toLowerCase());
      profiles.insert(0, extra);
    }
    update();
  }
}

class OtherUsers {
  String uniqueName;
  List<PagingController<int, PublicUserPost>>? paging;
  List<PublicUserPost>? pubPost;
  List<PublicUserPost>? pubPostAudio;
  PublicUserData? publicUserProfileModel;

  OtherUsers(
      {required this.uniqueName,
      required this.paging,
      required this.pubPost,
      required this.pubPostAudio,
      required this.publicUserProfileModel});
}

class ExtraProfileWare extends ChangeNotifier {
  List<OtherUsers> profiles = [];
  ////////////@@@AutoScroll [State]
  PagingController<int, PublicUserPost> pagingController =
      PagingController(firstPageKey: 0);
  PagingController<int, PublicUserPost> pagingController2 =
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
  List<PublicUserPost> _allPublicUserPostData = [];
  List<PublicUserPost> _allPublicUserPostDataAudio = [];

  //////////////////////////////////

  ////////////////////@@@AutoScroll [Getters]
  bool get loading => _loading;
  bool get loadingAudio => _loadingAudio;
  List<PublicUserPost> get pubPost => _allPublicUserPostData;
  List<PublicUserPost> get pubPostAudio => _allPublicUserPostDataAudio;

  ////////////////////////////////////////////

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

  void initializePagingController() {
    pagingController = PagingController(firstPageKey: 1);
    pagingController2 = PagingController(firstPageKey: 1);
    disposeAutoScroll();
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

  void updateAllPublicUserPostData(List<PublicUserPost> value) {
    _allPublicUserPostData.addAll(value);
    notifyListeners();
  }

  void updateAllPublicUserPostDataAudio(List<PublicUserPost> value) {
    _allPublicUserPostDataAudio.addAll(value);
    notifyListeners();
  }

  void disposeAutoScroll() {
    _isLastPage = false;
    _pageNumber = 1;
    _pageNumberAudio = 1;
    _loading = false;
    _isLastPageAudio = false;
    _numberOfPostsPerRequest = 10;
    _nextPageTrigger = 3;

    _allPublicUserPostData.clear();
    _allPublicUserPostDataAudio.clear();
    notifyListeners();
  }

  ////////////////////////////////////////////////

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

  Future<void> saveBusinessInfoOnly(
    RegisterBusinessModel r,
  ) async {
    registerBusinessModel = r;

    notifyListeners();
  }

  Future<void> saveInfo(
    VerifyUserModel v,
    GenderList g,
  ) async {
    verifyUserModel = v;
    genderData = g;

    notifyListeners();
  }

  Future<void> saveInfoIndi(
    VerifyUserModel v,
  ) async {
    verifyUserModel = v;

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
        try {
          if (incomingData.data!.verified == 1 &&
              incomingData.data!.activePlan != sub) {
            Temp temp = Provider.of(context, listen: false);
            temp.addSubStatusTemp(true);
          } else {
            Temp temp = Provider.of(context, listen: false);
            temp.addSubStatusTemp(false);
          }
        } catch (e) {
          emitter(e.toString());
        }

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

    //notifyListeners();

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

  Future<bool> getUserPublicPostFromApi({required String username}) async {
    late bool isSuccessful;
    if (loading == true || _isLastPage == true) return false;

    try {
      updateLoading(true);
      // final username = publicUserProfileModel.username ?? '';
      http.Response? response = await getUserPublicPost(
              username, _pageNumber, _numberOfPostsPerRequest, "videos_images")
          .whenComplete(() => emitter("user posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        int recordCount = jsonData['record_count'];
        List<PublicUserPost> newItems = [];
        for (final x in jsonData['data']) {
          newItems.add(PublicUserPost.fromJson(x));
        }

        updateAllPublicUserPostData(newItems);
        updatePageNumber(_pageNumber + 1, false);
        updateIsLastPage(_allPublicUserPostData.length >= recordCount, false);

        if (_isLastPage == true) {
          pagingController.appendLastPage(newItems);
        } else {
          pagingController.appendPage(newItems, _pageNumber);
        }

        OtherUsers profileData = OtherUsers(
            uniqueName: publicUserProfileModel.username!,
            paging: [pagingController, pagingController2],
            pubPost: _allPublicUserPostData,
            pubPostAudio: pubPostAudio,
            publicUserProfileModel: publicUserProfileModel);
        await addToProfileList(profileData);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          VideoWare.instance.getVideoPostFromApi(_allPublicUserPostData);
        });

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

  Future<void> addToProfileList(OtherUsers extra) async {
    await ProfilesController.instance.addToProfileList(extra);
  }

  Future<bool> getUserPublicPostAudioFromApi({required String username}) async {
    late bool isSuccessful;
    if (loadingAudio == true || _isLastPageAudio == true) return false;

    try {
      updateLoadingAudio(true);
      // final username = publicUserProfileModel.username ?? '';
      http.Response? response = await getUserPublicPost(
              username, _pageNumberAudio, _numberOfPostsPerRequest, "audios")
          .whenComplete(() => emitter("user posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        int recordCount = jsonData['record_count'];
        List<PublicUserPost> newItems = [];
        for (final x in jsonData['data']) {
          newItems.add(PublicUserPost.fromJson(x));
        }

        updateAllPublicUserPostDataAudio(newItems);
        updatePageNumber(_pageNumberAudio + 1, true);
        updateIsLastPage(
            _allPublicUserPostDataAudio.length >= recordCount, true);

        if (_isLastPageAudio == true) {
          pagingController2.appendLastPage(newItems);
        } else {
          pagingController2.appendPage(newItems, _pageNumberAudio);
        }

        OtherUsers profileData = OtherUsers(
            uniqueName: publicUserProfileModel.username!,
            paging: [pagingController, pagingController2],
            pubPost: _allPublicUserPostData,
            pubPostAudio: _allPublicUserPostDataAudio,
            publicUserProfileModel: publicUserProfileModel);
        await addToProfileList(profileData);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          VideoWare.instance.getAudioPostFromApi(_allPublicUserPostDataAudio);
        });

        isSuccessful = true;
      } else {
        // log("get user posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    } finally {
      updateLoadingAudio(false);
    }

    notifyListeners();

    return isSuccessful;
  }
}
