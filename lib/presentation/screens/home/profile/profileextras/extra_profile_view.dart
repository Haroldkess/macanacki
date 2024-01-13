import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
import '../../../../../services/middleware/extra_profile_ware.dart';
import '../../../../../services/middleware/feed_post_ware.dart';
import '../../../../../services/middleware/user_profile_ware.dart';
import '../../../../../services/middleware/video/video_ware.dart';
import '../../../../../services/temps/temps_id.dart';
import '../../../../uiproviders/screen/tab_provider.dart';
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
      physics: const ScrollPhysics(),
      primary: false,
      padding: const EdgeInsets.all(0),
      itemCount: test.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 200 / 300,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1),
      itemBuilder: (BuildContext context, int index) {
        String img = test[index];
        return Shimmer.fromColors(
          baseColor: HexColor(backgroundColor),
          highlightColor: Colors.grey.withOpacity(.2),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
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

class ExtraPublicProfilePostGrid extends StatefulWidget {
  ExtraPublicProfilePostGrid(
      {super.key,
      required this.ware,
      required this.parentController,
      this.tabKey,
      this.tabName,
      required this.username,
      required this.isHome});
  final ExtraProfileWare ware;
  final ScrollController parentController;
  final Key? tabKey;
  final String? tabName;
  final String? username;
  int isHome;

  @override
  State<ExtraPublicProfilePostGrid> createState() =>
      _ExtraPublicProfilePostGridState();
}

//////////////NEEEEEEEEEE TTTTTTT
class _ExtraPublicProfilePostGridState extends State<ExtraPublicProfilePostGrid>
    with AutomaticKeepAliveClientMixin {
  ScrollPhysics? ph;
  ScrollController? _scrollController;
  bool isParentEdget = false;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.position.atEdge) {
        bool isTop = _scrollController!.position.pixels == 0;
        if (isTop) {
          //  print("PARENT IS AT THE TOP");
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              scrolNotifyPublicExtra.instance.changeTabOne(true);
              // setState(() {
              //   isParentEdget = false;
              //   physc = true;
              // });
            }
          });
        } else {
          // print("PARENT IS AT THE BOTTOM");

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
            ExtraProfileWare stream =
                Provider.of<ExtraProfileWare>(context, listen: false);

            // EasyDebounce.debounce(
            //     'my-debouncer', const Duration(milliseconds: 500), () async {
            //   await stream.getUserPostAudioFromApi();
            //   // await streamAudio.getUserPostAudioFromApi();
            // });

            EasyDebounce.debounce(
                'myx-debouncer',
                const Duration(milliseconds: 500),
                () async => await stream.getUserPublicPostFromApi(
                    username: widget.username!));
          });
        }
      }
    });
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
    ExtraProfileWare stream = context.watch<ExtraProfileWare>();
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
            pagingController: stream.pagingController,
            physics: physc.value == true
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
            scrollController: _scrollController,
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

class ExtraPublicProfilePostAudioGrid extends StatefulWidget {
  ExtraPublicProfilePostAudioGrid(
      {super.key,
      required this.ware,
      required this.parentController,
      this.tabKey,
      this.tabName,
      required this.username,
      required this.isHome});
  final ExtraProfileWare ware;
  final ScrollController parentController;
  final Key? tabKey;
  final String? tabName;
  final String? username;
  int isHome;

  @override
  State<ExtraPublicProfilePostAudioGrid> createState() =>
      _ExtraPublicProfilePostAudioGridState();
}

//////////////NEEEEEEEEEE TTTTTTT
class _ExtraPublicProfilePostAudioGridState
    extends State<ExtraPublicProfilePostAudioGrid>
    with AutomaticKeepAliveClientMixin {
  ScrollPhysics? ph;
  ScrollController? _scrollController;
  bool isParentEdget = false;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if (_scrollController!.position.atEdge) {
        bool isTop = _scrollController!.position.pixels == 0;
        if (isTop) {
          //  print("PARENT IS AT THE TOP");
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              scrolNotifyPublicExtra.instance.changeTabTwo(true);
              // setState(() {
              //   isParentEdget = false;
              //   physc = true;
              // });
            }
          });
        } else {
          // print("PARENT IS AT THE BOTTOM");

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
            ExtraProfileWare stream =
                Provider.of<ExtraProfileWare>(context, listen: false);

            // EasyDebounce.debounce(
            //     'my-debouncer', const Duration(milliseconds: 500), () async {
            //   await stream.getUserPostAudioFromApi();
            //   // await streamAudio.getUserPostAudioFromApi();
            // });

            EasyDebounce.debounce(
                'myx-debouncer',
                const Duration(milliseconds: 500),
                () async => await stream.getUserPublicPostAudioFromApi(
                    username: widget.username!));
          });
        }
      }
    });
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
    ExtraProfileWare stream = context.watch<ExtraProfileWare>();
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
                  scrolNotifyPublicExtra.instance.changeTabTwo(true);
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
                scrolNotifyPublicExtra.instance.changeTabTwo(false);
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
            pagingController: stream.pagingController2,
            physics: physc.value == true
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
            scrollController: _scrollController,
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
                  posts: widget.ware.pubPostAudio,
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
        }, scrolNotifyPublicExtra.instance.tabTwo),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
