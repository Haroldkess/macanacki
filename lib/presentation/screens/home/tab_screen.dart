// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/home/Feed/feed_home.dart';
import 'package:macanacki/presentation/screens/home/convo/conversation_screen.dart';
import 'package:macanacki/presentation/screens/home/profile/profile_screen.dart';
import 'package:macanacki/presentation/screens/home/search/global_search_screen.dart';
import 'package:macanacki/presentation/screens/home/subscription/subscrtiption_plan.dart';
import 'package:macanacki/presentation/screens/home/swipes/swipe_card_screen.dart';
import 'package:macanacki/presentation/uiproviders/screen/tab_provider.dart';
import 'package:macanacki/presentation/widgets/drawer.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/chat_controller.dart';
import 'package:macanacki/services/controllers/feed_post_controller.dart';
import 'package:macanacki/services/controllers/mode_controller.dart';
import 'package:macanacki/services/controllers/notification_controller.dart';
import 'package:macanacki/services/controllers/swipe_users_controller.dart';
import 'package:macanacki/services/controllers/user_profile_controller.dart';
import 'package:provider/provider.dart';

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
  final SystemUiOverlayStyle _currentStyle = SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: HexColor(backgroundColor));
  // late Timer reloadTime;
  final AsyncMemoizer _memoizerUser = AsyncMemoizer();
  final AsyncMemoizer _memoizer2 = AsyncMemoizer();
  final AsyncMemoizer _memoizerChat = AsyncMemoizer();

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

    return WillPopScope(
      onWillPop: () async {
        // print("back button pressed");

        final shouldPop = await Operations.showWarning(context);
        return shouldPop!;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: _currentStyle,
        child: Container(
          color: Color.fromARGB(255, 12, 4, 4),
          child: SafeArea(
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
                      child: StreamBuilder(
                          stream: streamSocket.getResponse,
                          builder: (con, AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.hasData) {
                                if (snapshot.data != null) {
                                  if (mounted) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                            (timeStamp) async {
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
                            return PageView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: tabs.pageController,
                              children: _children,
                              onPageChanged: (index) {
                                provide.changeIndex(index);
                              },
                            );
                          }),
                    );
                  }),
              bottomNavigationBar: CupertinoTabBar(
                currentIndex: context.watch<TabProvider>().index,
                onTap: (index) async {
                  provide.changeIndex(index);
                  ChatController.initSocket(context).whenComplete(
                      () => ChatController.addUserToSocket(context));
                  // if (chat.socket != null) {
                  //   ChatController.addUserToSocket(context);
                  // }
                  if (chat.chatPage != 0) {
                    ChatController.changeChatPage(context, 0);
                  }

                  if (provide.index == 0) {
                    tabs.pageController!.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 1),
                      curve: Curves.easeIn,
                    );
                    if (provide.isTapped) {
                      provide.tap(false);
                    }
                    provide.isHomeChange(false);
                  } else {
                    tabs.pageController!.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 1),
                      curve: Curves.easeIn,
                    );
                    //provide.isHomeChange(true);

                    try {
                      if (provide.controller != null) {
                        if (provide.controller!.value.isInitialized) {
                          if (provide.controller!.value.isBuffering ||
                              provide.controller!.value.isPlaying) {
                            provide.pauseControl();
                            provide.tap(true);
                          } else {
                            provide.pauseControl();
                            provide.tap(true);
                          }
                        }
                      }
                    } catch (e) {
                      emitter(e.toString());
                    }
                  }
                },
                items: [
                  barItem(
                      'assets/icon/home.svg', tabs.index == 0 ? true : false),
                  barItem(
                      'assets/icon/search.svg', tabs.index == 1 ? true : false),
                  barItem(
                      'assets/icon/crown.svg', tabs.index == 2 ? true : false),
                  barItem('assets/icon/chat.svg',
                      tabs.index == 3 ? true : false, true),
                  barItem('assets/icon/profile.svg',
                      tabs.index == 4 ? true : false),
                ],
                activeColor: HexColor(primaryColor),
                backgroundColor: HexColor(backgroundColor),
              ),
            ),
          ),
        ),
      ),
    );
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            //top: -2,
                            child: Container(
                              constraints:
                                  BoxConstraints(maxHeight: 19, maxWidth: 25),
                              decoration: const BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: Center(
                                child: AppText(
                                  size: 8,
                                  text: unread > 99 ? "99+" : unread.toString(),
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
    super.initState();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatController.retreiveUnread(context);
    });

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FeedPostController.getUserPostController(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationController.retrievNotificationController(context);
    });
    UserProfileController.retrievProfileController(context, true);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ActionController.retrievAllUserLikedController(context);
      await ActionController.retrievAllUserFollowingController(context);
      await ActionController.retrievAllUserLikedCommentsController(context);
    });

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FeedPostWare post = Provider.of<FeedPostWare>(context, listen: false);
      List<FeedPost> data = [];
      for (var i = 0; i < 5; i++) {
        data.add(post.feedPosts[i]);
      }

      FeedPostController.downloadThumbs(
          data, context, MediaQuery.of(context).size.height);
      emitter('caching first ${data.length} sent');
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
