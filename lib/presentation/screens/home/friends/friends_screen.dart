import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/services/middleware/friends/friends_ware.dart';
import 'package:numeral/numeral.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../model/feed_post_model.dart';
import '../../../constants/colors.dart';
import '../../../constants/string.dart';
import '../../../uiproviders/screen/tab_provider.dart';
import '../../../widgets/debug_emitter.dart';
import '../../../widgets/text.dart';
import '../Feed/friends_page_view.dart';
import '../search/global_search_screen.dart';
import '../search/searchextras/search_bar.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    //  await Future.delayed(Duration(milliseconds: 1000));
    await FriendWare.instance.getFriendsPostFromApi(1);
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await paginateFeed();
    if (mounted) setState(() {});
    // _refreshController.loadNoData();
    _refreshController.loadComplete();

    // monitor network fetch

    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
  }

  Future paginateFeed() async {
    emitter("Pageinating");
    FriendWare provide = FriendWare.instance;

    ///  provide.indexChange(index);

    // int checkNum = provide.feedPosts.length - 3; // lenght of posts
    int pageNum = provide.friends.value.currentPage!; // api current  page num
    int maxPages = provide.friends.value.lastPage!; // api last page num
    //  emitter("there");
    //  emitter(maxPages.toString());
    // emitter(pageNum.toString());

    if (pageNum >= maxPages) {
      emitter("cannot paginate");
      return;
    } else {
      //  emitter("PAGINTATING");
      if (provide.loadPost.value) {
        return;
      }
      await provide
          .getFriendsPostFromApi(pageNum + 1, true)
          .whenComplete(() => emitter("paginated"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundSecondary,
        // backgroundColor: HexColor("#F5F2F9"),
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: Size(0, 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 0.0, bottom: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        BackButton(
                          color: textPrimary,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => PageRouting.pushToPage(
                                context, const GlobalSearch()),
                            child: GlobalSearchBarHolder(
                                // x: controller,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // title: Padding(
          //   padding: const EdgeInsets.only(top: 20),
          //   child: AppText(
          //     text: "Global Search",
          //     color: Colors.black,
          //     size: 20,
          //     fontWeight: FontWeight.w800,
          //   ),
          // ),
          // centerTitle: true,
          // leading: const BackButton(color: Colors.black),
          elevation: 0,
          backgroundColor: HexColor(backgroundColor),
          toolbarHeight: 60,
        ),
        body: GetX<FriendWare>(
            //   stream: null,
            builder: (friends) {
          return GestureDetector(
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    children: [
                      AppText(
                        text: "Post from people you follow",
                        color: textPrimary,
                        size: 13,
                      )
                    ],
                  ),
                ),
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
                          body = Text("pull up load");
                        } else if (mode == LoadStatus.loading) {
                          body = CupertinoActivityIndicator(
                            color: textWhite,
                          );
                        } else if (mode == LoadStatus.failed) {
                          body = const Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("release to load more");
                        } else {
                          body = Text("No more Data");
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
                    child: GridView.builder(
                        itemCount: friends.friendPost.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 200 / 300,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1),
                        itemBuilder: (context, index) {
                          FeedPost _data = friends.friendPost[index];
                          return _data.media == null
                              ? SizedBox.shrink()
                              : _data.media!.isEmpty
                                  ? SizedBox.shrink()
                                  : FriendsViewItems(
                                      data: _data,
                                      index: index,
                                    );
                        }),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class FriendsViewItems extends StatefulWidget {
  final FeedPost data;
  final int index;
  const FriendsViewItems({super.key, required this.data, required this.index});

  @override
  State<FriendsViewItems> createState() => _FriendsViewItemsState();
}

class _FriendsViewItemsState extends State<FriendsViewItems> {
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
            context,
            FriendsPageView(
              index: widget.index,
            ));
      },
      child: widget.data.media!.first.contains(".mp4") ||
              widget.data.media!.first.contains(".mp3")
          ? Stack(
              children: [
                Container(
                  height: Get.height,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),

                    // image: DecorationImage(
                    //     fit: BoxFit.cover,
                    //     image: widget.data.media!.first.contains(".mp4") ||
                    //             widget.data.media!.first.contains(".mp3")
                    //         ? CachedNetworkImageProvider(
                    //             widget.data.thumbnails!.first ?? "")
                    //         : CachedNetworkImageProvider(
                    //             widget.data.media!.first) as ImageProvider)
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: Get.height,
                        width: Get.width,
                        child: CachedNetworkImage(
                          imageUrl: widget.data.media!.first.contains(".mp4") ||
                                  widget.data.media!.first.contains(".mp3")
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
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                // image: DecorationImage(
                //     fit: BoxFit.cover,
                //     image: widget.data.media!.first.contains(".mp4")
                //         ? CachedNetworkImageProvider(
                //             widget.data.thumbnails!.first ?? "")
                //         : CachedNetworkImageProvider(widget.data.media!.first)
                //             as ImageProvider)
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: Get.height,
                    width: Get.width,
                    child: CachedNetworkImage(
                      imageUrl: widget.data.media!.first.contains(".mp4")
                          ? widget.data.thumbnails!.first ?? ""
                          : widget.data.media!.first,
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
                      errorWidget: (context, url, error) => CachedNetworkImage(
                        imageUrl: url,
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
                                  padding:
                                      const EdgeInsets.only(top: 2, left: 3),
                                  child: AppText(
                                    text: Numeral(widget.data.viewCount ?? 0)
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
    );
  }
}
