import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:makanaki/model/feed_post_model.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/screens/home/Feed/profilefeed/profilefeedextra/post_view.dart';
import 'package:makanaki/presentation/widgets/tik_tok_view.dart';
import 'package:provider/provider.dart';

import '../../../../../model/public_profile_model.dart';
import '../../../../../services/middleware/feed_post_ware.dart';
import '../../../../../services/middleware/user_profile_ware.dart';

class UserProfileFeed extends StatefulWidget {
  final int index;
  const UserProfileFeed({super.key, required this.index});

  @override
  State<UserProfileFeed> createState() => _UserProfileFeedState();
}

class _UserProfileFeedState extends State<UserProfileFeed>
    with AutomaticKeepAliveClientMixin {
  PageController? controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    FeedPostWare stream = context.watch<FeedPostWare>();
    UserProfileWare provide =
        Provider.of<UserProfileWare>(context, listen: false);
    return Scaffold(
      body: PageView.builder(
        itemCount: stream.profileFeedPosts.length,
        controller: controller,
        scrollDirection: Axis.vertical,
        padEnds: false,
        itemBuilder: ((context, index) {
          FeedPost post = stream.profileFeedPosts[index];

          return UserFeedView(
            media: post.media!,
            data: post,
          );
        }),
        onPageChanged: (index) {
         // provide.changeIndex(index);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
