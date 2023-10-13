import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:macanacki/model/feed_post_model.dart';
import 'package:macanacki/model/profile_feed_post.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/profile/profileextras/grid_view_items.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
import '../../../../../model/public_profile_model.dart';
import '../../../../../services/api_url.dart';
import '../../../../../services/controllers/feed_post_controller.dart';
import '../../../../../services/middleware/feed_post_ware.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../../services/middleware/video/video_ware.dart';
import '../../../../../services/temps/temps_id.dart';
import '../../../../widgets/loader.dart';
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
  const ProfilePostGrid({super.key, required this.ware});
  final FeedPostWare ware;

  @override
  State<ProfilePostGrid> createState() => _ProfilePostGridState();
}

class _ProfilePostGridState extends State<ProfilePostGrid> {
  @override
  void initState() {
    super.initState();


            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
               FeedPostWare stream = Provider.of<FeedPostWare>(context,listen: false);
                   if (stream.profileFeedPosts.isNotEmpty) {
              VideoWare.instance.getVideoPostFromApi(stream.profileFeedPosts);
               }
               
            emitter("ADDED TO POSTS TO LIST");
            });
         
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FeedPostWare stream = context.watch<FeedPostWare>();
    return PagedGridView<int, ProfileFeedDatum>(
      pagingController: stream.pagingController,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      //physics: const NeverScrollableScrollPhysics(),
      primary: false,
      padding: const EdgeInsets.only(top: 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 200 / 300,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1),
      builderDelegate: PagedChildBuilderDelegate<ProfileFeedDatum>(
        itemBuilder: (context, item, index) {
          ProfileFeedDatum post = item;
          return MyGridViewItems(
            data: post,
            index: index,
          );
        },
        newPageProgressIndicatorBuilder: (context) {
          return Center(child: Loader(color: HexColor(primaryColor)));
        },
        firstPageProgressIndicatorBuilder: (context) {
          return const ProfilePostGridLoader();
        },
        noItemsFoundIndicatorBuilder: (_) => const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox()
            // SvgPicture.asset(
            //   "assets/icon/gallery.svg",
            //   height: 60,
            //   width: 60,
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // AppText(text: "The list is currently empty")
          ],
        ),
      ),
      //scrollController: _controller,
    );
    // return GridView.builder(
    //   shrinkWrap: true,
    //   physics: const ScrollPhysics(),
    //   //physics: const NeverScrollableScrollPhysics(),
    //   primary: false,
    //   padding: const EdgeInsets.only(top: 0),
    //   itemCount: stream.profileFeedPosts.length,
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 3,
    //       childAspectRatio: 200 / 300,
    //       crossAxisSpacing: 1,
    //       mainAxisSpacing: 1),
    //   itemBuilder: (BuildContext context, int index) {
    //     ProfileFeedDatum post = stream.profileFeedPosts[index];
    //     return MyGridViewItems(
    //       data: post,
    //       index: index,
    //     );
    //   },
    // );
  }
}

class PublicProfilePostGrid extends StatefulWidget {
  const PublicProfilePostGrid({super.key, required this.ware});
  final UserProfileWare ware;

  @override
  State<PublicProfilePostGrid> createState() => _PublicProfilePostGridState();
}

//////////////NEEEEEEEEEE TTTTTTT
class _PublicProfilePostGridState extends State<PublicProfilePostGrid> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.ware.disposeAutoScroll());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProfileWare stream = context.watch<UserProfileWare>();
    return PagedGridView<int, PublicUserPost>(
      shrinkWrap: true,
      pagingController: stream.pagingController,
      physics: const ScrollPhysics(),
      //physics: const NeverScrollableScrollPhysics(),
      primary: false,
      padding: const EdgeInsets.only(top: 0),

      // itemCount: stream.publicUserProfileModel.posts == null
      //     ? 0
      //     : stream.publicUserProfileModel.posts!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 200 / 300,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1),
      builderDelegate: PagedChildBuilderDelegate<PublicUserPost>(
        itemBuilder: (context, item, index) {
          PublicUserPost post = item;
          return PublicGridViewItems(
            data: post,
            index: index,
            posts: widget.ware.pubPost,
          );
        },
        newPageProgressIndicatorBuilder: (context) {
          return Center(child: Loader(color: HexColor(primaryColor)));
        },
        firstPageProgressIndicatorBuilder: (context) {
          return const ProfilePostGridLoader();
        },
        noItemsFoundIndicatorBuilder: (_) => const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox()
            // SvgPicture.asset(
            //   "assets/icon/gallery.svg",
            //   height: 60,
            //   width: 60,
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // AppText(text: "The list is currently empty")
          ],
        ),
      ),
    );
  }
}
