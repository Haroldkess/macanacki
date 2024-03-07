import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/services/middleware/friends/friends_ware.dart';
import 'package:numeral/numeral.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../model/feed_post_model.dart';
import '../../../../services/controllers/action_controller.dart';
import '../../../../services/controllers/feed_post_controller.dart';
import '../../../../services/middleware/action_ware.dart';
import '../../../../services/middleware/feed_post_ware.dart';
import '../../../../services/middleware/notification_ware..dart';
import '../../../constants/colors.dart';
import '../../../constants/string.dart';
import '../../../uiproviders/screen/tab_provider.dart';
import '../../../widgets/debug_emitter.dart';
import '../../../widgets/text.dart';
import '../../notification/notification_screen.dart';
import '../Feed/feed_home.dart';
import '../Feed/friends_page_view.dart';
import '../Feed/people_near_you.dart';
import '../friends/friends_screen.dart';
import '../profile/profileextras/extra_profile_view.dart';
import '../profile/profileextras/not_mine_buttons.dart';
import '../search/global_search_screen.dart';
import '../search/searchextras/search_bar.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../swipes/swipe_card_screen.dart';

class HomeGridScreen extends StatefulWidget {
  const HomeGridScreen({super.key});
  @override
  State<HomeGridScreen> createState() => _HomeGridScreenState();
}

