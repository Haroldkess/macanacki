import 'package:flutter/material.dart';
import 'package:makanaki/model/feed_post_model.dart';
import 'package:makanaki/model/profile_feed_post.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/profile/profileextras/grid_view_items.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../model/public_profile_model.dart';
import '../../../../../services/middleware/feed_post_ware.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../userprofile/extras/public_grid_view_items.dart';

class ProfilePostGridLoader extends StatefulWidget {
  const ProfilePostGridLoader({super.key});

  @override
  State<ProfilePostGridLoader> createState() => _ProfilePostGridLoaderState();
}

class _ProfilePostGridLoaderState extends State<ProfilePostGridLoader> {
  List<String> test = [
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg',
    'assets/pic/px1.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      primary: false,
      padding: const EdgeInsets.all(5),
      itemCount: test.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 200 / 300,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1),
      itemBuilder: (BuildContext context, int index) {
        String img = test[index];
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor.withOpacity(0.2),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.asset(
                  img,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfilePostGrid extends StatefulWidget {
  const ProfilePostGrid({super.key});

  @override
  State<ProfilePostGrid> createState() => _ProfilePostGridState();
}

class _ProfilePostGridState extends State<ProfilePostGrid> {
  @override
  Widget build(BuildContext context) {
    FeedPostWare stream = context.watch<FeedPostWare>();
    return GridView.builder(
      shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      primary: false,
      padding: const EdgeInsets.only(top: 0),
      itemCount: stream.profileFeedPosts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 200 / 300,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1),
      itemBuilder: (BuildContext context, int index) {
        ProfileFeedDatum post = stream.profileFeedPosts[index];
        return MyGridViewItems(
          data: post,
          index: index,
        );
      },
    );
  }
}

class PublicProfilePostGrid extends StatefulWidget {
  const PublicProfilePostGrid({super.key});

  @override
  State<PublicProfilePostGrid> createState() => _PublicProfilePostGridState();
}

class _PublicProfilePostGridState extends State<PublicProfilePostGrid> {
  @override
  Widget build(BuildContext context) {
    UserProfileWare stream = context.watch<UserProfileWare>();
    return GridView.builder(
      shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      primary: false,
      padding: const EdgeInsets.only(top: 0),
      itemCount: stream.publicUserProfileModel.posts == null
          ? 0
          : stream.publicUserProfileModel.posts!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 200 / 300,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1),
      itemBuilder: (BuildContext context, int index) {
        PublicUserPost post = stream.publicUserProfileModel.posts![index];
        return PublicGridViewItems(
          data: post,
          index: index,
        );
      },
    );
  }
}
