import 'package:apivideo_player/apivideo_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/preload/preload_controller.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import '../../../presentation/constants/colors.dart';
import '../../../presentation/constants/string.dart';
import '../../../presentation/widgets/debug_emitter.dart';
import '../../controllers/view_controller.dart';
import 'package:macanacki/services/backoffice/feed_post_office.dart';
import 'package:macanacki/model/feed_post_model.dart';
import 'dart:developer';
import 'dart:convert';

class VideoModel {
  int? id;
  Rx<ApiVideoPlayerController>? controller;
//  Rx<ApiVideoPlayerController>? controller;
  bool? inUse;
  // ChewieController? chewie;
  VideoModel({this.id, this.controller, this.inUse});
}

class SingleVideoModel {
  int? id;
  ApiVideoPlayerController? controller;
//  Rx<ApiVideoPlayerController>? controller;
  Rx<bool>? inUse;
  // ChewieController? chewie;
  SingleVideoModel({this.id, this.controller, this.inUse});
}

class VideoWare extends GetxController {
  final String url;
  final int postId;
  final int index;
  final bool isVideo;
  VideoWare(this.url, this.postId, this.isVideo, this.index);
  static VideoWare get instance {
    return Get.find<VideoWare>();
  }

  RxBool isFirst = false.obs;

  RxBool isLoadVideo = false.obs;

  RxBool hide = true.obs;
  RxBool paginating = false.obs;

  RxInt view2 = 0.obs;
  Rx<FeedData> feedData = FeedData().obs;

  RxList<FeedPost> feedPosts = <FeedPost>[].obs;
  RxList<FeedPost> feedPostsAudio = <FeedPost>[].obs;

  RxList<SingleVideoModel> allVideoController = <SingleVideoModel>[].obs;
  RxList<VideoModel> videoController = <VideoModel>[].obs;

  Rx<ChewieController> chewieController = ChewieController(
          videoPlayerController:
              VideoPlayerController.networkUrl(Uri.parse('')))
      .obs;

  @override
  void onInit() {
    // TODO: implement onInit
    if (isVideo) {
      initSomeVideo(url, postId, index);
    }
    super.onInit();
  }

  void changeFirst(bool val) {
    isFirst.value = val;
  }

  void loadVideo(bool val) {
    isLoadVideo.value = val;
  }

  void hideButtons() {
    hide.toggle();
  }

  void viewToggle(int val) {
    view2.value = val;
  }

  Future<void> addVideoToList(FeedPost data) async {
    feedPosts.removeWhere((element) => element.id == data.id);
    feedPosts.insert(0, data);
  }

  Future<void> addAudioToList(FeedPost data) async {
    feedPostsAudio.removeWhere((element) => element.id == data.id);
    feedPostsAudio.insert(0, data);
  }

  Future getVideoPostFromApi(List<dynamic> data) async {
    log("getting video posts");
    feedPosts.clear();
    feedPosts.value = [];
    List<FeedPost> newList = [];

    await Future.wait([
      Future.forEach(data, (x) {
        if (!x.mux.first.contains("https")) {
          List<Comment> talks = [];

          final User user = User(
              id: x.user!.id,
              email: x.user!.email,
              username: x.user!.username,
              faceVerification: x.user!.faceVerification,
              dob: x.user!.dob,
              emailVerified: x.user!.emailVerified,
              registrationComplete: x.user!.registrationComplete,
              emailVerifiedAt: x.user!.emailVerifiedAt,
              createdAt: x.user!.createdAt,
              updatedAt: x.user!.updatedAt,
              gender: x.user!.gender,
              profilephoto: x.user!.profilephoto,
              noOfFollowers: x.user!.noOfFollowers,
              noOfFollowing: x.user!.noOfFollowing,
              verified: x.user!.verified!);
          x.comments!.forEach((element) {
            Comment comment = Comment(
                id: element.id,
                body: element.body,
                createdAt: element.createdAt,
                updatedAt: element.updatedAt,
                username: element.username,
                profilePhoto: element.profilePhoto,
                noOfLikes: element.noOfLikes,
                postId: element.postId);

            talks.add(comment);
          });

          final FeedPost posting = FeedPost(
              id: x.id,
              description: x.description,
              published: x.published,
              createdAt: x.createdAt,
              updatedAt: x.updatedAt,
              creator: x.creator,
              media: x.media,
              mux: x.mux,
              vod: x.vod,
              comments: talks,
              noOfLikes: x.noOfLikes,
              btnLink: x.btnLink,
              button: x.button,
              viewCount: x.viewCount,
              thumbnails: x.thumbnails,
              user: user,
              promoted: x.promoted);
          feedPosts.add(posting);
        }
      })
    ]);

    for (var element in feedPosts) {
      final lister =
          videoController.where((item) => item.id == element.id).toList();
      if (lister.isEmpty) {
        addVideo(element.vod!.first, element.id!);
      }
    }
  }