class _HomeGridScreenState extends State<HomeGridScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    //  await Future.delayed(Duration(milliseconds: 1000));
    await callFeedPost(true);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await paginateFeed(context);

    if (mounted) setState(() {});
    // _refreshController.loadNoData();
    _refreshController.loadComplete();

    // monitor network fetch

    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
  }

  Future paginateFeed(BuildContext context) async {
    emitter("Pageinating");
    FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);
    TabProvider tab = Provider.of<TabProvider>(context, listen: false);

    ///  provide.indexChange(index);

    // int checkNum = provide.feedPosts.length - 3; // lenght of posts
    int pageNum = provide.feedData.currentPage!; // api current  page num
    int maxPages = provide.feedData.lastPage!; // api last page num
    //  emitter("there");
    //  emitter(maxPages.toString());
    // emitter(pageNum.toString());

    if (pageNum >= maxPages) {
      emitter("cannot paginate");
      return;
    } else {
      //  emitter("PAGINTATING");
      if (provide.loadStatus) {
        return;
      }
      await FeedPostController.getFeedPostController(
              context, pageNum + 1, true, tab.filterNameHomePost)
          .whenComplete(() => emitter("paginated"));
    }
  }

  callFeedPost(bool isRefreshed) async {
    FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);
    TabProvider tab = Provider.of<TabProvider>(context, listen: false);
    if (isRefreshed == false) {
      if (provide.feedPosts.isEmpty) {
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          await FeedPostController.getFeedPostController(
              context, 1, false, tab.filterNameHomePost);
        });
      }

      SchedulerBinding.instance.addPostFrameCallback((_) {
        ActionController.retrievAllUserLikedController(context);
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ActionController.retrievAllUserFollowingController(context);
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ActionController.retrievAllUserLikedCommentsController(context);
      });
    } else {
      FeedPostWare provide = Provider.of<FeedPostWare>(context, listen: false);

      provide.isLoadingReferesh(true);
      provide.indexChange(0);
      await FeedPostController.getFeedPostController(
          context, 1, false, tab.filterNameHomePost);
      //   SchedulerBinding.instance.addPostFrameCallback((_) {
      ActionController.retrievAllUserLikedController(context);
      // });
      //  SchedulerBinding.instance.addPostFrameCallback((_) {
      ActionController.retrievAllUserFollowingController(context);
      //  });
      //  SchedulerBinding.instance.addPostFrameCallback((_) {
      ActionController.retrievAllUserLikedCommentsController(context);
      provide.isLoadingReferesh(false);

      setState(() {});
      //  });
    }
  }

  @override
  Widget build(BuildContext context) {
    FeedPostWare stream = context.watch<FeedPostWare>();
    List<dynamic> dynamicList = [];
    NotificationWare notify = context.watch<NotificationWare>();
    TabProvider tab = context.watch<TabProvider>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundSecondary,
        appBar: AppBar(
          //   backgroundColor: backgroundSecondary,
          backgroundColor: HexColor(backgroundColor),
          elevation: 0,
          automaticallyImplyLeading: false,

          title: MenuCategorySearch(
            tab: tab,
          ),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            //    PersistentNavController.instance.toggleHide();
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              if (PersistentNavController.instance.hide.value == true) {
                PersistentNavController.instance.toggleHide();
              }
            });
          },
          child: Column(
            children: [
              Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(
                    waterDropColor: textPrimary,
                    refresh: CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.transparent,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color?>(textWhite),
                      ),
                    ),
                  ),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget body;
                      if (mode == LoadStatus.idle) {
                        body = AppText(
                          text: "pull up load",
                          color: textPrimary,
                        );
                      } else if (mode == LoadStatus.loading) {
                        body = CupertinoActivityIndicator(
                          color: textWhite,
                        );
                      } else if (mode == LoadStatus.failed) {
                        body = AppText(
                            text: "Load Failed!Click retry!",
                            color: textPrimary);
                      } else if (mode == LoadStatus.canLoading) {
                        body = AppText(
                            text: "release to load more", color: textPrimary);
                      } else {
                        body =
                            AppText(text: "No more Data", color: textPrimary);
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child:

                      // StaggeredGrid.count(
                      //   crossAxisCount: 4,
                      //   mainAxisSpacing: 4,
                      //   crossAxisSpacing: 4,
                      //   children: List.generate(
                      //     stream.feedPosts.length,
                      //     (index) => (index % 4 == 0)
                      //         ? StaggeredGridTile.count(
                      //             crossAxisCellCount: 4,
                      //             mainAxisCellCount: 4,
                      //             child: buildCard(
                      //                 context,
                      //                 stream.feedPosts[index].user!
                      //                             .profilephoto ==
                      //                         null
                      //                     ? "https://t4.ftcdn.net/jpg/04/00/24/31/360_F_400243185_BOxON3h9avMUX10RsDkt3pJ8iQx72kS3.jpg"
                      //                     : stream.feedPosts[index].user!
                      //                         .profilephoto!,
                      //                 stream.feedPosts[index].user!.username ==
                      //                         null
                      //                     ? ""
                      //                     : stream
                      //                         .feedPosts[index].user!.username!,
                      //                 stream.feedPosts[index].user!.id!),
                      //           )
                      //         : StaggeredGridTile.count(
                      //             crossAxisCellCount: 2,
                      //             mainAxisCellCount: 2,
                      //             child: HomeGrodViewItems(
                      //               extent: 170,
                      //               data: stream.feedPosts[index],
                      //               index: index,
                      //             ),
                      //           ),
                      //   ),
                      // )

                      tab.isLoad || stream.loadStatusReferesh
                          ? ProfilePostGridLoader()
                          : MasonryGridView.count(
                              crossAxisCount: 3,
                              mainAxisSpacing: 1,
                              crossAxisSpacing: 1,
                              itemCount: stream.feedPosts.length,
                              itemBuilder: (context, index) {
                                FeedPost _data = stream.feedPosts[index];
                                return _data.media == null
                                    ? SizedBox.shrink()
                                    : _data.media!.isEmpty
                                        ? SizedBox.shrink()
                                        : HomeGrodViewItems(
                                            data: _data,
                                            index: index,
                                            extent: _data.media == null
                                                ? 170
                                                : _data.media!.isEmpty
                                                    ? 170
                                                    : _data.media!.first
                                                                .contains(
                                                                    ".mp4") ||
                                                            _data.media!.first
                                                                .contains(
                                                                    ".mp3")
                                                        ? (index % 2 == 1)
                                                            ? 250
                                                            : 170
                                                        : 170);

                                //  Tile(
                                //   index: index,
                                //   extent: (index % 5 + 1) * 100,
                                // );
                              },
                            ),

                  //  GridView.builder(
                  //     itemCount: stream.feedPosts.length,
                  //     gridDelegate:
                  //         const SliverGridDelegateWithFixedCrossAxisCount(
                  //             crossAxisCount: 3,
                  //             childAspectRatio: 200 / 300,
                  //             crossAxisSpacing: 1,
                  //             mainAxisSpacing: 1),
                  //     itemBuilder: (context, index) {
                  //       FeedPost _data = stream.feedPosts[index];
                  //       return HomeGrodViewItems(
                  //         data: _data,
                  //         index: index,
                  //       );
                  //     }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double height = 60;
  double width = 60;
  Widget buildCard(
      BuildContext context, String image, String username, int id) {
    ActionWare stream = context.watch<ActionWare>();

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: const Alignment(-0.3, 0),
                        image: CachedNetworkImageProvider(image),
                        fit: BoxFit.cover)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      // height: Get.height,
                      // width: Get.width,
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                Shimmer.fromColors(
                                    baseColor: HexColor(backgroundColor),
                                    highlightColor: Colors.grey.withOpacity(.2),
                                    period: Duration(seconds: 1),
                                    child: Container(
                                      color: HexColor(backgroundColor),
                                    )),
                        errorWidget: (context, url, error) =>
                            CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url,
                                  downloadProgress) =>
                              Shimmer.fromColors(
                                  baseColor: HexColor(backgroundColor),
                                  highlightColor: Colors.grey.withOpacity(.2),
                                  period: Duration(seconds: 1),
                                  child: Container(
                                    color: HexColor(backgroundColor),
                                  )),
                          errorWidget: (context, url, error) =>
                              CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url,
                                          downloadProgress) =>
                                      Shimmer.fromColors(
                                          baseColor: HexColor(backgroundColor),
                                          highlightColor:
                                              Colors.grey.withOpacity(.2),
                                          period: Duration(seconds: 1),
                                          child: Container(
                                            color: HexColor(backgroundColor),
                                          )),
                                  errorWidget: (context, url, error) =>
                                      SizedBox()),
                        ),
                      ),
                    ),
                    Container(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        alignment: const Alignment(-0.3, 0),
                        image: CachedNetworkImageProvider(image),
                        fit: BoxFit.cover)),
              ),
              // show && username == widget.users[indexer].username
              //     ? Align(
              //         alignment: Alignment.topCenter,
              //         child: SvgPicture.asset(
              //           "assets/icon/slide_following.svg",
              //           color: Colors.green,
              //         ),
              //       )
              //     : const SizedBox.shrink()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              stream.followIds.contains(id)
                  ? SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            height: height,
                            width: width,
                            child: Card(
                              color: Colors.transparent,
                              shadowColor: backgroundSecondary,
                              elevation: 10,
                              child: ProfileActionButtonNotThisUsers(
                                icon: "assets/icon/follow.svg",
                                isSwipe: true,
                                onClick: () async {
                                  // SharedPreferences pref =
                                  //     await SharedPreferences.getInstance();

                                  // await animateButton(0.0, true).whenComplete(
                                  //     () => mounted
                                  //         ? _matchEngine!.currentItem!.like()
                                  //         : null);
                                  // mounted ? animateButton(60.0, false) : null;

                                  // if (username == pref.getString(userNameKey)) {
                                  //   emitter("can n ot follow your self");
                                  // } else {
                                  //   // ignore: use_build_context_synchronously
                                  //   followAction(
                                  //     context,
                                  //     id,
                                  //     username,
                                  //   );
                                  // }
                                },
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}

class MenuCategory extends StatefulWidget {
  TabProvider? tab;
  MenuCategory({super.key, required this.tab});

  @override
  State<MenuCategory> createState() => _MenuCategoryState();
}

class _MenuCategoryState extends State<MenuCategory> {
  // List<String> cat = [
  //   "Verified",
  //   "Unverified",
  // ];
  List<String> cat = [
    "King",
    "Queen",
  ];
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // SizedBox(),
        Row(
          children: [
            ...cat.map((e) => InkWell(
                onTap: () async {
                  //  emitter("test 1 +> $e");
                  widget.tab!.load(true);
                  //  setState(() {});
                  ///   TabProvider tab = Provider.of<TabProvider>(context, listen: false);
                  await widget.tab!.changeFilterHome(e).whenComplete(() async {
                    // await FeedPostController.getFeedPostController(
                    //     context, 1, false, e);
                    FeedPostController.getRoyaltyController(
                        context, e.toLowerCase());
                    //   setState(() {});
                  });
                  widget.tab!.load(false);
                },
                child:
                    CategoryViewHome(name: e, isHome: true, tab: widget.tab!)))
          ],
        ),
      ],
    );
  }
}

