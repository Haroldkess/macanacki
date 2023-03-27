import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:makanaki/model/feed_post_model.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/screens/home/Feed/profilefeed/profilefeedextra/post_view.dart';
import 'package:makanaki/presentation/screens/home/Feed/profilefeed/publicuserfeedextra/public_post_view.dart';
import 'package:makanaki/presentation/widgets/tik_tok_view.dart';
import 'package:provider/provider.dart';

import '../../../../../model/public_profile_model.dart';
import '../../../../../services/middleware/feed_post_ware.dart';
import '../../../../../services/middleware/user_profile_ware.dart';

class PublicUserProfileFeed extends StatefulWidget {
  final int index;
  const PublicUserProfileFeed({super.key, required this.index});

  @override
  State<PublicUserProfileFeed> createState() => _PublicUserProfileFeedState();
}

class _PublicUserProfileFeedState extends State<PublicUserProfileFeed>
    with AutomaticKeepAliveClientMixin {
  PageController? controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    UserProfileWare stream = context.watch<UserProfileWare>();

    UserProfileWare provide =
        Provider.of<UserProfileWare>(context, listen: false);
    return Scaffold(
      body: PageView.builder(
        itemCount: stream.publicUserProfileModel.posts!.length,
        controller: controller,
        scrollDirection: Axis.vertical,
        padEnds: false,
        itemBuilder: ((context, index) {
          PublicUserPost post = stream.publicUserProfileModel.posts![index];

          return PublicUserFeedView(
            media: post.media!,
            data: post,
            userId: stream.publicUserProfileModel.id!,
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