  Future getAudioPostFromApi(List<dynamic> data) async {
    log("getting video posts");
    feedPostsAudio.clear();
    feedPostsAudio.value = [];
    List<FeedPost> newList = [];

    await Future.wait([
      Future.forEach(data, (x) {
        if (x.media.first.contains(".mp3")) {
          List<Comment> talks = [];

          final User user = User(
              id: x.user!.id,
              email: x.user!.email,
              username: x.user!.username,
              faceVerification: x.user!.faceVerification,
              dob: x.user!.dob,
              emailVerified: x.user!.emailVerified,
              registrationComplete: x.user!.registrationComplete,
              emailVerifiedAt: x.user!.emailVerifiedAt,
              createdAt: x.user!.createdAt,
              updatedAt: x.user!.updatedAt,
              gender: x.user!.gender,
              profilephoto: x.user!.profilephoto,
              noOfFollowers: x.user!.noOfFollowers,
              noOfFollowing: x.user!.noOfFollowing,
              verified: x.user!.verified!);
          x.comments!.forEach((element) {
            Comment comment = Comment(
                id: element.id,
                body: element.body,
                createdAt: element.createdAt,
                updatedAt: element.updatedAt,
                username: element.username,
                profilePhoto: element.profilePhoto,
                noOfLikes: element.noOfLikes,
                postId: element.postId);

            talks.add(comment);
          });

          final FeedPost posting = FeedPost(
              id: x.id,
              description: x.description,
              published: x.published,
              createdAt: x.createdAt,
              updatedAt: x.updatedAt,
              creator: x.creator,
              media: x.media,
              mux: x.mux,
              vod: x.vod,
              comments: talks,
              noOfLikes: x.noOfLikes,
              btnLink: x.btnLink,
              button: x.button,
              viewCount: x.viewCount,
              thumbnails: x.thumbnails,
              user: user,
              promoted: x.promoted);
          feedPostsAudio.add(posting);
        }
      })
    ]);

    // for (var element in feedPostsAudio) {
    //   final lister =
    //       videoController.where((item) => item.id == element.id).toList();
    //   if (lister.isEmpty) {
    //     addVideo(element.vod!.first, element.id!);
    //   }
    // }
  }

  Future initController(int id) async {
    loadVideo(true);
    final lister = videoController.where((item) => item.id == id).toList();

    if (lister.isNotEmpty) {
      lister.first.controller!.value.initialize().whenComplete(() {
        lister.first.controller!.value
            .addListener(ApiVideoPlayerControllerEventsListener(
          onReady: () {},
          onEnd: () {},
        ));
        loadVideo(false);
      });
    }
    update();
  }