class MenuCategorySearch extends StatefulWidget {
  TabProvider? tab;
  MenuCategorySearch({super.key, required this.tab});

  @override
  State<MenuCategorySearch> createState() => _MenuCategorySearchState();
}

class _MenuCategorySearchState extends State<MenuCategorySearch> {
  List<String> cat = [
    "Verified",
    "Unverified",
  ];
  // List<String> cat = [
  //   "King",
  //   "Queen",
  // ];
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // SizedBox(),
        Row(
          children: [
            ...cat.map((e) => InkWell(
                onTap: () async {
                  //  emitter("test 1 +> $e");
                  widget.tab!.load(true);
                  //  setState(() {});
                  ///   TabProvider tab = Provider.of<TabProvider>(context, listen: false);
                  await widget.tab!
                      .changeFilterHomePost(e)
                      .whenComplete(() async {
                    await FeedPostController.getFeedPostController(
                        context, 1, false, e);

                    //   setState(() {});
                  });
                  widget.tab!.load(false);
                },
                child: CategoryViewHomePost(
                    name: e, isHome: true, tab: widget.tab!)))
          ],
        ),
        InkWell(
          onTap: () {
            PageRouting.pushToPage(context, const FriendsScreen());
          },
          child: SvgPicture.asset(
            "assets/icon/searchicon.svg",
            color: Colors.white,
          ),
        )
      ],
    );
  }
}

