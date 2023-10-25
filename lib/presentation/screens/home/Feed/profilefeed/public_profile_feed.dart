import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:macanacki/model/feed_post_model.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';

import '../../../../../model/public_profile_model.dart';

import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../constants/colors.dart';

import '../../../../widgets/user_post_views.dart';

class PublicUserProfileFeed extends StatefulWidget {
  final int index;
  final List<PublicUserPost> data;
  const PublicUserProfileFeed(
      {super.key, required this.index, required this.data});

  @override
  State<PublicUserProfileFeed> createState() => _PublicUserProfileFeedState();
}

class _PublicUserProfileFeedState extends State<PublicUserProfileFeed> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserProfileWare provide =
          Provider.of<UserProfileWare>(context, listen: false);
      provide.changePublicIndex(widget.index);
    });

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: HexColor(backgroundColor)));
  }

  @override
  Widget build(BuildContext context) {
    PreloadPageController controller =
        PreloadPageController(initialPage: widget.index);
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            PreloadPageView.builder(
              itemCount: widget.data.length,
              preloadPagesCount: 0,
              controller: controller,
              scrollDirection: Axis.vertical,
              itemBuilder: ((context, index) {
                final PublicUserPost post = widget.data[index];

                List<Comment> talks = [];

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

                final FeedPost data = FeedPost(
                    id: post.id,
                    description: post.description,
                    published: post.published,
                    createdAt: post.createdAt,
                    updatedAt: post.updatedAt,
                    creator: post.creator,
                    media: post.media,
                    mux: post.mux,
                    vod: post.vod,
                    comments: talks,
                    noOfLikes: post.noOfLikes,
                    btnLink: post.btnLink,
                    button: post.button,
                    viewCount: post.viewCount,
                    thumbnails: post.thumbnails,
                    user: user,
                    promoted: post.promoted);

                return UserTikTokView(
                  media: post.mux!,
                  data: data,
                  page: "public",
                  urls: post.media!,
                  isHome: false,
                  isInView: false,
                  vod: post.vod!,
                  pageData: post,
                  thumbails: post.thumbnails!,
                  index1: index,
                  allPost: widget.data,
                  // userId: stream.publicUserProfileModel.id!,
                );
              }),
              onPageChanged: (index) {
                // provide.changeIndex(index);
              },
            ),

            // InViewNotifierList(
            //   itemCount: stream.publicUserProfileModel.posts!.length,
            //   controller: controller,
            //   scrollDirection: Axis.vertical,
            //   // padEnds: false,
            //   isInViewPortCondition:
            //       (double deltaTop, double deltaBottom, double vpHeight) {
            //     return deltaTop < (0.3 * vpHeight) &&
            //         deltaBottom > (0.3 * vpHeight);
            //   },
            //   initialInViewIds: ["${widget.index}"],
            //   builder: ((context, index) {
            //     final PublicUserPost post =
            //         stream.publicUserProfileModel.posts![index];

            //     List<Comment> talks = [];

            //     final User user = User(
            //         id: post.user!.id,
            //         email: post.user!.email,
            //         username: post.user!.username,
            //         faceVerification: post.user!.faceVerification,
            //         dob: post.user!.dob,
            //         emailVerified: post.user!.emailVerified,
            //         registrationComplete: post.user!.registrationComplete,
            //         emailVerifiedAt: post.user!.emailVerifiedAt,
            //         createdAt: post.user!.createdAt,
            //         updatedAt: post.user!.updatedAt,
            //         gender: post.user!.gender,
            //         profilephoto: post.user!.profilephoto,
            //         noOfFollowers: post.user!.noOfFollowers,
            //         noOfFollowing: post.user!.noOfFollowing,
            //         verified: post.user!.verified!);
            //     post.comments!.forEach((element) {
            //       Comment comment = Comment(
            //           id: element.id,
            //           body: element.body,
            //           createdAt: element.createdAt,
            //           updatedAt: element.updatedAt,
            //           username: element.username,
            //           profilePhoto: element.profilePhoto,
            //           noOfLikes: element.noOfLikes,
            //           postId: element.postId);

            //       talks.add(comment);
            //     });

            //     final FeedPost data = FeedPost(
            //       id: post.id,
            //       description: post.description,
            //       published: post.published,
            //       createdAt: post.createdAt,
            //       updatedAt: post.updatedAt,
            //       creator: post.creator,
            //       media: post.media,
            //       mux: post.mux,
            //       comments: talks,
            //       noOfLikes: post.noOfLikes,
            //       btnLink: post.btnLink,
            //       button: post.button,
            //       viewCount: post.viewCount,
            //       user: user,
            //       promoted: post.promoted
            //     );

            //     return InViewNotifierWidget(
            //         id: '$index',
            //         builder:
            //             (BuildContext context, bool isInView, Widget? child) {
            //           return UserTikTokView(
            //             media: post.mux!,
            //             data: data,
            //             page: "public",
            //             urls: post.media!,
            //             isHome: false,
            //             isInView: isInView,
            //             pageData: post,
            //             // userId: stream.publicUserProfileModel.id!,
            //           );
            //         });
            //   }),
            //   // onPageChanged: (index) {
            //   //   provide.changePublicIndex(index);
            //   // },
            // ),

            // Padding(
            //   padding: EdgeInsets.only(top: 38),
            //   child: IconButton(
            //       onPressed: () => PageRouting.popToPage(context),
            //       icon: const Icon(
            //         Icons.arrow_back_ios,
            //         color: Colors.white,
            //       )),
            // )
          ],
        ),
      ),
    );
  }
}
