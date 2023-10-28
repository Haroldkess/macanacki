import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/userprofile/extras/public_grid_view_items.dart';
import 'package:macanacki/presentation/uiproviders/screen/tab_provider.dart';
import '../../../../../model/public_profile_model.dart';
import '../../../widgets/loader.dart';
import '../../home/profile/profileextras/extra_profile_view.dart';

class TestPublicProfilePostGrid extends StatefulWidget {
  TestPublicProfilePostGrid(
      {super.key,
      required this.scrollController,
      this.tabKey,
      this.tabName,
      required this.pubPost,
      required this.pagingController,
      required this.username,
      required this.isHome});

  ScrollController? scrollController;
  final Key? tabKey;
  final String? tabName;
  final String? username;
  PagingController<int, PublicUserPost> pagingController;
  int isHome;
  List<PublicUserPost> pubPost;

  @override
  State<TestPublicProfilePostGrid> createState() =>
      _TestPublicProfilePostGridState();
}

//////////////NEEEEEEEEEE TTTTTTT
class _TestPublicProfilePostGridState extends State<TestPublicProfilePostGrid>
    with AutomaticKeepAliveClientMixin {
  ScrollPhysics? ph;

  bool isParentEdget = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          final metrics = scrollNotification.metrics;
          if (metrics.atEdge) {
            bool isTop = metrics.pixels == 0;
            if (isTop) {
              //   print("IT IS AT THE TOP OF THE LIST");
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if (mounted) {
                  scrolNotifyPublicExtra.instance.changeTabOne(true);
                  // setState(() {
                  //   physc = true;
                  // });
                }
              });
            } else {
              // print("nothing");
            }
          } else {
            // print("IoTHER wISE");
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (mounted) {
                scrolNotifyPublicExtra.instance.changeTabOne(false);
                // setState(() {
                //   physc = false;
                // });
              }
            });
          }
          return true;
        },
        child: ObxValue((physc) {
          return PagedGridView<int, PublicUserPost>(
            shrinkWrap: true,
            pagingController: widget.pagingController,
            physics: physc.value == true
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
            scrollController: widget.scrollController,
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
                  posts: widget.pubPost,
                  isHome: widget.isHome,
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
        }, scrolNotifyPublicExtra.instance.tabOne),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}

class TestPublicProfilePostGridAudio extends StatefulWidget {
  TestPublicProfilePostGridAudio(
      {super.key,
      required this.scrollController,
      this.tabKey,
      this.tabName,
      required this.pubPost,
      required this.pagingController,
      required this.username,
      required this.isHome});

  ScrollController? scrollController;
  final Key? tabKey;
  final String? tabName;
  final String? username;
  PagingController<int, PublicUserPost> pagingController;
  int isHome;
  List<PublicUserPost> pubPost;

  @override
  State<TestPublicProfilePostGridAudio> createState() =>
      _TestPublicProfilePostGridAudioState();
}

//////////////NEEEEEEEEEE TTTTTTT
class _TestPublicProfilePostGridAudioState
    extends State<TestPublicProfilePostGridAudio>
    with AutomaticKeepAliveClientMixin {
  ScrollPhysics? ph;

  bool isParentEdget = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          final metrics = scrollNotification.metrics;
          if (metrics.atEdge) {
            bool isTop = metrics.pixels == 0;
            if (isTop) {
              //   print("IT IS AT THE TOP OF THE LIST");
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if (mounted) {
                  scrolNotifyPublicExtra.instance.changeTabOne(true);
                  // setState(() {
                  //   physc = true;
                  // });
                }
              });
            } else {
              // print("nothing");
            }
          } else {
            // print("IoTHER wISE");
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (mounted) {
                scrolNotifyPublicExtra.instance.changeTabOne(false);
                // setState(() {
                //   physc = false;
                // });
              }
            });
          }
          return true;
        },
        child: ObxValue((physc) {
          return PagedGridView<int, PublicUserPost>(
            shrinkWrap: true,
            pagingController: widget.pagingController,
            physics: physc.value == true
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
            scrollController: widget.scrollController,
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
                  posts: widget.pubPost,
                  isHome: widget.isHome,
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
        }, scrolNotifyPublicExtra.instance.tabOne),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