  void initVideo(String link, int postId) async {
    final videoOptions =
        VideoOptions(videoId: link, type: VideoType.vod, token: null);

    Rx<ApiVideoPlayerController> vid = ApiVideoPlayerController(
            videoOptions: videoOptions, autoplay: false, onEnd: () {})
        .obs;
    videoController.add(VideoModel(id: postId, controller: vid));
    await Future.wait([initController(postId)])
        .then((value) => {emitter("initialized")});
    update();
  }

  void addVideo(String link, int postId) async {
    final videoOptions =
        VideoOptions(videoId: link, type: VideoType.vod, token: null);

    Rx<ApiVideoPlayerController> vid = ApiVideoPlayerController(
            videoOptions: videoOptions, autoplay: false, onEnd: () {})
        .obs;
    videoController.add(VideoModel(id: postId, controller: vid));
    update();
  }

  void addSingleVideo(
      ApiVideoPlayerController control, int postId, bool inUse) async {
    allVideoController.add(
        SingleVideoModel(id: postId, controller: control, inUse: inUse.obs));
    update();
  }

  void dismissSingleVideo(
      ApiVideoPlayerController control, int postId, bool inUse) async {
    allVideoController
        .where((p0) => p0.id == postId && p0.inUse!.value == true)
        .first
        .inUse!
        .value = false;
    update();

    List lister =
        allVideoController.where((p0) => p0.inUse!.value == false).toList();
    if (lister.isNotEmpty && lister.length > 1) {
      for (var element in allVideoController) {
        if (element.inUse!.value == false) {
          element.controller!.dispose();
        }
      }

      allVideoController.removeWhere((val) => val.id! == postId);
    }

    update();
  }

  void initSomeVideo(String link, int postId, int index) async {
    emitter("initializing");

    final lister = videoController.where((p0) => p0.id == postId).toList();

    if (lister.length > 1) {
      return;
    }

    if (lister.isNotEmpty) {
      await Future.wait([initController(lister.first.id!)])
          .then((value) => {emitter("initialized")});
      //  lister.first.controller!.play();
      update();
    } else {
      initVideo(link, postId);
      update();
    }
    update();
  }

  void addListeners(int id) async {
    var lister = videoController.where((item) => item.id == id).toList();

    if (lister.isNotEmpty) {
      if (lister.length > 1) {
        return;
      } else {
        if (lister.first.controller != null) {
          if (await lister.first.controller!.value.isPlaying) {
            try {
              lister.first.controller!.value
                  .addListener(ApiVideoPlayerControllerEventsListener(
                onReady: () {},
                onEnd: () {
                  if (view2.value == 0) {
                    ViewController.handleView(id);
                    view2.value = 1;
                  }
                  view2.value = 1;
                },
              ));
            } catch (e) {
              emitter(e.toString());
            }
          }
        }
      }
    }
  }

