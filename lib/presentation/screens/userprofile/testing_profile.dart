import 'dart:convert';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:macanacki/presentation/screens/userprofile/extras/test_profle_view.dart';
import 'package:macanacki/presentation/uiproviders/screen/tab_provider.dart';
import 'package:macanacki/presentation/widgets/debug_emitter.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/notification_ware..dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../model/public_profile_model.dart';
import '../../../services/backoffice/user_profile_office.dart';
import '../../../services/controllers/chat_controller.dart';
import '../../../services/controllers/feed_post_controller.dart';
import '../../../services/controllers/user_profile_controller.dart';
import '../../../services/middleware/chat_ware.dart';
import '../../../services/middleware/extra_profile_ware.dart';
import '../../../services/middleware/feed_post_ware.dart';
import '../../../services/middleware/gift_ware.dart';
import '../../../services/middleware/user_profile_ware.dart';
import '../../../services/middleware/video/video_ware.dart';
import '../../allNavigation.dart';
import '../../constants/colors.dart';
import '../../widgets/app_bar.dart';
import '../home/diamond/diamond_modal/buy_modal.dart';
import '../home/diamond/diamond_modal/give_modal.dart';
import '../home/profile/profileextras/extra_profile_view.dart';
import '../home/profile/profileextras/profile_info.dart';
import '../home/profile/profileextras/profile_post_grid.dart';
import '../notification/notification_screen.dart';
import 'extras/public_profile_info.dart';

class TestProfile extends StatefulWidget {
  final String username;
  final bool extended;
  final String? page;
  const TestProfile(
      {super.key, required this.username, required this.extended, this.page});

  @override
  State<TestProfile> createState() => _TestProfileState();
}

