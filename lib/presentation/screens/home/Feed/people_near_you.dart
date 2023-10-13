import 'dart:developer';
// import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:macanacki/model/common/data.dart';
import 'package:macanacki/model/feed_post_model.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/tik_tok_view.dart';
import 'package:path/path.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';
import '../../../../services/backoffice/mux_client.dart';
import '../../../../services/controllers/feed_post_controller.dart';
import '../../../../services/middleware/feed_post_ware.dart';
import '../../../constants/colors.dart';
import '../../../constants/string.dart';
import '../../../uiproviders/screen/find_people_provider.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/debug_emitter.dart';

class PeopleHome extends StatefulWidget {
  const PeopleHome({super.key});

  @override
  State<PeopleHome> createState() => _PeopleHomeState();
}

class _PeopleHomeState extends State<PeopleHome> {
  PageController? controller;

  @override
  Widget build(BuildContext context) {
    FeedPostWare stream = context.watch<FeedPostWare>();
    FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);
//    controller = PageController(initialPage: stream.index, keepPage: true);
    PreloadPageController controller =
        PreloadPageController(initialPage: stream.index, keepPage: true);

    return SizedBox(
      height: Get.height,
      width: Get.width,
      child: stream.feedPosts.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      LottieBuilder.asset("assets/icon/nodata.json"),
                      stream.loadStatus
                          ? Loader(color: HexColor(primaryColor))
                          : AppButton(
                              width: 0.5,
                              height: 0.06,
                              color: backgroundColor,
                              text: "Reload",
                              backColor: primaryColor,
                              curves: buttonCurves * 5,
                              textColor: backgroundColor,
                              onTap: () async {
                                await FeedPostController.getFeedPostController(
                                    context, 1, true);
                                //  PageRouting.pushToPage(context, const BusinessVerification());
                              }),
                    ],
                  ),
                )
              ],
            )
          : PreloadPageView.builder(
              itemCount: stream.feedPosts.length,
              controller: controller,
              preloadPagesCount: 0,
              scrollDirection: Axis.vertical,
              itemBuilder: ((context, index) {
                FeedPost post = stream.feedPosts[index];
                FeedPost? post2 = index + 1 < stream.feedPosts.length
                    ? stream.feedPosts[index + 1]
                    : null;
                FeedPost? post3 = index + 2 < stream.feedPosts.length
                    ? stream.feedPosts[index + 2]
                    : null;
                FeedPost? post4 = index + 3 < stream.feedPosts.length
                    ? stream.feedPosts[index + 3]
                    : null;

                return TikTokView(
                  media: post.mux!,
                  data: post,
                  nextImage: [
                    post2 == null ? null : post2.media!.first,
                    post3 == null ? null : post3.media!.first,
                    post4 == null ? null : post4.media!.first
                  ],
                  page: "feed",
                  feedPosts: stream.feedPosts,
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
                  if (index > stream.feedPosts.length - 5) {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      paginateFeed(context);
                    });
                  }
                  // SchedulerBinding.instance.addPostFrameCallback((_) {
                  //   FeedPostWare postLenght =
                  //       Provider.of<FeedPostWare>(context, listen: false);
                  //   if (index % 1 == 0) {
                  //     List<FeedPost> toSend = [];

                  //     for (var i = index; i < (stream.feedPosts.length); i++) {
                  //       toSend.add(postLenght.feedPosts[i]);
                  //     }
                  //     emitter("sending ${toSend.length} posts for caching");
                  //     FeedPostController.downloadThumbs(
                  //         toSend, context, MediaQuery.of(context).size.height);
                  //     //  emitter('caching next ${toSend.length} sent');
                  //   }
                  // });
                }
                // paginateFeed(context);
                // provide.changeIndex(index);
              },
            ),
    );
    // InViewNotifierList(
    //     isInViewPortCondition:
    //         (double deltaTop, double deltaBottom, double vpHeight) {
    //       return deltaTop < (0.3 * vpHeight) &&
    //           deltaBottom > (0.3 * vpHeight);
    //     },
    //     itemCount: stream.feedPosts.length,
    //     controller: controller,
    //     scrollDirection: Axis.vertical,
    //     initialInViewIds: ["0"],
    //     onListEndReached: () {
    //       paginateFeed(context);
    //     },
    //     //    padding: EdgeInsets.only(bottom: 30),
    //     // padEnds: true,
    //     // pageSnapping: true,
    //     // scrollBehavior:ScrollBehavior(),
    //     builder: ((context, index) {
    //       FeedPost post = stream.feedPosts[index];
    //       if (mounted) {
    //         if (index > stream.feedPosts.length - 3) {
    //           SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //             paginateFeed(context);
    //           });
    //         }
    //         // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //         //   FeedPostWare postLenght =
    //         //       Provider.of<FeedPostWare>(context, listen: false);
    //         //   if (index % 2 == 0) {
    //         //     List<FeedPost> toSend = [];

    //         //     for (var i = index; i < (index + (7)); i++) {
    //         //       toSend.add(postLenght.feedPosts[i]);
    //         //     }
    //         //     FeedPostController.downloadThumbs(
    //         //         toSend, context, MediaQuery.of(context).size.height);
    //         //     //  emitter('caching next ${toSend.length} sent');
    //         //   }
    //         // });
    //       }

    //       return InViewNotifierWidget(
    //           id: '$index',
    //           builder:
    //               (BuildContext context, bool isInView, Widget? child) {
    //             return Padding(
    //               padding: const EdgeInsets.only(bottom: 0),
    //               child: TikTokView(
    //                 media: post.mux!,
    //                 data: post,
    //                 page: "feed",
    //                 feedPosts: stream.feedPosts,
    //                 index1: index,
    //                 index2: index + 1,
    //                 urls: post.media!,
    //                 isHome: true,
    //                 isInView: isInView,
    //               ),
    //             );
    //           });
    //     }),

    //     // onPageChanged: (index) async {
    //     //   FeedPostWare postLenght =
    //     //       Provider.of<FeedPostWare>(context, listen: false);
    //     //   if (index % 2 == 0) {
    //     //     List<FeedPost> toSend = [];

    //     //     for (var i = index;
    //     //         i < (index + (postLenght.feedPosts.length - index));
    //     //         i++) {
    //     //       toSend.add(postLenght.feedPosts[i]);
    //     //     }
    //     //     FeedPostController.downloadThumbs(
    //     //         toSend, context, MediaQuery.of(context).size.height);
    //     //     emitter('caching next ${toSend.length} sent');
    //     //   }
    //     //   await paginateFeed(context, index);
    //     // },
    //   );
  }

  Future paginateFeed(BuildContext context) async {
    emitter("Pageinating");
    FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);

    ///  provide.indexChange(index);

    // int checkNum = provide.feedPosts.length - 3; // lenght of posts
    int pageNum = provide.feedData.currentPage!; // api current  page num
    int maxPages = provide.feedData.lastPage!; // api last page num
    //  emitter("there");
    //  emitter(maxPages.toString());
    // emitter(pageNum.toString());

    if (pageNum >= maxPages) {
      emitter("cannot paginate");
      return;
    } else {
      //  emitter("PAGINTATING");
      if (provide.loadStatus) {
        return;
      }
      await FeedPostController.getFeedPostController(context, pageNum + 1, true)
          .whenComplete(() => emitter("paginated"));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // @override
  // bool get wantKeepAlive => true;
}
