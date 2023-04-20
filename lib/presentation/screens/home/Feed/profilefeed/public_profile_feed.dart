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

class PublicUserProfileFeed extends StatelessWidget {
  final int index;
  const PublicUserProfileFeed({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    PageController? controller = PageController(initialPage: index);
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
          );
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
            comments: talks,
            noOfLikes: post.noOfLikes,
            btnLink: post.btnLink,
            button: post.button,
            viewCount: post.viewCount,
            user: user,
          );

          return TikTokView(
            media: post.media!,
            data: data,
            page: "public",
            // userId: stream.publicUserProfileModel.id!,
          );
        }),
        onPageChanged: (index) {
          // provide.changeIndex(index);
        },
      ),
    );
  }
}
