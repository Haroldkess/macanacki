import 'dart:developer';
// import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:macanacki/model/feed_post_model.dart';
import 'package:macanacki/presentation/widgets/tik_tok_view.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';

import '../../../../services/controllers/feed_post_controller.dart';
import '../../../../services/middleware/feed_post_ware.dart';
import '../../../../services/middleware/friends/friends_ware.dart';
import '../../../widgets/debug_emitter.dart';

class FriendsPageView extends StatefulWidget {
  int? index;
  FriendsPageView({super.key, this.index});

  @override
  State<FriendsPageView> createState() => _FriendsPageViewState();
}

class _FriendsPageViewState extends State<FriendsPageView> {
  PageController? controller;

  Future paginateFeed(context) async {
    emitter("Pageinating");
    FriendWare provide = FriendWare.instance;

    ///  provide.indexChange(index);

    // int checkNum = provide.feedPosts.length - 3; // lenght of posts
    int pageNum = provide.friends.value.currentPage!; // api current  page num
    int maxPages = provide.friends.value.lastPage!; // api last page num
    //  emitter("there");
    //  emitter(maxPages.toString());
    // emitter(pageNum.toString());

    if (pageNum >= maxPages) {
      emitter("cannot paginate");
      return;
    } else {
      //  emitter("PAGINTATING");
      if (provide.loadPost.value) {
        return;
      }
      await provide
          .getFriendsPostFromApi(pageNum + 1, true)
          .whenComplete(() => emitter("paginated"));
    }
  }

  @override
  Widget build(BuildContext context) {
    // var stream = FriendWare.instance.friendPost;
    FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);
//    controller = PageController(initialPage: stream.index, keepPage: true);
    PreloadPageController controller =
        PreloadPageController(initialPage: widget.index!, keepPage: true);

    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: ObxValue((stream) {
        return PreloadPageView.builder(
          itemCount: stream.length,
          controller: controller,
          preloadPagesCount: 0,
          scrollDirection: Axis.vertical,
          itemBuilder: ((context, index) {
            FeedPost post = stream[index];
            FeedPost? post2 =
                index + 1 < stream.length ? stream[index + 1] : null;
            FeedPost? post3 =
                index + 2 < stream.length ? stream[index + 2] : null;
            FeedPost? post4 =
                index + 3 < stream.length ? stream[index + 3] : null;

            return TikTokView(
              media: post.mux!,
              vod: post.vod!,
              data: post,
              isFriends: true,
              nextImage: [
                post2 == null ? null : post2.media!.first,
                post3 == null ? null : post3.media!.first,
                post4 == null ? null : post4.media!.first
              ],
              page: "feed",
              feedPosts: stream,
              index1: index,
              index2: index + 1,
              urls: post.media!,
              isHome: true,
              isInView: true,
              thumbails: post.thumbnails!,
            );
          }),
          onPageChanged: (index) {
            if (mounted) {
              if (index > stream.length - 5) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  paginateFeed(context);
                });
              }
            }
          },
        );
      }, FriendWare.instance.friendPost),
    );
  }

  // Future paginateFeed(BuildContext context) async {
  //   emitter("Pageinating");
  //   FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);

  //   ///  provide.indexChange(index);

  //   // int checkNum = provide.feedPosts.length - 3; // lenght of posts
  //   int pageNum = provide.feedData.currentPage!; // api current  page num
  //   int maxPages = provide.feedData.lastPage!; // api last page num
  //   //  emitter("there");
  //   //  emitter(maxPages.toString());
  //   // emitter(pageNum.toString());

  //   if (pageNum >= maxPages) {
  //     emitter("cannot paginate");
  //     return;
  //   } else {
  //     //  emitter("PAGINTATING");
  //     if (provide.loadStatus) {
  //       return;
  //     }
  //     await FeedPostController.getFeedPostController(context, pageNum + 1, true)
  //         .whenComplete(() => emitter("paginated"));
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  // @override
  // bool get wantKeepAlive => true;
}
