import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/operations.dart';
import 'package:makanaki/presentation/screens/home/Feed/feed_home.dart';
import 'package:makanaki/presentation/screens/home/convo/conversation_screen.dart';
import 'package:makanaki/presentation/screens/home/profile/profile_screen.dart';
import 'package:makanaki/presentation/screens/home/search/global_search_screen.dart';
import 'package:makanaki/presentation/screens/home/subscription/subscrtiption_plan.dart';
import 'package:makanaki/presentation/screens/home/swipes/swipe_card_screen.dart';
import 'package:makanaki/presentation/uiproviders/screen/tab_provider.dart';
import 'package:makanaki/presentation/widgets/drawer.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/chat_controller.dart';
import 'package:makanaki/services/controllers/feed_post_controller.dart';
import 'package:makanaki/services/controllers/mode_controller.dart';
import 'package:makanaki/services/controllers/notification_controller.dart';
import 'package:makanaki/services/controllers/swipe_users_controller.dart';
import 'package:makanaki/services/controllers/user_profile_controller.dart';
import 'package:provider/provider.dart';

import '../../uiproviders/screen/find_people_provider.dart';
import '../../widgets/app_bar.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    TabProvider provide = Provider.of<TabProvider>(context, listen: false);
    TabProvider tabs = context.watch<TabProvider>();
    FindPeopleProvider listen = context.watch<FindPeopleProvider>();
    PageController pageController = PageController(initialPage: tabs.index);
    return WillPopScope(
      onWillPop: () async {
        // print("back button pressed");

        final shouldPop = await Operations.showWarning(context);
        return shouldPop!;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          key: key,
          drawer: DrawerSide(
            scafKey: key,
          ),
          backgroundColor: tabs.index == 4 || tabs.index == 2
              ? HexColor(backgroundColor)
              : HexColor("#F5F2F9"),
          appBar: listen.isFound && tabs.index == 0 ||
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
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              const FeedHome(),
              const GlobalSearch(),
              const SwipeCardScreen(),
              const ConversationScreen(),
              ProfileScreen(
                scafKey: key,
              ),
            ],
            onPageChanged: (index) {
              provide.changeIndex(index);
            },
          ),
          bottomNavigationBar: CupertinoTabBar(
            currentIndex: context.watch<TabProvider>().index,
            onTap: (index) async {
              provide.changeIndex(index);
              if (provide.index == 1) {
                //    PageRouting.pushToPage(context, const SubscriptionPlans());
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.easeIn,
                );
              } else {
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 1),
                  curve: Curves.easeIn,
                );
              }
            },
            items: [
              barItem('assets/icon/home.svg', tabs.index == 0 ? true : false),
              barItem('assets/icon/search.svg', tabs.index == 1 ? true : false),
              barItem('assets/icon/crown.svg', tabs.index == 2 ? true : false),
              barItem('assets/icon/chat.svg', tabs.index == 3 ? true : false),
              barItem(
                  'assets/icon/profile.svg', tabs.index == 4 ? true : false),
            ],
            activeColor: HexColor(primaryColor),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem barItem(String svgPath, bool isActive) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        svgPath,
        height: 26,
        width: 26,
        color: isActive ? HexColor(primaryColor) : HexColor("#C0C0C0"),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //  = PageController(initialPage:  )
    WidgetsBinding.instance.addObserver(this);
    ModeController.handleMode("online");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ModeController.handleMode("online");
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SwipeController.retrievSwipeController(context);
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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
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
      print("background");
      ModeController.handleMode("offline");
    } else if (isClosed) {
      print("closed");
      ModeController.handleMode("offline");
    } else if (isResumed) {
      print("resumed");
      ModeController.handleMode("online");
    } else if (isInactive) {
      print("inactive");
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
