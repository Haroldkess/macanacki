// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:macanacki/presentation/screens/home/test_api_video.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../model/feed_post_model.dart';
import '../../../services/controllers/action_controller.dart';
import '../../../services/controllers/login_controller.dart';
import '../../../services/middleware/chat_ware.dart';
import '../../../services/middleware/feed_post_ware.dart';
import '../../../services/middleware/friends/friends_ware.dart';
import '../../../services/middleware/post_security.dart';
import '../../../services/middleware/swipe_ware.dart';
import '../../../services/middleware/user_profile_ware.dart';
import '../../../services/temps/temps_id.dart';
import '../../uiproviders/screen/find_people_provider.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/debug_emitter.dart';
import '../../widgets/screen_loader.dart';
import 'friends/friends_screen.dart';

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
    //  const ApiVideoDemo(),

    const FriendsScreen(),
    //  const GlobalSearch(),
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness:
              Platform.isAndroid ? Brightness.dark : null,
          systemNavigationBarColor: Platform.isAndroid ? Colors.white : null,
          statusBarColor: Platform.isAndroid ? Colors.black : null,
          statusBarIconBrightness:
              Platform.isAndroid ? Brightness.light : null),
      child: UpgradeAlert(
        upgrader: Upgrader(
            durationUntilAlertAgain: Duration(minutes: 5),
            dialogStyle: Platform.isIOS
                ? UpgradeDialogStyle.cupertino
                : UpgradeDialogStyle.material,
            debugLogging: false),
        child: SafeArea(
          top: true,
          child: Scaffold(
            backgroundColor: tabs.index == 4 || tabs.index == 2
                ? HexColor(backgroundColor)
                : HexColor(backgroundColor),
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
                            ChatController.handleMessage(
                                context, snapshot.data);
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
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
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
                          return GetBuilder(
                              init: PersistentNavController(),
                              builder: (persist) {
                                return ObxValue((nav) {
                                  return PersistentTabView(
                                    context,
                                    controller:
                                        persist.persistentPagecontroller.value,
                                    items: _navBarsItems(),
                                    screens: _children,
                                    handleAndroidBackButtonPress: true,
                                    hideNavigationBarWhenKeyboardShows: true,
                                    navBarStyle: NavBarStyle.style12,
                                    confineInSafeArea: true,
                                    hideNavigationBar: nav.value,
                                    stateManagement: true,
                                    popAllScreensOnTapAnyTabs: false,
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
                              });

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
          ),
        ),
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    ChatWare streams = context.watch<ChatWare>();
    int unread = 0;

    streams.unreadMsgs.forEach((element) {
      unread += element.totalUnread!;
    });
    return [
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/icon/home.svg',
          height: 18,
          width: 18,
          color: textWhite,
        ),
        title: ("Home"),
        activeColorPrimary: textWhite,
        inactiveColorPrimary: HexColor("#C0C0C0"),
        activeColorSecondary: textWhite,
        inactiveIcon: SvgPicture.asset(
          'assets/icon/home.svg',
          height: 18,
          width: 18,
          color: HexColor("#C0C0C0"),
        ),

        // onPressed: (context){

        // }
      ),
      // PersistentBottomNavBarItem(
      //   icon: SvgPicture.asset(
      //     'assets/icon/home.svg',
      //     height: 18,
      //     width: 18,
      //     color: HexColor(primaryColor),
      //   ),
      //   title: ("Demo"),

      //   activeColorPrimary: HexColor(primaryColor),
      //   inactiveColorPrimary: HexColor("#C0C0C0"),
      //   activeColorSecondary: HexColor(primaryColor),
      //   inactiveIcon: SvgPicture.asset(
      //     'assets/icon/home.svg',
      //     height: 18,
      //     width: 18,
      //     color: HexColor("#C0C0C0"),
      //   ),

      //   // onPressed: (context){

      //   // }
      // ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          'assets/icon/search.svg',
          height: 18,
          width: 18,
          color: textWhite,
        ),
        title: ("Search"),
        activeColorPrimary: textWhite,
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
          color: textWhite,
        ),
        title: ("Find"),
        activeColorPrimary: textWhite,
        inactiveColorPrimary: HexColor("#C0C0C0"),
        inactiveIcon: SvgPicture.asset(
          'assets/icon/crown.svg',
          height: 18,
          width: 18,
          color: HexColor("#C0C0C0"),
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/icon/chat.svg',
              height: 18,
              width: 18,
              color: textWhite,
            ),
            unread < 1
                ? const SizedBox.shrink()
                : Positioned(
                    right: 1,
                    top: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 2),
                      child: Align(
                        alignment: Alignment.topCenter,
                        //top: -2,
                        child: Container(
                          constraints:
                              BoxConstraints(maxHeight: 5, maxWidth: 10),
                          decoration: BoxDecoration(
                              color: secondaryColor, shape: BoxShape.circle),
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
        ),
        title: ("Chat"),
        activeColorPrimary: textWhite,
        inactiveColorPrimary: HexColor("#C0C0C0"),
        inactiveIcon: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/icon/chat.svg',
              height: 18,
              width: 18,
              color: HexColor("#C0C0C0"),
            ),
            unread < 1
                ? const SizedBox.shrink()
                : Positioned(
                    right: 1,
                    top: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 2),
                      child: Align(
                        alignment: Alignment.topCenter,
                        //top: -2,
                        child: Container(
                          constraints:
                              BoxConstraints(maxHeight: 5, maxWidth: 10),
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
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
        ),
      ),
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset('assets/icon/profile.svg',
            height: 26, width: 26, color: textWhite),
        title: ("Profile"),
        activeColorPrimary: textWhite,
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
    FeedPostWare stream = Provider.of<FeedPostWare>(context, listen: false);
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
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        PostSecurity.instance.toggleSecure(true);
      });
      provide.addtapTrack();
      if (provide.index == 0 && index == 0 && provide.tapTracker > 4) {
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
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        PostSecurity.instance.toggleSecure(false);
      });
      if (index == 4) {
        try {
          NotificationController.retrievNotificationController(context, false);
          if (stream.profileFeedPosts.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              VideoWare.instance.getVideoPostFromApi(stream.profileFeedPosts);
            });
            emitter("ADDED TO POSTS TO LIST");
          }

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
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //   VideoWareHome.instance.pauseAnyVideo();
        // });
        // if (index == 0) {
        //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //     VideoWareHome.instance.playAnyVideo();
        //   });
        // } else {
        //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //     VideoWareHome.instance.pauseAnyVideo();
        //   });
        // }

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
  void checkTappedNotification() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      // if (pref.containsKey(isLoggedInKey)) {
      //   if (pref.getBool(isLoggedInKey) == true) {}
      // }
      // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //   emitter("run");
      //   LoginController.handleNotification(message.data);
      // });
    } catch (e) {
      emitter(e.toString());
    }
    return;
  }

  void checkTappedNotificationOnClosedApp() async {
    try {
      RemoteMessage? message =
          await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        LoginController.handleNotification(message.data);
      }
    } catch (e) {
      emitter(e.toString());
    }
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      LoginController.handleNotification(message.data);
    });
  }

  @override
  void initState() {
    //UpdateApp.basicStatusCheck(context);
    super.initState();
    Get.put(GiftWare());
    Get.put(FriendWare());
    checkTappedNotificationOnClosedApp();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VideoWareHome.instance.getVideoPostFromApi(1);
      VideoWareHome.instance.getAudioPostFromApi(1);
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
      ChatController.retrievChatController(context, false, false);
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
      // ModeController.handleMode("offline");
    } else if (isClosed) {
      emitter("closed");
      //  ModeController.handleMode("offline");
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
      checkTappedNotification();
      //  ModeController.handleMode("online");
    } else if (isInactive) {
      emitter("inactive");
      //   ModeController.handleMode("offline");
    }

    /* if (isBackground) {
      // service.stop();
    }
    
     else {
      // service.start();
    }*/
  }
}
