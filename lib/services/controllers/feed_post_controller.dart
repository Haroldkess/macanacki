import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:macanacki/presentation/widgets/float_toast.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/network_controller.dart';
import 'package:macanacki/services/controllers/user_profile_controller.dart';
import 'package:macanacki/services/middleware/action_ware.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../model/feed_post_model.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../middleware/feed_post_ware.dart';
import 'action_controller.dart';

class FeedPostController {
  static Future<void> getFeedPostController(
      BuildContext context, int pageNum, bool isPaginating) async {
    FeedPostWare ware = Provider.of<FeedPostWare>(context, listen: false);

    if (isPaginating == true) {
      ware.isLoading(true);
    }

    bool isDone = await ware.getFeedPostFromApi(pageNum).whenComplete(
        () => emitter("everything from api and provider is done"));
    // ignore: use_build_context_synchronously
    //  VideosController.addVideosOffline(context);

    // ignore: use_build_context_synchronously

    if (isDone) {
      if (isPaginating == true) {
        ware.isLoading(false);
      }

      emitter("feed post stored");
    } else {
      if (isPaginating == true) {
        ware.isLoading(false);
        floatToast("Can't get more feed post", Colors.red.shade300);
      } else {
        floatToast("Can't get your feed", Colors.red.shade300);
      }

      // ignore: use_build_context_synchronously
      // showToast(context, "An error occured", Colors.red);
    }

    if (isPaginating == true) {
      ware.isLoading(false);
    }
  }

  static Future reloadPage(context) async {
    FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);
    provide.indexChange(0);

    provide.isLoadingReferesh(true);
    await FeedPostController.getFeedPostController(context, 1, false);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      //    FeedPostWare post = Provider.of<FeedPostWare>(context, listen: false);
      List<FeedPost> data = [];
      for (var i = 0; i < 5; i++) {
        data.add(provide.feedPosts[i]);
      }