class HomeGrodViewItems extends StatefulWidget {
  final FeedPost data;
  final int index;
  final double extent;
  const HomeGrodViewItems(
      {super.key,
      required this.data,
      required this.index,
      required this.extent});

  @override
  State<HomeGrodViewItems> createState() => _HomeGrodViewItemsState();
}

class _HomeGrodViewItemsState extends State<HomeGrodViewItems> {
  String? thumbnail = "";
  // VlcPlayerController? controllers;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // UserProfileWare provide =
    //     Provider.of<UserProfileWare>(context, listen: false);

    return InkWell(
        splashColor: HexColor(primaryColor),
        onTap: () async {
          //   print(widget.data.vod!.first ?? "");
          //   Operations.controlSystemColor();
          //   TabProvider action = Provider.of<TabProvider>(context, listen: false);
          //   action.isHomeChange(true);
          //    provide.changeIndex(widget.index);
          PageRouting.pushToPage(
              context, PeopleHome(isHomeGrid: true, index: widget.index));
        },
        child: Container(
          height: widget.extent,
          child: widget.data.media!.first.contains(".mp4") ||
                  widget.data.media!.first.contains(".mp3")
              ? Stack(
                  children: [
                    Container(
                      height: widget.extent,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        // image: DecorationImage(
                        //     fit: BoxFit.cover,
                        //     image: widget.data.media!.first
                        //                 .contains(".mp4") ||
                        //             widget.data.media!.first.contains(".mp3")
                        //         ? CachedNetworkImageProvider(
                        //             widget.data.thumbnails!.first ?? "")
                        //         : CachedNetworkImageProvider(
                        //                 widget.data.media!.first)
                        //             as ImageProvider)
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: widget.extent,
                            width: Get.width,
                            child: CachedNetworkImage(
                              imageUrl: widget.data.media!.first
                                          .contains(".mp4") ||
                                      widget.data.media!.first.contains(".mp3")
                                  ? widget.data.thumbnails!.first ?? ""
                                  : widget.data.media!.first,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      Shimmer.fromColors(
                                          baseColor: HexColor(backgroundColor),
                                          highlightColor:
                                              Colors.grey.withOpacity(.2),
                                          period: Duration(seconds: 1),
                                          child: Container(
                                            color: HexColor(backgroundColor),
                                          )),
                              errorWidget: (context, url, error) =>
                                  CachedNetworkImage(
                                imageUrl: url,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (context, url,
                                        downloadProgress) =>
                                    Shimmer.fromColors(
                                        baseColor: HexColor(backgroundColor),
                                        highlightColor:
                                            Colors.grey.withOpacity(.2),
                                        period: Duration(seconds: 1),
                                        child: Container(
                                          color: HexColor(backgroundColor),
                                        )),
                                errorWidget: (context, url, error) =>
                                    CachedNetworkImage(
                                        imageUrl: url,
                                        fit: BoxFit.cover,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            Shimmer.fromColors(
                                                baseColor:
                                                    HexColor(backgroundColor),
                                                highlightColor:
                                                    Colors.grey.withOpacity(.2),
                                                period: Duration(seconds: 1),
                                                child: Container(
                                                  color:
                                                      HexColor(backgroundColor),
                                                )),
                                        errorWidget: (context, url, error) =>
                                            SizedBox()),
                              ),
                            ),
                          ),
                          widget.data.media!.first.contains(".mp4")
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Lottie.asset("assets/icon/mov.json",
                                      height: 70, width: 70),
                                )
                              : widget.data.media!.first.contains(".mp3")
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        "assets/icon/aud.svg",
                                        height: 25,
                                        width: 25,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                          Positioned(
                              child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: widget.data.viewCount == null
                                  ? SizedBox.shrink()
                                  : Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icon/view.svg",
                                          color: Colors.white,
                                          height: 10,
                                          //   width: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2, left: 3),
                                          child: AppText(
                                            text: Numeral(
                                                    widget.data.viewCount ?? 0)
                                                .format(fractionDigits: 1),
                                            fontWeight: FontWeight.w600,
                                            size: 12,
                                            color: HexColor(backgroundColor),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    // controllers == null
                    //     ? SizedBox.shrink()
                    //     : VlcPlayer(
                    //         controller: controllers!,
                    //         aspectRatio: 16 / 9,
                    //         placeholder:
                    //             const Center(child: CircularProgressIndicator()),
                    //       )
                  ],
                )
              : Container(
                  height: widget.extent,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    // image: DecorationImage(
                    //     fit: BoxFit.cover,
                    //     image: widget.data.media!.first.contains(".mp4")
                    //         ? CachedNetworkImageProvider(
                    //             widget.data.thumbnails!.first ?? "")
                    //         : CachedNetworkImageProvider(
                    //             widget.data.media!.first) as ImageProvider)
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: widget.extent,
                        width: Get.width,
                        child: CachedNetworkImage(
                          imageUrl: widget.data.media!.first.contains(".mp4")
                              ? widget.data.thumbnails!.first ?? ""
                              : widget.data.media!.first,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url,
                                  downloadProgress) =>
                              Shimmer.fromColors(
                                  baseColor: HexColor(backgroundColor),
                                  highlightColor: Colors.grey.withOpacity(.2),
                                  period: Duration(seconds: 1),
                                  child: Container(
                                    color: HexColor(backgroundColor),
                                  )),
                          errorWidget: (context, url, error) =>
                              CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url,
                                    downloadProgress) =>
                                Shimmer.fromColors(
                                    baseColor: HexColor(backgroundColor),
                                    highlightColor: Colors.grey.withOpacity(.2),
                                    period: Duration(seconds: 1),
                                    child: Container(
                                      color: HexColor(backgroundColor),
                                    )),
                            errorWidget: (context, url, error) =>
                                CachedNetworkImage(
                                    imageUrl: url,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        Shimmer.fromColors(
                                            baseColor:
                                                HexColor(backgroundColor),
                                            highlightColor:
                                                Colors.grey.withOpacity(.2),
                                            period: Duration(seconds: 1),
                                            child: Container(
                                              color: HexColor(backgroundColor),
                                            )),
                                    errorWidget: (context, url, error) =>
                                        SizedBox()),
                          ),
                        ),
                      ),
                      widget.data.media!.first.contains(".mp4")
                          ? Icon(
                              Icons.play_arrow,
                              color: Colors.grey.withOpacity(0.9),
                            )
                          : const SizedBox.shrink(),
                      Positioned(
                          child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.data.viewCount == null
                              ? SizedBox.shrink()
                              : Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icon/view.svg",
                                      color: Colors.white,
                                      height: 10,
                                      //   width: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 2, left: 3),
                                      child: AppText(
                                        text:
                                            Numeral(widget.data.viewCount ?? 0)
                                                .format(fractionDigits: 1),
                                        fontWeight: FontWeight.w600,
                                        size: 12,
                                        color: HexColor(backgroundColor),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      )),
                    ],
                  ),
                ),
        ));
  }
}
