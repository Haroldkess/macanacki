import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:makanaki/model/common/data.dart';
import 'package:makanaki/model/feed_post_model.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:makanaki/presentation/widgets/tik_tok_view.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
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

class _PeopleHomeState extends State<PeopleHome>
    with AutomaticKeepAliveClientMixin {
  PageController? controller;

  @override
  Widget build(BuildContext context) {
    FeedPostWare stream = context.watch<FeedPostWare>();
    FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);
    controller = PageController(initialPage: stream.index, keepPage: true);

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

              return TikTokView(
                media: post.mux!,
                data: post,
                page: "feed",
                feedPosts: stream.feedPosts,
                index1: index,
                index2: index + 1,
                urls: post.media!,
                isHome: true,
              );
            }),
            onPageChanged: (index) async {
              FeedPostWare postLenght =
                  Provider.of<FeedPostWare>(context, listen: false);
              if (index % 2 == 0) {
                List<FeedPost> toSend = [];

                for (var i = index; i < (index + (postLenght.feedPosts.length - index)); i++) {   
                  toSend.add(postLenght.feedPosts[i]);
                }
                FeedPostController.downloadThumbs(
                    toSend, context, MediaQuery.of(context).size.height);
                emitter('caching next ${toSend.length} sent');
              }
              await paginateFeed(context, index);
            },
          );
  }

  Future paginateFeed(BuildContext context, int index) async {
    FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);

    provide.indexChange(index);

    int checkNum = provide.feedPosts.length - 3; // lenght of posts
    int pageNum = provide.feedData.currentPage!; // api current  page num
    int maxPages = provide.feedData.lastPage!; // api last page num

    if (pageNum >= maxPages) {
      emitter("cannot paginate");
      return;
    } else {
      if (index > checkNum && index < provide.feedPosts.length - 2) {
        await FeedPostController.getFeedPostController(
                context, pageNum + 1, true)
            .whenComplete(() => emitter("paginated"));
      } else {
        emitter("cannot paginate");
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
}