class _TestProfileState extends State<TestProfile>
    with SingleTickerProviderStateMixin {
  bool showMore = false;
  int seeMoreVal = 100;
  TabController? _tabController;
  // String myUsername = "";
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  final ScrollController _controller = ScrollController();
  //late ExtraProfileWare stream;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final List<String> _tabs = ["others", "audio"];
  PublicUserData publicUserProfileModel = PublicUserData();
  List<PublicUserPost> allPublicUserPostData = [];
  List<PublicUserPost> allPublicUserPostDataAudio = [];
  int pageNumber = 1;
  int pageNumberAudio = 1;
  bool loading = false;
  bool loadStatus2 = false;
  bool loadingAudio = false;
  int numberOfPostsPerRequest = 10;
  PagingController<int, PublicUserPost> pagingController =
      PagingController(firstPageKey: 0);
  PagingController<int, PublicUserPost> pagingController2 =
      PagingController(firstPageKey: 1);
  bool isLastPage = false;
  bool isLastPageAudio = false;
  int nextPageTrigger = 3;

  void disposeAutoScroll() {
    setState(() {
      isLastPage = false;
      pageNumber = 1;
      pageNumberAudio = 1;
      loading = false;
      isLastPageAudio = false;
      numberOfPostsPerRequest = 10;
      nextPageTrigger = 3;

      allPublicUserPostData.clear();
      allPublicUserPostDataAudio.clear();
    });
  }

  void initializePagingController() {
    setState(() {
      pagingController = PagingController(firstPageKey: 1);
      pagingController2 = PagingController(firstPageKey: 1);
    });
    disposeAutoScroll();
  }

  ScrollController? _scrollController;

  ScrollController? _scrollController2;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabs.length);

    _scrollController = ScrollController();

    _scrollController2 = ScrollController();
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
            EasyDebounce.debounce(
                'myx-debouncer',
                const Duration(milliseconds: 500),
                () async =>
                    await getUserPublicPostFromApi(username: widget.username));
          });
        }
      }
    });

    _scrollController2!.addListener(() {
      if (_scrollController2!.position.atEdge) {
        bool isTop = _scrollController2!.position.pixels == 0;
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
            EasyDebounce.debounce(
                'myx-debouncer',
                const Duration(milliseconds: 500),
                () async => await getUserPublicPostAudioFromApi(
                    username: widget.username));
          });
        }
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      disposeAutoScroll();
      initializePagingController();
      getData(true);
      _controller.addListener(() {
        if (_controller.position.atEdge) {
          bool isTop = _controller.position.pixels == 0;
          if (isTop) {
            //  print("PARENT IS AT THE TOP");
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (mounted) {
                scrolNotifyPublicExtra.instance.changeTabOne(true);
                scrolNotifyPublicExtra.instance.changeTabTwo(true);
              }
            });
          } else {
            // print("PARENT IS AT THE BOTTOM");
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (mounted) {
                scrolNotifyPublicExtra.instance.changeTabOne(false);
                scrolNotifyPublicExtra.instance.changeTabTwo(false);
                // setState(() {

                //   physc = false;
                // });
              }
            });
          }
        } else if (_controller.position.pixels >
            (_controller.position.maxScrollExtent - 25)) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              scrolNotifyPublicExtra.instance.changeTabOne(false);
              scrolNotifyPublicExtra.instance.changeTabTwo(false);
              // setState(() {

              //   physc = false;
              // });
            }
          });
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ChatWare chatWare = Provider.of<ChatWare>(context, listen: false);
      chatWare.isLoading(false);
    });
  }

  Future<void> _onRefresh() async {
    await getData(true);
    disposeAutoScroll();
    pagingController.refresh();
    pagingController2.refresh();
  }

  static const _indicatorSize = 150.0;

  /// Whether to render check mark instead of spinner
  bool _renderCompleteState = false;

  ScrollDirection prevScrollDirection = ScrollDirection.idle;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // stream = context.watch<ExtraProfileWare>();
    NotificationWare notify = context.watch<NotificationWare>();

    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#F5F2F9"),
        body: CustomRefreshIndicator(
          onStateChanged: (change) {
            /// set [_renderCompleteState] to true when controller.state become completed
            if (change.didChange(to: IndicatorState.complete)) {
              setState(() {
                _renderCompleteState = true;
              });

              /// set [_renderCompleteState] to false when controller.state become idle
            } else if (change.didChange(to: IndicatorState.idle)) {
              setState(() {
                _renderCompleteState = false;
              });
            }
          },
          builder: (
            BuildContext context,
            Widget child,
            IndicatorController controller,
          ) {
            return Stack(
              children: <Widget>[
                AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget? _) {
                    if (controller.scrollingDirection ==
                            ScrollDirection.reverse &&
                        prevScrollDirection == ScrollDirection.forward) {
                      // controller.stopDrag();
                    }

                    prevScrollDirection = controller.scrollingDirection;

                    final containerHeight = controller.value * _indicatorSize;

                    return Container(
                      alignment: Alignment.center,
                      height: containerHeight,
                      child: OverflowBox(
                        maxHeight: 40,
                        minHeight: 40,
                        maxWidth: 40,
                        minWidth: 40,
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _renderCompleteState
                                ? Colors.greenAccent
                                : HexColor(primaryColor),
                            shape: BoxShape.circle,
                          ),
                          child: _renderCompleteState
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.white),
                                    value: controller.isDragging ||
                                            controller.isArmed
                                        ? controller.value.clamp(0.0, 1.0)
                                        : null,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  builder: (context, _) {
                    return Transform.translate(
                      offset: Offset(0.0, controller.value * _indicatorSize),
                      child: child,
                    );
                  },
                  animation: controller,
                ),
              ],
            );
          },
          notificationPredicate: (notification) {
            // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
            return notification.depth == 0;
          },
          onRefresh: () async {
            await _onRefresh();
          },
          child: ExtendedNestedScrollView(
            controller: _controller,

            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  leading: BackButton(color: Colors.black),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // myIcon("assets/icon/macanackiicon.svg", primaryColor, 16.52,
                      //     70, false),
                      InkWell(
                        onTap: () => PageRouting.pushToPage(
                            context, const NotificationScreen()),
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              "assets/icon/notification.svg",
                            ),
                            notify.readAll
                                ? SizedBox.shrink()
                                : Positioned(
                                    right: 5,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Center(
                                            child: AppText(
                                              text: notify.notifyData.length > 9
                                                  ? ""
                                                  : "",
                                              size: 8,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),

                        // myIcon("assets/icon/notification.svg", "#828282",
                        //     19.13, 17.31, true),
                      ),
                    ],
                  ),
                  // floating: true,
                  pinned: true,
                  backgroundColor: HexColor("#F5F2F9"),
                  expandedHeight: 370,
                  flexibleSpace: FlexibleSpaceBar(
                    background: loadStatus2
                        ? const PublicLoader()
                        : PublicProfileInfoTest(
                            isMine: false,
                            stream: publicUserProfileModel,
                          ),
                  ),
                ),
                publicUserProfileModel.aboutMe != null
                    ? SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: showMore ? 3 : 2,
                                  text: TextSpan(
                                      text: publicUserProfileModel
                                                      .aboutMe!.length >=
                                                  seeMoreVal &&
                                              showMore == false
                                          ? publicUserProfileModel.aboutMe!
                                              .substring(0, seeMoreVal - 3)
                                          : publicUserProfileModel.aboutMe!,
                                      style: GoogleFonts.leagueSpartan(
                                          textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: HexColor(darkColor)
                                            .withOpacity(0.6),
                                        decorationStyle:
                                            TextDecorationStyle.solid,
                                        fontSize: 10,
                                        fontFamily: '',
                                      )),
                                      recognizer: tapGestureRecognizer
                                        ..onTap = () async {
                                          //    print("object");
                                          if (showMore) {
                                            setState(() {
                                              showMore = false;
                                            });
                                          } else {
                                            setState(() {
                                              showMore = true;
                                            });
                                          }
                                        },
                                      children: [
                                        publicUserProfileModel.aboutMe!.length <
                                                seeMoreVal
                                            ? const TextSpan(text: "")
                                            : TextSpan(
                                                text: showMore
                                                    ? " "
                                                    : "...see more",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: HexColor(darkColor)
                                                      .withOpacity(0.6),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                recognizer: tapGestureRecognizer
                                                  ..onTap = () async {
                                                    if (showMore) {
                                                      setState(() {
                                                        showMore = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        showMore = true;
                                                      });
                                                    }
                                                  },
                                              )
                                      ])),
                            )),
                          ],
                        ),
                      )
                    : const SliverToBoxAdapter(
                        child: SizedBox(height: 20),
                      ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ProfileQuickLinks(
                        onClick: () {
                          // showToast2(context, "Feature coming soon");
                        },
                        name: "Block Account",
                        icon: "assets/icon/block.svg",
                        color: Colors.grey,
                        isVerified: false,
                      ),
                      ProfileQuickLinks(
                        onClick: () async {},
                        name: "report Account",
                        icon: "assets/icon/report.svg",
                        color: Colors.grey,
                        isVerified: false,
                      ),
                      ProfileQuickLinks(
                        onClick: () {
                          if (int.tryParse(GiftWare.instance.gift.value.data
                                  .toString())! <
                              50) {
                            buyDiamondsModal(
                                context, GiftWare.instance.rate.value.data);
                          } else {
                            giveDiamondsModal(
                                context, publicUserProfileModel.username!);
                          }
                        },
                        name: "Give Diamond",
                        icon: "assets/icon/diamond.svg",
                        color: null,
                        isVerified: true,
                      )
                    ],
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ];
            },
            restorationId: 'Tab${_tabController!.index}',
            // innerScrollPositionKeyBuilder: () {
            //   return Key('Tab${_tabController.index}');
            // },

            pinnedHeaderSliverHeightBuilder: () {
              final double statusBarHeight = MediaQuery.of(context).padding.top;
              var pinnedHeaderHeight =
                  //statusBar height
                  statusBarHeight +
                      //pinned SliverAppBar height in header
                      kToolbarHeight;
              return pinnedHeaderHeight;
            },
            onlyOneScrollInBody: true,
            body: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.grey,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.grey,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
                  labelPadding: EdgeInsets.only(bottom: 10),
                  onTap: (index) {
                    FeedPostWare ind =
                        Provider.of<FeedPostWare>(context, listen: false);
                    ind.changeTabIndex(index);
                  },
                  tabs: _tabs
                      .map((String tab) => tab == "others"
                          ? Container(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                "assets/icon/vid.svg",
                                color: Colors.grey,
                              ))
                          : Container(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset("assets/icon/aud.svg",
                                  color: Colors.grey)))
                      .toList(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _tabs.asMap().entries.map((entry) {
                      return entry.value == "others"
                          ? TestPublicProfilePostGrid(
                              pubPost: allPublicUserPostData,
                              scrollController: _scrollController,
                              tabKey: Key('Tab${entry.key}'),
                              tabName: entry.value,
                              username: widget.username,
                              isHome: 0,
                              pagingController: pagingController,
                            )
                          : TestPublicProfilePostGridAudio(
                              pubPost: allPublicUserPostDataAudio,
                              scrollController: _scrollController2,
                              tabKey: Key('Tab${entry.key}'),
                              tabName: entry.value,
                              username: widget.username,
                              isHome: 0,
                              pagingController: pagingController2,
                            );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myIcon(String svgPath, String hexString, double height, double width,
      bool isNotification) {
    return Stack(
      children: [
        SvgPicture.asset(
          svgPath,
          height: height,
          width: width,
          color: HexColor(hexString),
        ),
        isNotification
            ? const Positioned(
                right: 2.0,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.red,
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  Future<void> getData(bool isRef) async {
    if (isRef) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        await getPublicUserProfileFromApi(widget.username);

        //Re-initializing pagingController
        disposeAutoScroll();
        initializePagingController();
        getUserPublicPostFromApi(username: widget.username);
        getUserPublicPostAudioFromApi(username: widget.username);
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        if (publicUserProfileModel.username == null) {
          getUserPublicPostFromApi(username: widget.username);
          getUserPublicPostAudioFromApi(username: widget.username);
          await getPublicUserProfileFromApi(widget.username);
          getUserPublicPostFromApi(username: widget.username);
          getUserPublicPostAudioFromApi(username: widget.username);
        } else {
          if (publicUserProfileModel.username == widget.username) {
            await getPublicUserProfileFromApi(widget.username);
            getUserPublicPostFromApi(username: widget.username);
            getUserPublicPostAudioFromApi(username: widget.username);

            return;
          } else {
            getUserPublicPostFromApi(username: widget.username);
            getUserPublicPostAudioFromApi(username: widget.username);
            await getPublicUserProfileFromApi(widget.username);
          }
        }
      });
    }
  }

  void resetPublicUser() {
    setState(() {
      publicUserProfileModel = PublicUserData();
    });
  }

  Future<void> isLoading2(bool isLoad) async {
    setState(() {
      loadStatus2 = isLoad;
    });
  }

  void updateLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  void updateLoadingAudio(bool value) {
    setState(() {
      loadingAudio = value;
    });
  }

  void updateAllPublicUserPostData(List<PublicUserPost> value) {
    setState(() {
      allPublicUserPostData.addAll(value);
    });
  }

  void updateAllPublicUserPostDataAudio(List<PublicUserPost> value) {
    setState(() {
      allPublicUserPostDataAudio.addAll(value);
    });
  }

  void updatePageNumber(int value, bool audio) {
    setState(() {
      if (audio) {
        pageNumberAudio = value;
      } else {
        pageNumber = value;
      }
    });
  }

  void updateIsLastPage(bool value, bool audio) {
    setState(() {
      if (audio) {
        isLastPageAudio = value;
      } else {
        isLastPage = value;
      }
    });
  }

  Future<bool> getUserPublicPostFromApi({required String username}) async {
    late bool isSuccessful;
    if (loading == true || isLastPage == true) return false;

    try {
      updateLoading(true);
      // final username = publicUserProfileModel.username ?? '';
      http.Response? response = await getUserPublicPost(
              username, pageNumber, numberOfPostsPerRequest, "videos_images")
          .whenComplete(() => emitter("user posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        int recordCount = jsonData['record_count'];
        List<PublicUserPost> newItems = [];
        for (final x in jsonData['data']) {
          newItems.add(PublicUserPost.fromJson(x));
        }

        updateAllPublicUserPostData(newItems);
        updatePageNumber(pageNumber + 1, false);
        updateIsLastPage(allPublicUserPostData.length >= recordCount, false);

        if (isLastPage == true) {
          setState(() {
            pagingController.appendLastPage(newItems);
          });
        } else {
          setState(() {
            pagingController.appendPage(newItems, pageNumber);
          });
        }

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          VideoWare.instance.getVideoPostFromApi(allPublicUserPostData);
        });

        isSuccessful = true;
      } else {
        // log("get user posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    } finally {
      updateLoading(false);
    }

    return isSuccessful;
  }

  Future<bool> getUserPublicPostAudioFromApi({required String username}) async {
    late bool isSuccessful;
    if (loadingAudio == true || isLastPageAudio == true) return false;

    try {
      updateLoadingAudio(true);
      // final username = publicUserProfileModel.username ?? '';
      http.Response? response = await getUserPublicPost(
              username, pageNumberAudio, numberOfPostsPerRequest, "audios")
          .whenComplete(() => emitter("user posts data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        //   log("get user posts data request failed");
      } else if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        int recordCount = jsonData['record_count'];
        List<PublicUserPost> newItems = [];
        for (final x in jsonData['data']) {
          newItems.add(PublicUserPost.fromJson(x));
        }

        updateAllPublicUserPostDataAudio(newItems);
        updatePageNumber(pageNumberAudio + 1, true);
        updateIsLastPage(
            allPublicUserPostDataAudio.length >= recordCount, true);

        if (isLastPageAudio == true) {
          setState(() {
            pagingController2.appendLastPage(newItems);
          });
        } else {
          setState(() {
            pagingController2.appendPage(newItems, pageNumberAudio);
          });
        }

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          VideoWare.instance.getAudioPostFromApi(allPublicUserPostDataAudio);
        });

        isSuccessful = true;
      } else {
        // log("get user posts data  request failed");
        isSuccessful = false;
      }
    } catch (e) {
      isSuccessful = false;
    } finally {
      updateLoadingAudio(false);
    }

    return isSuccessful;
  }

  Future<bool> getPublicUserProfileFromApi(String username) async {
    late bool isSuccessful;
    resetPublicUser();
    isLoading2(true);

    try {
      http.Response? response = await getUserPublicProfile(username)
          .whenComplete(() => emitter("user profile data gotten successfully"));
      if (response == null) {
        isSuccessful = false;
        // log("get user profile data request failed");
      } else if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        var incomingData = PublicProfileModel.fromJson(jsonData);
        publicUserProfileModel = incomingData.data!;

        //   log("get user profile data  request success");
        isSuccessful = true;
        isLoading2(false);
      } else {
        //   log("get user profile data  request failed");
        isSuccessful = false;
        isLoading2(false);
      }
    } catch (e) {
      isSuccessful = false;
      isLoading2(false);
    }
    isLoading2(false);

    return isSuccessful;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emitter("Disposinggggggggggggggggg");
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.page == "audio" ||
            widget.page == "swipe" ||
            widget.page == "feed") {
          if (PersistentNavController.instance.hide.value == true) {
            PersistentNavController.instance.toggleHide();
          }
        }
        // disposeAutoScroll();
      });
    }

    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ProfileQuickLinks extends StatelessWidget {
  String name;
  String icon;
  VoidCallback onClick;
  Color? color;
  bool isVerified;
  ProfileQuickLinks(
      {super.key,
      required this.name,
      required this.icon,
      required this.color,
      required this.isVerified,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onClick,
      child: Card(
        //  elevation: 10,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(80),
        //   //set border radius more than 50% of height and width to make circle
        // ),
        child: Container(
          height: 61,
          width: size.width * 0.28,
          decoration: BoxDecoration(
              color: HexColor(backgroundColor),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(icon, height: 19, width: 19, color: color),
              const SizedBox(
                height: 10,
              ),
              AppText(
                text: name,
                size: 12,
                fontWeight: FontWeight.w400,
                color: HexColor("#828282"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
