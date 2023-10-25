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
  const ProfilePostGrid(
      {super.key,
      required this.ware,
      required this.parentController,
      this.tabKey,
      this.tabName});
  final FeedPostWare ware;
  final ScrollController parentController;
  final Key? tabKey;
  final String? tabName;

  @override
  State<ProfilePostGrid> createState() => _ProfilePostGridState();
}

class _ProfilePostGridState extends State<ProfilePostGrid>
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
              scrolNotify.instance.changeTabOne(true);
              // setState(() {
              //   isParentEdget = false;
              //   physc = true;
              // });
            }
          });
        } else {
          // print("PARENT IS AT THE BOTTOM");

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
            FeedPostWare stream =
                Provider.of<FeedPostWare>(context, listen: false);

            EasyDebounce.debounce(
                'my-debouncer', const Duration(milliseconds: 500), () async {
              await stream.getUserPostFromApi();
              // await streamAudio.getUserPostAudioFromApi();
            });
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeedPostWare stream = Provider.of<FeedPostWare>(context, listen: false);
      stream.changeTabIndex(0);
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

  //bool? physc = true;

  @override
  Widget build(BuildContext context) {
    FeedPostWare stream = context.watch<FeedPostWare>();
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
                  scrolNotify.instance.changeTabOne(true);
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
                scrolNotify.instance.changeTabOne(false);
                // setState(() {
                //   physc = false;
                // });
              }
            });
          }
          return true;
        },
        child: ObxValue((physc) {
          return PagedGridView<int, ProfileFeedDatum>(
            pagingController: stream.pagingController,
            shrinkWrap: true,
            //  physics: const ClampingScrollPhysics(),

            key: PageStorageKey<String>(widget.tabName!),
            scrollController: _scrollController,
            //   physics: const ScrollPhysics(),
            physics: physc.value == true
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
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
                  isAudio: false,
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
        }, scrolNotify.instance.tabOne),
      );
    });

    // return GridView.builder(
    //   key: UniqueKey(),
    //   //controller: _scrollController,
    //   shrinkWrap: true,
    //   // physics: const ScrollPhysics(),
    //   physics: const NeverScrollableScrollPhysics(),
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
    //       isAudio: false,
    //     );
    //   },
    // );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProfilePostAudioGrid extends StatefulWidget {
  const ProfilePostAudioGrid(
      {super.key,
      required this.ware,
      required this.parentController,
      this.tabKey,
      this.tabName});
  final FeedPostWare ware;
  final ScrollController parentController;
  final Key? tabKey;
  final String? tabName;

  @override
  State<ProfilePostAudioGrid> createState() => _ProfilePostAudioGridState();
}

