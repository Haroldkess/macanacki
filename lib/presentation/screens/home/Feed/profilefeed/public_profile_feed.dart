import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:macanacki/model/feed_post_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/screens/home/Feed/profilefeed/profilefeedextra/post_view.dart';
import 'package:macanacki/presentation/screens/home/Feed/profilefeed/publicuserfeedextra/public_post_view.dart';
import 'package:macanacki/presentation/widgets/tik_tok_view.dart';
import 'package:provider/provider.dart';

import '../../../../../model/public_profile_model.dart';
import '../../../../../services/middleware/feed_post_ware.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../constants/colors.dart';
import '../../../../widgets/comment_modal.dart';
import '../../../../widgets/text.dart';
import '../../../../widgets/user_post_views.dart';

// class PublicUserProfileFeed extends StatefulWidget {
//   final int index;
//   const PublicUserProfileFeed({super.key, required this.index});

//   @override
//   State<PublicUserProfileFeed> createState() => _PublicUserProfileFeedState();
// }

// class _PublicUserProfileFeedState extends State<PublicUserProfileFeed>
//      {

//   @override
//   void initState() {
//     super.initState();
//     controller = PageController(initialPage: widget.index);
//   }

//   @override
//   Widget build(BuildContext context) {
//      PageController? controller = PageController(initialPage: index);
//     UserProfileWare stream = context.watch<UserProfileWare>();

//     UserProfileWare provide =
//         Provider.of<UserProfileWare>(context, listen: false);
//     return Scaffold(
//       body: PageView.builder(
//         itemCount: stream.publicUserProfileModel.posts!.length,
//         controller: controller,
//         scrollDirection: Axis.vertical,
//         padEnds: false,
//         itemBuilder: ((context, index) {
//           PublicUserPost post = stream.publicUserProfileModel.posts![index];

//           return PublicUserFeedView(
//             media: post.media!,
//             data: post,
//             userId: stream.publicUserProfileModel.id!,
//           );
//         }),
//         onPageChanged: (index) {
//           // provide.changeIndex(index);
//         },
//       ),
//     );
//   }

// }

class PublicUserProfileFeed extends StatefulWidget {
  final int index;
  const PublicUserProfileFeed({super.key, required this.index});

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
      //  print("hey");
      provide.changePublicIndex(widget.index);
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: HexColor(backgroundColor)));
  }

  @override
  Widget build(BuildContext context) {
    PageController? controller = PageController(initialPage: widget.index);
    UserProfileWare stream = context.watch<UserProfileWare>();

    UserProfileWare provide =
        Provider.of<UserProfileWare>(context, listen: false);
    UserProfileWare userStream = context.watch<UserProfileWare>();
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        // persistentFooterButtons: [
        //   InkWell(
        //     onTap: () {
        //       commentModal(
        //           context,
        //           stream.publicUserProfileModel.posts![userStream.publicIndex]
        //               .id!,
        //           "public");
        //     },
        //     child: Container(
        //       height: 30,
        //       width: double.infinity,
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 10),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             AppText(
        //               text: "Add comment...",
        //               color: Colors.grey,
        //             ),
        //             Row(
        //               children: const [
        //                 Icon(
        //                   Icons.emoji_emotions_outlined,
        //                   color: Colors.grey,
        //                 ),
        //               ],
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   )
        // ],

        body: Stack(
          children: [
            PageView.builder(
              itemCount: stream.publicUserProfileModel.posts!.length,
              controller: controller,
              scrollDirection: Axis.vertical,
              padEnds: false,
              itemBuilder: ((context, index) {
                final PublicUserPost post =
                    stream.publicUserProfileModel.posts![index];

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
                    comments: talks,
                    noOfLikes: post.noOfLikes,
                    btnLink: post.btnLink,
                    button: post.button,
                    viewCount: post.viewCount,
                    user: user,
                    promoted: post.promoted);

                return UserTikTokView(
                  media: post.mux!,
                  data: data,
                  page: "public",
                  urls: post.media!,
                  isHome: false,
                  isInView: false,
                  pageData: post,
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
