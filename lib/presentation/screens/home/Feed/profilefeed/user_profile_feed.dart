import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:macanacki/model/feed_post_model.dart';
import 'package:macanacki/model/profile_feed_post.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import '../../../../../services/middleware/feed_post_ware.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../widgets/user_post_views.dart';

class UserProfileFeed extends StatefulWidget {
  final int index;
  const UserProfileFeed({super.key, required this.index});

  @override
  State<UserProfileFeed> createState() => _UserProfileFeedState();
}

class _UserProfileFeedState extends State<UserProfileFeed> {
  // late Controller controller;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProfileWare provide =
          Provider.of<UserProfileWare>(context, listen: false);
      print("hey");
      provide.changeUserIndex(widget.index);
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: HexColor(backgroundColor)));
  }

  @override
  Widget build(BuildContext context) {
    FeedPostWare stream = context.watch<FeedPostWare>();
    PreloadPageController controller =
        PreloadPageController(initialPage: widget.index);

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              PreloadPageView.builder(
                itemCount: stream.profileFeedPosts.length,
                preloadPagesCount: 0,
                controller: controller,
                scrollDirection: Axis.vertical,
                itemBuilder: ((context, index) {
                  final ProfileFeedDatum post = stream.profileFeedPosts[index];
                  List<Comment> talks = [];
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    post.comments!.forEach((element) {
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
                  });

                  final User user = User(
                      id: post.user!.id,
                      email: post.user!.email,
                      username: post.user!.username,
                      faceVerification: post.user!.faceVerification,
                      dob: post.user!.dob,
                      emailVerified: post.user!.emailVerified,
                      registrationComplete: post.user!.registrationComplete,
                      emailVerifiedAt: post.user!.emailVerifiedAt,
                      createdAt: post.user!.createdAt,
                      updatedAt: post.user!.updatedAt,
                      gender: post.user!.gender,
                      profilephoto: post.user!.profilephoto,
                      noOfFollowers: post.user!.noOfFollowers,
                      noOfFollowing: post.user!.noOfFollowing,
                      verified: post.user!.verified!);

                  final FeedPost data = FeedPost(
                      id: post.id,
                      description: post.description,
                      published: post.published,
                      createdAt: post.createdAt,
                      updatedAt: post.updatedAt,
                      creator: post.creator,
                      media: post.media,
                      comments: talks,
                      noOfLikes: post.noOfLikes,
                      user: user,
                      btnLink: post.btnLink,
                      button: post.button,
                      thumbnails: post.thumbnails,
                      viewCount: post.viewCount,
                      mux: post.mux,
                      promoted: post.promoted);

                  return UserTikTokView(
                    media: post.mux!,
                    data: data,
                    page: "user",
                    urls: post.media!,
                    isHome: false,
                    isInView: false,
                    pageData: post,
                    thumbails: post.thumbnails!,
                    index1: index,
                    thisPost: post,
                    allPost: stream.profileFeedPosts,
                  );
                }),
                onPageChanged: (index) {

                  // provide.changeIndex(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
