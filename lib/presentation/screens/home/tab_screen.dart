import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/Feed/feed_home.dart';
import 'package:makanaki/presentation/screens/home/convo/conversation_screen.dart';
import 'package:makanaki/presentation/screens/home/profile/profile_screen.dart';
import 'package:makanaki/presentation/screens/home/search/global_search_screen.dart';
import 'package:makanaki/presentation/screens/home/subscription/subscrtiption_plan.dart';
import 'package:makanaki/presentation/screens/home/swipes/swipe_card_screen.dart';
import 'package:makanaki/presentation/uiproviders/screen/tab_provider.dart';
import 'package:makanaki/presentation/widgets/text.dart';
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

class _TabScreenState extends State<TabScreen> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    TabProvider provide = Provider.of<TabProvider>(context, listen: false);
    TabProvider tabs = context.watch<TabProvider>();
    FindPeopleProvider listen = context.watch<FindPeopleProvider>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: tabs.index == 4 || tabs.index == 2
            ? HexColor(backgroundColor)
            : HexColor("#F5F2F9"),
        appBar: listen.isFound && tabs.index == 0 ||
                tabs.index == 3 ||
                tabs.index == 4 ||
                tabs.index == 1
            ? null
            : AppHeader(
                color: tabs.index == 4
                    ? HexColor(backgroundColor)
                    : Colors.transparent,
              ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: const [
            FeedHome(),
            GlobalSearch(),
            SwipeCardScreen(),
            ConversationScreen(),
            ProfileScreen(),
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
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeIn,
              );
            } else {
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 10),
                curve: Curves.easeIn,
              );
            }
          },
          items: [
            barItem('assets/icon/home.svg', tabs.index == 0 ? true : false),
            barItem('assets/icon/search.svg', tabs.index == 1 ? true : false),
            barItem('assets/icon/crown.svg', tabs.index == 2 ? true : false),
            barItem('assets/icon/chat.svg', tabs.index == 3 ? true : false),
            barItem('assets/icon/profile.svg', tabs.index == 4 ? true : false),
          ],
          activeColor: HexColor(primaryColor),
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
      SwipeController.retrievSwipeController(context);
    });
    UserProfileController.retrievProfileController(context, true);
  }
}
