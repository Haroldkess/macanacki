// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/home/Feed/feed_home.dart';
import 'package:macanacki/presentation/screens/home/convo/conversation_screen.dart';
import 'package:macanacki/presentation/screens/home/profile/profile_screen.dart';
import 'package:macanacki/presentation/screens/home/search/global_search_screen.dart';
import 'package:macanacki/presentation/screens/home/swipes/swipe_card_screen.dart';
import 'package:macanacki/presentation/uiproviders/screen/tab_provider.dart';
import 'package:macanacki/presentation/widgets/drawer.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/chat_controller.dart';
import 'package:macanacki/services/controllers/feed_post_controller.dart';
import 'package:macanacki/services/controllers/mode_controller.dart';
import 'package:macanacki/services/controllers/notification_controller.dart';
import 'package:macanacki/services/controllers/swipe_users_controller.dart';
import 'package:macanacki/services/controllers/update_app.dart';
import 'package:macanacki/services/controllers/user_profile_controller.dart';
import 'package:macanacki/services/middleware/gift_ware.dart';
import 'package:macanacki/services/middleware/video/video_ware.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../model/feed_post_model.dart';
import '../../../services/controllers/action_controller.dart';
import '../../../services/middleware/chat_ware.dart';
import '../../../services/middleware/feed_post_ware.dart';
import '../../../services/middleware/swipe_ware.dart';
import '../../../services/middleware/user_profile_ware.dart';
import '../../uiproviders/screen/find_people_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/debug_emitter.dart';
import '../../widgets/screen_loader.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  // final SystemUiOverlayStyle _currentStyle = SystemUiOverlayStyle(
  //     systemNavigationBarIconBrightness: Brightness.dark,
  //     systemNavigationBarColor: HexColor(backgroundColor));
  // late Timer reloadTime;
  final AsyncMemoizer _memoizerUser = AsyncMemoizer();
  final AsyncMemoizer _memoizer2 = AsyncMemoizer();
  final AsyncMemoizer _memoizerChat = AsyncMemoizer();
  int trackTaps = 0;
  final List<Widget> _children = [
    const FeedHome(),
    const GlobalSearch(),
    const SwipeCardScreen(),
    const ConversationScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    TabProvider provide = Provider.of<TabProvider>(context, listen: false);
    TabProvider tabs = context.watch<TabProvider>();
    ChatWare chat = context.watch<ChatWare>();
    FindPeopleProvider listen = context.watch<FindPeopleProvider>();
    UserProfileWare user = context.watch<UserProfileWare>();

    _memoizer2.runOnce(() => ChatController.initSocket(context)
        .whenComplete(() => ChatController.addUserToSocket(context)));
    if (chat.socket != null) {
      //  ChatController.addUserToSocket(context);
      _memoizerChat.runOnce(() => ChatController.listenForMessages(context));

      _memoizerUser.runOnce(() => ChatController.listenForUser(context));
      // ChatController.listenForUser(context);
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: tabs.index == 4 || tabs.index == 2
            ? HexColor(backgroundColor)
            : HexColor("#F5F2F9"),
        appBar: tabs.index == 0 ||
                tabs.index == 3 ||
                tabs.index == 4 ||
                tabs.index == 1 ||
                tabs.index == 2
            ? null
            : AppHeader(
                index: tabs.index,
                color: tabs.index == 4
                    ? HexColor(backgroundColor)
                    : Colors.transparent,
              ),
        body: StreamBuilder(
            stream: streamSocketMsgs.getResponse,
            builder: (con, AsyncSnapshot<dynamic> snapshot) {
              // if (tabs.index != 0) {
              //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              //     try {
              //       if (provide.controller != null) {
              //         if (provide.controller!.value.isInitialized) {
              //           if (provide.controller!.value.isBuffering ||
              //               provide.controller!.value.isPlaying) {
              //             if (mounted) {
              //               provide.tap(true);
              //               try {
              //                 provide.pauseControl();
              //                 provide.tap(true);
              //               } catch (e) {}
              //             }
              //           } else {
              //             if (mounted) {
              //               provide.pauseControl();
              //               provide.tap(true);
              //             }
              //           }
              //         }
              //       }
              //     } catch (e) {
              //       //   emitter(e.toString());
              //     }
              //   });
              // }
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    if (mounted) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((timeStamp) async {
                        ChatController.handleMessage(context, snapshot.data);
                        streamSocketMsgs.addResponse(null);
                      });
                    }
                  } else {
                    emitter("snapshot is null");
                  }
                }
              }
              return SizedBox(
                height: Get.height,
                width: Get.width,
                child: StreamBuilder(
                    stream: streamSocket.getResponse,
                    builder: (con, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            if (mounted) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) async {
                                ChatController.addUserToList(
                                    context, snapshot.data);
                                streamSocket.addResponse(null);
                              });
                            }
                          } else {
                            emitter("snapshot is null");
                          }
                        }
                      }
                      return ObxValue((nav) {
                        return PersistentTabView(
                          context,
                          controller: tabs.persistentPagecontroller,
                          items: _navBarsItems(),
                          screens: _children,
                          handleAndroidBackButtonPress: true,
                          hideNavigationBarWhenKeyboardShows: true,
                          navBarStyle: NavBarStyle.style12,
                          confineInSafeArea: true,
                          hideNavigationBar: nav.value,
                          stateManagement: true,
                          popAllScreensOnTapAnyTabs: true,
                          // onWillPop: (context) async {
                          //   final shouldPop =
                          //       await Operations.showWarning(context!);
                          //   return shouldPop!;
                          // },

                          backgroundColor: Platform.isIOS
                              ? Colors.black
                              : HexColor(backgroundColor),
                          popAllScreensOnTapOfSelectedTab: true,
                          onItemSelected: (index) {
                            //   print(index);
                            runTask(index);
                          },
                          //  resizeToAvoidBottomInset: true,
                          screenTransitionAnimation:
                              const ScreenTransitionAnimation(
                            // Screen transition animation on change of selected tab.
                            animateTabTransition: true,
                            curve: Curves.ease,
                            duration: Duration(milliseconds: 200),
                          ),
                          decoration: NavBarDecoration(
                            borderRadius: BorderRadius.circular(0.0),
                            colorBehindNavBar: Colors.white,
                          ),
                        );
                      }, PersistentNavController.instance.hide);

                      //   PageView(
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   controller: tabs.pageController,
                      //   children: _children,
                      //   onPageChanged: (index) {
                      //     provide.changeIndex(index);
                      //   },
                      // );
                    }),
              );
            }),
        // bottomNavigationBar: CupertinoTabBar(
        //   currentIndex: context.watch<TabProvider>().index,
        //   onTap: (index) async {
        //     // Operations.controlSystemColor();

        //     provide.changeIndex(index);
        //     ChatController.initSocket(context)
        //         .whenComplete(() => ChatController.addUserToSocket(context));
        //     // if (chat.socket != null) {
        //     //   ChatController.addUserToSocket(context);
        //     // }
        //     if (chat.chatPage != 0) {
        //       ChatController.changeChatPage(context, 0);
        //     }

        //     if (provide.index == 0) {
        //       provide.addtapTrack();
        //       if (provide.index == 0 &&
        //           index == 0 &&
        //           provide.tapTracker > 1) {
        //         await FeedPostController.reloadPage(context);

        //         // setState(() {});
        //         // setState(() {
        //         //   FeedHome().createState().dispose();

        //         //   // _children = [

        //         //   //   const GlobalSearch(),
        //         //   //   const SwipeCardScreen(),
        //         //   //   const ConversationScreen(),
        //         //   //   const ProfileScreen(),
        //         //   // ];
        //         // });

        //         // setState(() {
        //         //   FeedHome().createState().build(context);
        //         // });
        //         //  emitter("referesh");
        //       }
        //       tabs.pageController!.animateToPage(
        //         index,
        //         duration: const Duration(milliseconds: 1),
        //         curve: Curves.easeIn,
        //       );
        //       if (provide.isTapped) {
        //         provide.tap(false);
        //       }
        //       provide.isHomeChange(false);
        //     } else {
        //       if (index == 4) {
        //         try {
        //           NotificationController.retrievNotificationController(
        //               context, false);
        //           // if (provide.controller != null) {
        //           //   if (provide.controller!.value.isInitialized) {
        //           //     if (provide.controller!.value.isBuffering ||
        //           //         provide.controller!.value.isPlaying) {
        //           //       if (mounted) {
        //           //       //  provide.pauseControl();
        //           //       //  provide.tap(true);
        //           //       }
        //           //     } else {
        //           //       if (mounted) {
        //           //       //  provide.pauseControl();
        //           //      //   provide.tap(true);
        //           //       }
        //           //     }
        //           //   }
        //           // }
        //         } catch (e) {
        //           emitter(e.toString());
        //         }
        //       }
        //       // setState(() {
        //       //   trackTaps = 0;
        //       // });
        //       provide.tapTrack(0);
        //       tabs.pageController!.animateToPage(
        //         index,
        //         duration: const Duration(milliseconds: 1),
        //         curve: Curves.easeIn,
        //       );
        //       try {
        //         // if (provide.controller != null) {
        //         //   if (provide.controller!.value.isInitialized) {
        //         //     if (provide.controller!.value.isBuffering ||
        //         //         provide.controller!.value.isPlaying) {
        //         //       if (mounted) {
        //         //         provide.pauseControl();
        //         //         provide.tap(true);
        //         //       }
        //         //     } else {
        //         //       if (mounted) {
        //         //         provide.pauseControl();
        //         //         provide.tap(true);
        //         //       }
        //         //     }
        //         //   }
        //         // }
        //       } catch (e) {
        //         emitter(e.toString());
        //       }
        //       //provide.isHomeChange(true);
        //     }
        //   },
        //   items: [
        //     barItem('assets/icon/home.svg', tabs.index == 0 ? true : false),
        //     barItem('assets/icon/search.svg', tabs.index == 1 ? true : false),
        //     barItem('assets/icon/crown.svg', tabs.index == 2 ? true : false),
        //     barItem(
        //         'assets/icon/chat.svg', tabs.index == 3 ? true : false, true),
        //     barItem(
        //         'assets/icon/profile.svg', tabs.index == 4 ? true : false),
        //   ],
        //   activeColor: HexColor(primaryColor),
        //   backgroundColor:
        //       Platform.isIOS ? Colors.black : HexColor(backgroundColor),
        // ),
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/icon/home.svg',
          height: 18,
          width: 18,
          color: HexColor(primaryColor),
        ),
        title: ("Home"),

        activeColorPrimary: HexColor(primaryColor),
        inactiveColorPrimary: HexColor("#C0C0C0"),
        activeColorSecondary: HexColor(primaryColor),
        inactiveIcon: SvgPicture.asset(
          'assets/icon/home.svg',
          height: 18,
          width: 18,
          color: HexColor("#C0C0C0"),
        ),

        // onPressed: (context){

        // }
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/icon/search.svg',
          height: 18,
          width: 18,
          color: HexColor(primaryColor),
        ),
        title: ("Search"),
        activeColorPrimary: HexColor(primaryColor),
        inactiveColorPrimary: HexColor("#C0C0C0"),
        inactiveIcon: SvgPicture.asset(
          'assets/icon/search.svg',
          height: 18,
          width: 18,
          color: HexColor("#C0C0C0"),
        ),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/icon/crown.svg',
          height: 18,
          width: 18,
          color: HexColor(primaryColor),
        ),
        title: ("Find"),
        activeColorPrimary: HexColor(primaryColor),
        inactiveColorPrimary: HexColor("#C0C0C0"),
        inactiveIcon: SvgPicture.asset(
          'assets/icon/crown.svg',
          height: 18,
          width: 18,
          color: HexColor("#C0C0C0"),
        ),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/icon/chat.svg',
          height: 18,
          width: 18,
          color: HexColor(primaryColor),
        ),
        title: ("Chat"),
        activeColorPrimary: HexColor(primaryColor),
        inactiveColorPrimary: HexColor("#C0C0C0"),
        inactiveIcon: SvgPicture.asset(
          'assets/icon/chat.svg',
          height: 18,
          width: 18,
          color: HexColor("#C0C0C0"),
        ),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/icon/profile.svg',
          height: 26,
          width: 26,
          color: HexColor(primaryColor),
        ),
        title: ("Profile"),
        activeColorPrimary: HexColor(primaryColor),
        inactiveColorPrimary: HexColor("#C0C0C0"),
        inactiveIcon: SvgPicture.asset(
          'assets/icon/profile.svg',
          height: 26,
          width: 26,
          color: HexColor("#C0C0C0"),
        ),
      ),
    ];
  }

  Future runTask(index) async {
    TabProvider provide = Provider.of<TabProvider>(context, listen: false);
    ChatWare chat = Provider.of<ChatWare>(context, listen: false);
    // Operations.controlSystemColor();

    provide.changeIndex(index);
    ChatController.initSocket(context)
        .whenComplete(() => ChatController.addUserToSocket(context));
    // if (chat.socket != null) {
    //   ChatController.addUserToSocket(context);
    // }
    if (chat.chatPage != 0) {
      ChatController.changeChatPage(context, 0);
    }

    if (provide.index == 0) {
      provide.addtapTrack();
      if (provide.index == 0 && index == 0 && provide.tapTracker > 1) {
        await FeedPostController.reloadPage(context);

        // setState(() {});
        // setState(() {
        //   FeedHome().createState().dispose();

        //   // _children = [

        //   //   const GlobalSearch(),
        //   //   const SwipeCardScreen(),
        //   //   const ConversationScreen(),
        //   //   const ProfileScreen(),
        //   // ];
        // });

        // setState(() {
        //   FeedHome().createState().build(context);
        // });
        //  emitter("referesh");
      }

      if (provide.isTapped) {
        provide.tap(false);
      }
      provide.isHomeChange(false);
    } else {
      if (index == 4) {
        try {
          NotificationController.retrievNotificationController(context, false);
          // if (provide.controller != null) {
          //   if (provide.controller!.value.isInitialized) {
          //     if (provide.controller!.value.isBuffering ||
          //         provide.controller!.value.isPlaying) {
          //       if (mounted) {
          //       //  provide.pauseControl();
          //       //  provide.tap(true);
          //       }
          //     } else {
          //       if (mounted) {
          //       //  provide.pauseControl();
          //      //   provide.tap(true);
          //       }
          //     }
          //   }
          // }
        } catch (e) {
          emitter(e.toString());
        }
      }
      // setState(() {
      //   trackTaps = 0;
      // });
      provide.tapTrack(0);

      try {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          VideoWareHome.instance.pauseAnyVideo();
        });
        if (index == 0) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            VideoWareHome.instance.playAnyVideo();
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            VideoWareHome.instance.pauseAnyVideo();
          });
        }

        // if (provide.controller != null) {
        //   if (provide.controller!.value.isInitialized) {
        //     if (provide.controller!.value.isBuffering ||
        //         provide.controller!.value.isPlaying) {
        //       if (mounted) {
        //         provide.pauseControl();
        //         provide.tap(true);
        //       }
        //     } else {
        //       if (mounted) {
        //         provide.pauseControl();
        //         provide.tap(true);
        //       }
        //     }
        //   }
        // }
      } catch (e) {
        emitter(e.toString());
      }
      //provide.isHomeChange(true);
    }
  }

  BottomNavigationBarItem barItem(String svgPath, bool isActive,
      [bool? isChat]) {
    ChatWare streams = context.watch<ChatWare>();
    int unread = 0;

    streams.unreadMsgs.forEach((element) {
      unread += element.totalUnread!;
    });

    return BottomNavigationBarItem(
      icon: isChat == true
          ? Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  svgPath,
                  height: 26,
                  width: 26,
                  color:
                      isActive ? HexColor(primaryColor) : HexColor("#C0C0C0"),
                ),
                unread < 1
                    ? const SizedBox.shrink()
                    : Positioned(
                        right: 1,
                        top: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            //top: -2,
                            child: Container(
                              constraints:
                                  BoxConstraints(maxHeight: 10, maxWidth: 10),
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Center(
                                child: AppText(
                                  size: 8,
                                  text: "",
                                  //   text: unread > 99 ? "99+" : unread.toString(),
                                  color: HexColor(backgroundColor),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
              ],
            )
          : SvgPicture.asset(
              svgPath,
              height: 26,
              width: 26,
              color: isActive ? HexColor(primaryColor) : HexColor("#C0C0C0"),
            ),
    );
  }

  // Future reloadChat(BuildContext context) async {
  //   emitter("W have started the reload");
  //   reloadTime = Timer.periodic(const Duration(seconds: 10), (_) {
  //     //  ChatController.retrievChatController(context, false);
  //     ChatController.retreiveUnread(context);
  //   });
  // }

  @override
  void initState() {
    //UpdateApp.basicStatusCheck(context);
    super.initState();
    Get.put(GiftWare());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VideoWareHome.instance.getVideoPostFromApi(1);
      //  VideoWareHome.instance.getVideoPostFromApi(2);
      // VideoWareHome.instance.getVideoPostFromApi(3);
      //  VideoWareHome.instance.getVideoPostFromApi(4);
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      NotificationController.checkNotification(context);
    });
    Operations.checkNewlyVerified();
    // SystemChrome.setPreferredOrientations(
    //       [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    //  = PageController(initialPage:  )
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TabProvider provide = Provider.of<TabProvider>(context, listen: false);
      PageController pageController =
          PageController(initialPage: provide.index);
      provide.addPageControl(pageController);
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ChatController.retreiveUnread(context);
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SwipeWare swipe = Provider.of<SwipeWare>(context, listen: false);
      if (swipe.filterName == "Women") {
        SwipeController.retrievSwipeController(context, "female");
      } else if (swipe.filterName == "Men") {
        SwipeController.retrievSwipeController(context, "male");
      } else {
        SwipeController.retrievSwipeController(
            context, swipe.filterName.toLowerCase());
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatController.retrievChatController(context, false);
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FeedPostController.getUserPostController(context);
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });
    //   UserProfileController.retrievProfileController(context, true);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ActionController.retrievAllUserLikedController(context);
      await ActionController.retrievAllUserFollowingController(context);
      await ActionController.retrievAllUserLikedCommentsController(context);
    });

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      //  FeedPostWare post = Provider.of<FeedPostWare>(context, listen: false);
      //  // List<FeedPost> data = [];
      //   // for (var i = 0; i < post.feedPosts.length; i++) {
      //   //   data.add(post.feedPosts[i]);
      //   // }

      //   FeedPostController.downloadThumbs(
      //       post.feedPosts, context, MediaQuery.of(context).size.height);
      // emitter('caching first ${data.length} sent');
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    // if (mounted) {
    //   reloadTime.cancel();
    //   //  emitter("close reload chat");
    // }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) return;

    final isBackground = state == AppLifecycleState.paused;
    final isClosed = state == AppLifecycleState.detached;
    final isResumed = state == AppLifecycleState.resumed;
    final isInactive = state == AppLifecycleState.inactive;

    if (isBackground) {
      emitter("background");
      ModeController.handleMode("offline");
    } else if (isClosed) {
      emitter("closed");
      ModeController.handleMode("offline");
    } else if (isResumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ChatWare action = Provider.of(context, listen: false);
        if (action.socket != null) {
          ChatController.initSocket(context)
              .whenComplete(() => ChatController.addUserToSocket(context));
          // action.socket!.disconnect().connect();
        }
      });
      emitter("resumed");
      ModeController.handleMode("online");
    } else if (isInactive) {
      emitter("inactive");
      ModeController.handleMode("offline");
    }

    /* if (isBackground) {
      // service.stop();
    }
    
     else {
      // service.start();
    }*/
  }
}
