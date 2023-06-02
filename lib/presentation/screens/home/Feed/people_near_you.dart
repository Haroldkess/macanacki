import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:makanaki/model/feed_post_model.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:makanaki/presentation/widgets/tik_tok_view.dart';
import 'package:provider/provider.dart';

import '../../../../services/controllers/feed_post_controller.dart';
import '../../../../services/middleware/feed_post_ware.dart';
import '../../../constants/colors.dart';
import '../../../uiproviders/screen/find_people_provider.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/debug_emitter.dart';

class PeopleHome extends StatefulWidget {
  const PeopleHome({super.key});

  @override
  State<PeopleHome> createState() => _PeopleHomeState();
}

class _PeopleHomeState extends State<PeopleHome>
    with AutomaticKeepAliveClientMixin {
  PageController? controller;

  @override
  Widget build(BuildContext context) {
    FeedPostWare stream = context.watch<FeedPostWare>();
    FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);

    return stream.feedPosts.isEmpty
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
                                  context, 1, false);
                              //  PageRouting.pushToPage(context, const BusinessVerification());
                            }),
                  ],
                ),
              )
            ],
          )
        : PageView.builder(
            itemCount: stream.feedPosts.length,
            controller: controller,
            scrollDirection: Axis.vertical,
            padEnds: false,
            itemBuilder: ((context, index) {
              FeedPost post = stream.feedPosts[index];

              return FutureBuilder(
                  future: Future.delayed(Duration(seconds: 1)),
                  builder: (context, snapshot) {
                    FeedPostWare _provide =
                        Provider.of<FeedPostWare>(context, listen: false);
                    // var splitStrings = post.media.split(
                    //     "https:macarn.s3.eu-west-2.amazonaws.com/post/medias/");
                    // var rep = splitStrings.last.replaceAll("/", "");
                    // var finalPath = '/data/user/0/com.example.makanaki/app_flutter/$rep';
                    List<FeedPost> finalData =
                        stream.cachedPosts.where((element) {
                      return element.id == stream.feedPosts[index].id;
                    }).toList();

                    //     log("snapshot ${stream.feedPosts[index].id}${finalData.length}");
                    return TikTokView(
                      media: finalData.isEmpty
                          ? post.media!
                          : finalData.first.media2 == null
                              ? post.media!
                              : finalData.first.media2!,
                      data: post,
                      page: "feed",
                      feedPosts: stream.feedPosts,
                      index1: index,
                      index2: index + 1,
                      urls: post.media!,
                      isHome: true,
                    );
                  });
            }),
            onPageChanged: (index) async {
              FeedPostWare postLenght =
                  Provider.of<FeedPostWare>(context, listen: false);
              provide.indexChange(index);
              if (index % 2 == 0) {
                List<FeedPost> toSend = [];

                for (var i = index + 1; i < (index + 3); i++) {
                  toSend.add(postLenght.feedPosts[i]);
                }
                FeedPostController.downloadVideos(toSend, context);
                emitter('caching next ${toSend.length} sent');
              } else {
                emitter('Will not initiate cache');
              }
              int checkNum = stream.feedPosts.length - 5;
              int pageNum = stream.feedData.currentPage! + 1;
              if (index >= checkNum &&
                  pageNum <= postLenght.feedData.lastPage!) {
                await FeedPostController.getFeedPostController(
                        context, pageNum, true)
                    .whenComplete(() => emitter("paginated"));
              }
            },
          );
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);
      controller = PageController(initialPage: provide.index, keepPage: true);
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);
      List<FeedPost> toSend = [];
      if (provide.index == 0) {
        for (var i = 0; i < 2; i++) {
          toSend.add(provide.feedPosts[i]);
        }
        emitter('caching first ${toSend.length} sent');
        emitter('caching first ${toSend.length} sent');
        FeedPostController.downloadVideos(toSend, context);
        emitter('caching first ${toSend.length} sent');
      }

      //FeedPostController.downloadVideos(provide.feedPosts, context);
    });
  }

  @override
  bool get wantKeepAlive => true;
}
