import 'dart:convert';
import 'dart:developer';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:macanacki/preload/preload_controller.dart';
import '../../../model/feed_post_model.dart';
import '../../../presentation/widgets/debug_emitter.dart';
import '../../backoffice/feed_post_office.dart';

class FriendWare extends GetxController {
  static FriendWare get instance {
    return Get.find<FriendWare>();
  }

  RxBool loadPost = false.obs;

  Rx<FeedData> friends = FeedData().obs;

  RxList<FeedPost> friendPost = <FeedPost>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit

    getFriendsPostFromApi(1);
    super.onInit();
  }

  Future getFriendsPostFromApi(int pageNum, [bool? load]) async {
    log("getting video posts");

    emitter(pageNum.toString());

    if (load == true) {
      loadPost.value = true;
    }

    List<FeedPost> _moreFeedPosts = [];
    final preloadController = PreloadController.to;

    try {
      http.Response? response = await getFriendsPost(pageNum).whenComplete(
          () => emitter("friends  post  data gotten successfully"));
      if (response == null) {
        //   log("get feed posts data request failed");
        if (load == true) {
          loadPost.value = false;
        }
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        var incomingData = FeedData.fromJson(jsonData["data"]);

        // Martins
        if (incomingData.data != null) {
          if (incomingData.data!.isNotEmpty) {
            for (var element in incomingData.data!) {
              preloadController.addPreload(
                  id: element.id!, vod: element.vod ?? [""]);
            }
          }
        }
        friends.value = incomingData;
        //  _feedData.data!.shuffle();
        //emitter(pageNum.toString());

        if (pageNum == 1) {
          friendPost.value = friends.value.data!;
        } else {
          _moreFeedPosts = incomingData.data!;
          //  friendPost = [...friendPost , ..._moreFeedPosts].distinct();
          friendPost.addAll(_moreFeedPosts);

          if (load == true) {
            loadPost.value = false;
          }
        }
        if (_moreFeedPosts.isNotEmpty) {
          _moreFeedPosts.clear();
        }
      } else {}
    } catch (e) {
      if (load == true) {
        loadPost.value = false;
      }

      log(e.toString());
    }
    if (load == true) {
      loadPost.value = false;
    }
  }
}