      FeedPostController.downloadThumbs(
          data, context, MediaQuery.of(context).size.height);
      emitter('caching first ${data.length} sent');
    });
    //   SchedulerBinding.instance.addPostFrameCallback((_) {
    ActionController.retrievAllUserLikedController(context);
    // });
    //  SchedulerBinding.instance.addPostFrameCallback((_) {
    ActionController.retrievAllUserFollowingController(context);
    //  });
    //  SchedulerBinding.instance.addPostFrameCallback((_) {
    ActionController.retrievAllUserLikedCommentsController(context);
    provide.isLoadingReferesh(false);
  }

  static Future<void> getUserPostController(BuildContext context) async {
    FeedPostWare ware = Provider.of<FeedPostWare>(context, listen: false);
    ware.disposeValue2();
    ware.isLoading2(true);
    // ignore: use_build_context_synchronously
    bool isDone = await ware
        .getUserPostFromApi()
        .whenComplete(() => emitter("everything from api and provider is done"));
    // ignore: use_build_context_synchronously
    //  UserProfileController.retrievProfileController(context, false);

    if (isDone) {
      ware.isLoading2(false);
    } else {
      ware.isLoading2(false);

      // ignore: use_build_context_synchronously
      // showToast2(context, "Can't get your posts", isError: true);

      // ignore: use_build_context_synchronously

    }
    ware.isLoading2(false);
  }

  static Future<void> downloadVideos(
      List<FeedPost> data, BuildContext context) async {
    emitter("-------------------------------------------------");
    FeedPostWare ware = Provider.of<FeedPostWare>(context, listen: false);

    late bool _permissionReady;
    late String _localPath;
    late TargetPlatform? platform;
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    _permissionReady = await checkPermission(platform);
    if (_permissionReady) {
      _localPath = (await findLocalPath())!;
      await videoCatcher(platform, _localPath);
      emitter("Downloading to $_localPath");
      List<String> toBeAdded = [];
      List<String> val = [];
      emitter(
          "----------------STARTING THE CACHING PROCESS ---------------------------------");
      await Future.forEach(data, (element) async {
        // late File hold;

        for (var i = 0; i < element.media!.length; i++) {
          if (element.media == null || element.media!.isEmpty) {
          } else {
            try {
              List<FeedPost> check = ware.cachedPosts.where((el) {
                return el.media!.contains(element.media![i]);
              }).toList();
              if (check.isNotEmpty) {
                emitter("======== Already exists  ========");
              } else {
                var splitStrings = element.media![i].split(
                    "https:macarn.s3.eu-west-2.amazonaws.com/post/medias/");
                var rep = splitStrings.last.replaceAll("/", "");
                var finalPath = File('$_localPath/$rep');
                // print(splitStrings.first);
                // log(rep);

                final vid = await Dio().get(element.media![i],
                    options: Options(
                        responseType: ResponseType.bytes,
                        followRedirects: false,
                        receiveTimeout: 0));
                // var json = jsonDecode(vid.requestOptions.path);
                final raf = finalPath.openSync(mode: FileMode.write);
                raf.writeFromSync(vid.data);
                await raf.close();

                val.add(finalPath.path);

                toBeAdded.add(finalPath.path);
                if (i + 1 == element.media!.length) {
                  var newPost = FeedPost(
                    id: element.id,
                    description: element.description,
                    published: element.published,
                    createdAt: element.createdAt,
                    updatedAt: element.updatedAt,
                    btnLink: element.btnLink,
                    creator: element.creator,
                    media: element.media,
                    comments: element.comments,
                    noOfLikes: element.noOfLikes,
                    viewCount: element.viewCount,
                    button: element.button,
                    user: element.user,
                    media2: val,
                  ).toJson();
                  var jsonData = jsonDecode(jsonEncode(newPost));
                  FeedPost fresh = FeedPost.fromJson(jsonData);
                  emitter("======== DONE BY CACHE${fresh.media2}  ========");

                  await ware
                      .addCached(
                        fresh,
                      )
                      .whenComplete(() => val.clear());
                }

                emitter("Download Completed. ${finalPath.path}");
              }
            } catch (e) {
              emitter("Download Failed.\n\n" + e.toString());
            }
          }

          if (i % 5 == 0) {
            await Future.delayed(const Duration(minutes: 1))
                .whenComplete(() => emitter(" Can continue"));
          }
        }
      }).whenComplete(() => emitter("CACHE COMPLETED WAITING FOR NEXT BATCH"));
      return;
    }
  }

  static Future<void> downloadThumbs(
      List<FeedPost> data, BuildContext context, height) async {
    emitter("-------------------------------------------------");
    FeedPostWare ware = Provider.of<FeedPostWare>(context, listen: false);

    emitter(
        "----------------STARTING THE CACHING PROCESS ---------------------------------");
    List<String> storeThumb = [];
    await Future.forEach(data, (element) async {
      // late File hold;

      for (var i = 0; i < element.media!.length; i++) {
        if (element.media == null || element.media!.isEmpty) {
        } else {
          try {
            List<String> find = ware.thumbs.where((val) {
              return val.contains(element.media![i]);
            }).toList();
            if (element.media![i].contains(".mp4")) {
              if (find.isNotEmpty) {
                emitter("thumbnail Exists already");
              } else {
                String? thumbs = await genThumbnail(element.media![i], height);
                String newThumb = thumbs! + element.media![i];
                storeThumb.add(newThumb);
                if (i + 1 == element.media!.length) {
                  ware
                      .addThumbs(storeThumb)
                      .whenComplete(() => storeThumb.clear());
                }
              }
            } else {
              // emitter("not a video we are skip[ping] this one ");
            }
          } catch (e) {
            emitter("Download Failed.\n\n" + e.toString());
          }
        }

        // if (i % 5 == 0) {
        //   await Future.delayed(const Duration(minutes: 1))
        //       .whenComplete(() => emitter(" Can continue"));
        // }
      }
    }).whenComplete(() => emitter("CACHE COMPLETED WAITING FOR NEXT BATCH"));

    return;
  }

  static Future<String?> genThumbnail(String url, double height) async {
    late String name;
    try {
      final fileName = await VideoThumbnail.thumbnailFile(
        video: url,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP,
        maxHeight: height
            .toInt(), // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 75,
      );
      name = fileName!;
      emitter(fileName.toString());
    } catch (e) {
      emitter(e.toString());
    }

    return name;
  }

  static Future videoCatcher(TargetPlatform platform, String path) async {
    emitter(path);
    final savedDir = Directory(path);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  static Future<String?> findLocalPath() async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<bool> checkPermission(TargetPlatform platform) async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}
