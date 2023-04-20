import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:makanaki/model/feed_post_model.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/widgets/tik_tok_view.dart';
import 'package:provider/provider.dart';

import '../../../../services/controllers/feed_post_controller.dart';
import '../../../../services/middleware/feed_post_ware.dart';
import '../../../uiproviders/screen/find_people_provider.dart';

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
    return PageView.builder(
      itemCount: stream.feedPosts.length,
      controller: controller,
      scrollDirection: Axis.vertical,
      padEnds: false,
      itemBuilder: ((context, index) {
        FeedPost post = provide.feedPosts[index];

        return TikTokView(
          media: post.media!,
          data: post,
          page: "feed",
        );
      }),
      onPageChanged: (index) async {
        FeedPostWare postLenght =
            Provider.of<FeedPostWare>(context, listen: false);
        provide.indexChange(index);
        int checkNum = postLenght.feedPosts.length - 5;
        int pageNum = postLenght.feedData.currentPage! + 1;
        if (index >= checkNum && pageNum <= postLenght.feedData.lastPage!) {
          await FeedPostController.getFeedPostController(context, pageNum, true).whenComplete(() => print("paginated"));
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
  }

  @override
  bool get wantKeepAlive => true;
}