  Future<void> playAnyVideo() async {
    try {
      for (var element in videoController) {
        if (element.controller != null) {
          if (!await element.controller!.value.isPlaying) {
            element.controller!.value.play();
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> pauseAnyVideo() async {
    try {
      for (var element in videoController) {
        if (element.controller != null) {
          if (await element.controller!.value.isPlaying) {
            element.controller!.value.pause();
          } else {
            emitter("controller is not playing ");
          }
        } else {
          emitter("controller is null");
        }
      }
    } catch (e) {
      print(e);
    }
    // if (videoController
    //     .where((item) => item.id == id)
    //     .first
    //     .controller!
    //     .value
    //     .value
    //     .isInitialized) {
    //   videoController
    //       .where((item) => item.id == id)
    //       .first
    //       .controller!
    //       .value
    //       .pause();
    // }
  }

  Future disposeVideo(int id, String link) async {
    // if (videoController.value.value.isInitialized) {
    //   chewieController.value.videoPlayerController.dispose();
    loadVideo(false);
    final lister = videoController.where((item) => item.id == id).toList();

    if (lister.isNotEmpty) {
      lister.first.controller!.value.dispose();
      videoController.removeWhere((item) => item.id == id);
      addVideo(link, id);
      emitter("disposed");
    }

    //  }
  }

  void disposeAllVideo(int id, String link) async {
    // if (videoController.value.value.isInitialized) {
    //   chewieController.value.videoPlayerController.dispose();
    final lister = videoController.where((item) => item.id == id).toList();

    if (lister.isNotEmpty) {
      for (var element in videoController) {
        if (element.id == id) {
        } else {
          if (element.controller != null) {
            element.controller!.value.dispose();

            videoController.removeWhere((item) => item.id == element.id);
            addVideo(link, element.id!);
          }
        }
      }
      // lister.first.controller!.value.removeListener(() {});
      // lister.first.controller!.value.dispose();
      // videoController.removeWhere((item) => item.id == id);
      // addVideo(link, id);
      // emitter("disposed");
    }

    //  }
  }

  Future disposeAllVideoV2(int id, String link) async {
    // if (videoController.value.value.isInitialized) {
    //   chewieController.value.videoPlayerController.dispose();
    final lister = videoController.where((item) => item.id == id).toList();

    if (lister.isNotEmpty) {
      for (var element in videoController) {
        if (element.controller != null) {
          element.controller!.value.dispose();
          videoController.removeWhere((item) => item.id == element.id);
          addVideo(link, element.id!);
        }
      }
      // lister.first.controller!.value.removeListener(() {});
      // lister.first.controller!.value.dispose();
      // videoController.removeWhere((item) => item.id == id);
      // addVideo(link, id);
      // emitter("disposed");
    }

    //  }
  }
}

class VideoWareHome extends GetxController {
  final String url;
  final int postId;
  final int index;
  final bool isVideo;

  VideoWareHome(
    this.url,
    this.postId,
    this.isVideo,
    this.index,
  );
  static VideoWareHome get instance {
    return Get.find<VideoWareHome>();
  }

  RxBool isFirst = false.obs;

  RxBool hide = true.obs;
  RxBool paginating = false.obs;

  RxBool isLoadVideo = false.obs;

  RxInt view2 = 0.obs;
  Rx<FeedData> feedData = FeedData().obs;

  RxList<FeedPost> feedPosts = <FeedPost>[].obs;
  Rx<FeedData> feedAudioData = FeedData().obs;
  RxList<FeedPost> feedPostsAudio = <FeedPost>[].obs;

  RxList<VideoModel> videoController = <VideoModel>[].obs;
  Rx<ApiVideoPlayerController>? controller;

  // Rx<ChewieController> chewieController = ChewieController(
  //         videoPlayerController:
  //             VideoPlayerController.networkUrl(Uri.parse('')))
  //     .obs;

  @override
  void onInit() {
    // TODO: implement onInit
    if (isVideo) {
      initSomeVideo(url, postId, index);
    }
    super.onInit();
  }

  Future<void> buildVideoOptions(vod) async {
    // final token = apiToken.isEmpty ? null : apiToken;

    final videoOptions =
        VideoOptions(videoId: vod, type: VideoType.vod, token: "");

    if (controller == null) {
      controller!.value = ApiVideoPlayerController(
          videoOptions: videoOptions,
          autoplay: true,
          onEnd: () {},
          onReady: () {
            log("READY!!!");
          });
    } else {
      controller?.value.setVideoOptions(videoOptions);
    }

    await controller!.value.initialize();
  }

  Future<void> disVodController() async {
    await controller!.value.dispose();

    controller = null;
    update();
  }

  void changeFirst(bool val) {
    isFirst.value = val;
  }

  void hideButtons() {
    hide.toggle();
  }

  void viewToggle(int val) {
    view2.value = val;
  }

  void loadVideo(bool val) {
    isLoadVideo.value = val;
  }

  Future<void> addVideoToList(FeedPost data) async {
    feedPosts.removeWhere((element) => element.id == data.id);
    feedPosts.insert(0, data);
  }

  Future<void> addAudioToList(FeedPost data) async {
    feedPostsAudio.removeWhere((element) => element.id == data.id);
    feedPostsAudio.insert(0, data);
  }

  Future getVideoPostFromApi(int pageNum, [bool? load]) async {
    log("getting video posts");

    emitter(pageNum.toString());

    if (load == true) {
      paginating.value = true;
    }

    List<FeedPost> _moreFeedPosts = [];


    try {
      final preloadController = PreloadController.to;
      http.Response? response = await getVideoPost(pageNum).whenComplete(
          () => emitter("user feed video post  data gotten successfully"));
      if (response == null) {
        //   log("get feed posts data request failed");
        if (load == true) {
          paginating.value = false;
        }
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = FeedData.fromJson(jsonData["data"]);
        feedData.value = incomingData;

        // Martins
        if(incomingData.data != null){
          for (var element in incomingData.data!) {
            preloadController.addPreload(id: element.id!, vod: element.vod!);
          }
        }
        //  _feedData.data!.shuffle();
        //emitter(pageNum.toString());

        if (pageNum == 1) {
          feedPosts.value = feedData.value.data!;
          for (var element in feedPosts) {
            if (element != null) {
              var lister =
                  videoController.where((p0) => p0.id == element.id).toList();
              if (lister.isEmpty) {
                if (element.vod!.first != null) {
                  addVideo(element.mux!.first, element.id!);
                }
              }
            }
          }
        } else {
          _moreFeedPosts = incomingData.data!;
          feedPosts.addAll(_moreFeedPosts);
          for (var element in _moreFeedPosts) {
            if (element != null) {
              var lister =
                  videoController.where((p0) => p0.id == element.id).toList();
              if (lister.isEmpty) {
                if (element.vod!.first != null) {
                  addVideo("${element.vod!.first}", element.id!);
                }
              }
            }
          }
          // if (_moreFeedPosts.length > 5) {
          // //  _moreFeedPosts.shuffle();

          // } else {
          //   _feedPosts.addAll(_moreFeedPosts);
          // }
          if (load == true) {
            paginating.value = false;
          }
        }
        if (_moreFeedPosts.isNotEmpty) {
          _moreFeedPosts.clear();
        }

        //   await downloadThumbs(_feedPosts);

        //  log("get feed posts data  request success");
      } else {
        // log("get feed posts data  request failed");
      }
    } catch (e) {
      if (load == true) {
        paginating.value = false;
      }
      // log("get feed posts data  request failed");
      log(e.toString());
    }
    if (load == true) {
      paginating.value = false;
    }

    //notifyListeners();
  }

  Future getAudioPostFromApi(int pageNum, [bool? load]) async {
    log("getting audio posts");

    emitter(pageNum.toString());

    if (load == true) {
      paginating.value = true;
    }

    List<FeedPost> _moreFeedPosts = [];

    try {
      http.Response? response = await getAudioPost(pageNum)
          .whenComplete(() => emitter("audio post  data gotten successfully"));
      if (response == null) {
        //   log("get feed posts data request failed");
        if (load == true) {
          paginating.value = false;
        }
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = FeedData.fromJson(jsonData["data"]);
        feedAudioData.value = incomingData;

        if (pageNum == 1) {
          feedPostsAudio.value = feedAudioData.value.data!;
        } else {
          _moreFeedPosts = incomingData.data!;
          feedPostsAudio.addAll(_moreFeedPosts);

          if (load == true) {
            paginating.value = false;
          }
        }
        if (_moreFeedPosts.isNotEmpty) {
          _moreFeedPosts.clear();
        }
      } else {
        // log("get feed posts data  request failed");
      }
    } catch (e) {
      if (load == true) {
        paginating.value = false;
      }
      // log("get feed posts data  request failed");
      log(e.toString());
    }
    if (load == true) {
      paginating.value = false;
    }

    //notifyListeners();
  }

  Future getVideoFromApi(int id) async {
    log("getting video posts");

    try {
      final preloadController = PreloadController.to;
      http.Response? response = await getVideo(id).whenComplete(
          () => emitter(" SINGLE video post data gotten successfully"));
      if (response == null) {
        //   log("get feed posts data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = FeedData.fromJson(jsonData["data"]);
        // Martins
        if(incomingData.data != null){
          for (var element in incomingData.data!) {
            preloadController.addPreload(id: element.id!, vod: element.vod!);
          }
        }

        feedData.value = incomingData;
        // Rx<FeedPost>? data = feedData.value.data.f;
        //  _feedData.data!.shuffle();
        //emitter(pageNum.toString());

        var lister = feedPosts
            .where((p0) => p0.id == feedData.value.data!.first.id)
            .toList();
        if (lister.isEmpty) {
          feedPosts.add(feedData.value.data!.first);
          emitter("Added");
        }
      } else {
        // log("get feed posts data  request failed");
      }
    } catch (e) {
      // log("get feed posts data  request failed");
      log(e.toString());
    }

    //notifyListeners();
  }

  Future initController(
    int id,
  ) async {
    loadVideo(true);
    final lister = videoController.where((item) => item.id == id).toList();

    if (lister.isNotEmpty) {
      lister.first.controller!.value.initialize().whenComplete(() {
        lister.first.controller!.value
            .addListener(ApiVideoPlayerControllerEventsListener(
          onReady: () {
            lister.first.controller!.value.play();
            update();
          },
          onEnd: () {},
        ));
        loadVideo(false);
      });
    }
    update();
  }

  void initVideo(String link, int postId) async {
    final videoOptions =
        VideoOptions(videoId: link, type: VideoType.vod, token: null);

    Rx<ApiVideoPlayerController> vid = ApiVideoPlayerController(
            videoOptions: videoOptions, autoplay: false, onEnd: () {})
        .obs;
    videoController.add(VideoModel(id: postId, controller: vid));
    await Future.wait([initController(postId)])
        .then((value) => {emitter("initialized")});
    update();
  }

  void addVideo(String link, int postId) async {
    final videoOptions =
        VideoOptions(videoId: link, type: VideoType.vod, token: null);

    Rx<ApiVideoPlayerController> vid = ApiVideoPlayerController(
            videoOptions: videoOptions, autoplay: false, onEnd: () {})
        .obs;
    videoController.add(VideoModel(id: postId, controller: vid));
    update();
  }

  void initSomeVideo(String link, int postId, int index) async {
    emitter("initializing");

    final lister = videoController.where((p0) => p0.id == postId).toList();

    if (lister.length > 1) {
      return;
    }

    if (lister.isNotEmpty) {
      await Future.wait([initController(lister.first.id!)])
          .then((value) => {emitter("initialized")});
      //  lister.first.controller!.play();
      update();
    } else {
      initVideo(link, postId);
      update();
    }
    update();
  }

  void addListeners(int id) async {
    var lister = videoController.where((item) => item.id == id).toList();

    if (lister.isNotEmpty) {
      if (lister.length > 1) {
        return;
      } else {
        if (lister.first.controller != null) {
          if (await lister.first.controller!.value.isPlaying) {
            try {
              lister.first.controller!.value
                  .addListener(ApiVideoPlayerControllerEventsListener(
                onReady: () {},
                onEnd: () {
                  if (view2.value == 0) {
                    ViewController.handleView(id);
                    view2.value = 1;
                  }
                  view2.value = 1;
                },
              ));
            } catch (e) {
              emitter(e.toString());
            }
          }
        }
      }
    }
  }

  Future<void> playAnyVideo() async {
    try {
      for (var element in videoController) {
        if (element.controller != null) {
          if (!await element.controller!.value.isCreated) {
            element.controller!.value.play();
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> pauseAnyVideo() async {
    try {
      for (var element in videoController) {
        if (element.controller != null) {
          if (await element.controller!.value.isPlaying) {
            element.controller!.value.pause();
          } else {
            emitter("controller is not playing ");
          }
        } else {
          emitter("controller is null");
        }
      }
    } catch (e) {
      print(e);
    }
    // if (videoController
    //     .where((item) => item.id == id)
    //     .first
    //     .controller!
    //     .value
    //     .value
    //     .isInitialized) {
    //   videoController
    //       .where((item) => item.id == id)
    //       .first
    //       .controller!
    //       .value
    //       .pause();
    // }
  }

  Future disposeVideo(int id, String link) async {
    // if (videoController.value.value.isInitialized) {
    //   chewieController.value.videoPlayerController.dispose();
    loadVideo(false);
    final lister = videoController.where((item) => item.id == id).toList();

    if (lister.isNotEmpty) {
      lister.first.controller!.value.dispose();
      videoController.removeWhere((item) => item.id == id);
      addVideo(link, id);
      emitter("disposed");
    }

    //  }
  }

  void disposeAllVideo(int id, String link) async {
    // if (videoController.value.value.isInitialized) {
    //   chewieController.value.videoPlayerController.dispose();
    final lister = videoController.where((item) => item.id == id).toList();

    if (lister.isNotEmpty) {
      for (var element in videoController) {
        if (element.id == id) {
        } else {
          if (element.controller != null) {
            element.controller!.value.dispose();

            videoController.removeWhere((item) => item.id == element.id);
            addVideo(link, element.id!);
          }
        }
      }
      // lister.first.controller!.value.removeListener(() {});
      // lister.first.controller!.value.dispose();
      // videoController.removeWhere((item) => item.id == id);
      // addVideo(link, id);
      // emitter("disposed");
    }

    //  }
  }

  Future disposeAllVideoV2(int id, String link) async {
    // if (videoController.value.value.isInitialized) {
    //   chewieController.value.videoPlayerController.dispose();
    final lister = videoController.where((item) => item.id == id).toList();

    if (lister.isNotEmpty) {
      for (var element in videoController) {
        if (element.controller != null) {
          element.controller!.value.dispose();
          videoController.removeWhere((item) => item.id == element.id);
          addVideo(link, element.id!);
        }
      }
      // lister.first.controller!.value.removeListener(() {});
      // lister.first.controller!.value.dispose();
      // videoController.removeWhere((item) => item.id == id);
      // addVideo(link, id);
      // emitter("disposed");
    }

    //  }
  }
}

class VodWare extends GetxController {
  final dynamic url;

  VodWare(
    this.url,
  );
  static VodWare get instance {
    return Get.find<VodWare>();
  }

  Rx<ApiVideoPlayerController>? controller = ApiVideoPlayerController(
          videoOptions: VideoOptions(videoId: "", type: VideoType.vod))
      .obs;

  // Rx<ChewieController> chewieController = ChewieController(
  //         videoPlayerController:
  //             VideoPlayerController.networkUrl(Uri.parse('')))
  //     .obs;

  @override
  void onInit() {
    // TODO: implement onInit
    buildVideoOptions(url);
    super.onInit();
  }

  @override
  void onClose() {
    disVodController();
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> buildVideoOptions(vod) async {
    // final token = apiToken.isEmpty ? null : apiToken;

    if (vod == null) {
    } else {
      final videoOptions =
          VideoOptions(videoId: vod, type: VideoType.vod, token: "");

      //  if (controller == null) {
      controller!.value = ApiVideoPlayerController(
          videoOptions: videoOptions,
          autoplay: true,
          onEnd: () {},
          onReady: () {
            log("READY!!!");
          });
      // } else {
      //   controller?.value.setVideoOptions(videoOptions);
      // }

      await controller!.value.initialize();
    }
  }

  Future<void> disVodController() async {
    await controller!.value.dispose();

    controller = null;
    update();
  }
}