class _ProfilePostAudioGridState extends State<ProfilePostAudioGrid>
    with AutomaticKeepAliveClientMixin {
  ScrollPhysics? ph;
  ScrollController? _scrollController;
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
              scrolNotify.instance.changeTabTwo(true);
              // setState(() {
              //   isParentEdget = false;
              //   physc = true;
              // });
            }
          });
        } else {
          // print("PARENT IS AT THE BOTTOM");

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
            FeedPostWare stream =
                Provider.of<FeedPostWare>(context, listen: false);

            EasyDebounce.debounce(
                'my-debouncer', const Duration(milliseconds: 500), () async {
              await stream.getUserPostAudioFromApi();
              // await streamAudio.getUserPostAudioFromApi();
            });
          });
        }
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FeedPostWare stream = Provider.of<FeedPostWare>(context, listen: false);
      stream.changeTabIndex(1);

      if (stream.profileFeedPosts.isNotEmpty) {
        VideoWare.instance.getAudioPostFromApi(stream.profileFeedPostsAudio);
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
                  scrolNotify.instance.changeTabTwo(true);
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
                scrolNotify.instance.changeTabTwo(false);
                // setState(() {
                //   physc = false;
                // });
              }
            });
          }
          return true;
        },
        child: ObxValue((physc) {
          return PagedGridView<int, ProfileFeedDatum>(
            pagingController: stream.pagingController2,
            shrinkWrap: true,
            key: PageStorageKey<String>(widget.tabName!),

            scrollController: _scrollController,
            //   physics: const ScrollPhysics(),
            physics: physc.value == true
                ? NeverScrollableScrollPhysics()
                : ScrollPhysics(),
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
                  isAudio: true,
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
        }, scrolNotify.instance.tabTwo),
      );
    });

    // return GridView.builder(
    //   //   key: UniqueKey(),
    //   // controller: _scrollController,
    //   shrinkWrap: true,
    //   // physics: const ScrollPhysics(),
    //   physics: const NeverScrollableScrollPhysics(),
    //   primary: false,
    //   padding: const EdgeInsets.only(top: 0),
    //   itemCount: stream.profileFeedPostsAudio.length,
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 3,
    //       childAspectRatio: 200 / 300,
    //       crossAxisSpacing: 1,
    //       mainAxisSpacing: 1),
    //   itemBuilder: (BuildContext context, int index) {
    //     ProfileFeedDatum post = stream.profileFeedPostsAudio[index];
    //     //  print(post.media!.first);
    //     return MyGridViewItems(
    //       data: post,
    //       index: index,
    //       isAudio: true,
    //     );
    //   },
    // );
  }

  @override
  bool get wantKeepAlive => true;
}

class PublicProfilePostGrid extends StatefulWidget {
  const PublicProfilePostGrid(
      {super.key,
      required this.ware,
      required this.parentController,
      this.tabKey,
      this.tabName, required this.username});
  final UserProfileWare ware;
  final ScrollController parentController;
  final Key? tabKey;
  final String? tabName;
  final String? username;

  @override
  State<PublicProfilePostGrid> createState() => _PublicProfilePostGridState();
}

//////////////NEEEEEEEEEE TTTTTTT
class _PublicProfilePostGridState extends State<PublicProfilePostGrid>
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
              scrolNotifyPublic.instance.changeTabOne(true);
              // setState(() {
              //   isParentEdget = false;
              //   physc = true;
              // });
            }
          });
        } else {
          // print("PARENT IS AT THE BOTTOM");

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
            UserProfileWare stream =
                Provider.of<UserProfileWare>(context, listen: false);

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
    UserProfileWare stream = context.watch<UserProfileWare>();
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
                  scrolNotifyPublic.instance.changeTabOne(true);
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
                scrolNotifyPublic.instance.changeTabOne(false);
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
            }, scrolNotifyPublic.instance.tabOne
          ),
        );
      }
    );
  }

  @override
  bool get wantKeepAlive => true;
}



class PublicProfilePostAudioGrid extends StatefulWidget {
  const PublicProfilePostAudioGrid(
      {super.key,
      required this.ware,
      required this.parentController,
      this.tabKey,
      this.tabName, required this.username});
  final UserProfileWare ware;
  final ScrollController parentController;
  final Key? tabKey;
  final String? tabName;
  final String? username;

  @override
  State<PublicProfilePostAudioGrid> createState() => _PublicProfilePostAudioGridState();
}

//////////////NEEEEEEEEEE TTTTTTT
class _PublicProfilePostAudioGridState extends State<PublicProfilePostAudioGrid>
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
              scrolNotifyPublic.instance.changeTabTwo(true);
              // setState(() {
              //   isParentEdget = false;
              //   physc = true;
              // });
            }
          });
        } else {
          // print("PARENT IS AT THE BOTTOM");

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
            UserProfileWare stream =
                Provider.of<UserProfileWare>(context, listen: false);

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
    UserProfileWare stream = context.watch<UserProfileWare>();
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
                  scrolNotifyPublic.instance.changeTabTwo(true);
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
                scrolNotifyPublic.instance.changeTabTwo(false);
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
            }, scrolNotifyPublic.instance.tabTwo
          ),
        );
      }
    );
  }

  @override
  bool get wantKeepAlive => true;
}


