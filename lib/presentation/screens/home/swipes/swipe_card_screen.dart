import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/screens/home/Feed/scanning.dart';
import 'package:macanacki/presentation/screens/home/swipes/swipeextra/tinder_card.dart';
import 'package:macanacki/presentation/uiproviders/screen/card_provider.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/feed_post_controller.dart';
import 'package:macanacki/services/middleware/notification_ware..dart';
import 'package:macanacki/services/middleware/swipe_ware.dart';
import 'package:provider/provider.dart';

import '../../../../model/swiped_user_model.dart';
import '../../../../services/controllers/mode_controller.dart';
import '../../../../services/controllers/swipe_users_controller.dart';
import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../uiproviders/screen/tab_provider.dart';
import '../../notification/notification_screen.dart';

class SwipeCardScreen extends StatefulWidget {
  const SwipeCardScreen({super.key});

  @override
  State<SwipeCardScreen> createState() => _SwipeCardScreenState();
}

class _SwipeCardScreenState extends State<SwipeCardScreen> {
  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    SwipeWare stream = Provider.of<SwipeWare>(context, listen: false);
    SwipeWare swipe = context.watch<SwipeWare>();
    NotificationWare notify = context.watch<NotificationWare>();
    return SafeArea(
      child: Scaffold(
          backgroundColor: HexColor(backgroundColor),
          appBar: AppBar(
              backgroundColor: HexColor(backgroundColor),
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [],
              title: MenuCategory()),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              //  PersistentNavController.instance.toggleHide();
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                if (PersistentNavController.instance.hide.value == true) {
                  PersistentNavController.instance.toggleHide();
                }
              });
            },
            child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: swipe.loadStatus
                  ? const Center(child: ScanningPerimeter())
                  : Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: buildCards(stream.swipedUser),
                    ),
            ),
          )),
    );
  }

  Widget buildCards(List<SwipedUser> data) {
    SwipeWare swipe = context.watch<SwipeWare>();
    return Stack(children: [
      data.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_off_outlined,
                  size: 30,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: AppText(
                    text: "No ${swipe.filterName} user found",
                    size: 14,
                    fontWeight: FontWeight.w600,
                    color: textWhite,
                  ),
                )
              ],
            )
          : TinderCard(users: data)
    ]);
  }
}

class MenuCategory extends StatelessWidget {
  const MenuCategory({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> cat = [
      "Verified",
      "Women",
      "Men",
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [...cat.map((e) => CategoryView(name: e, isHome: false))],
        )
      ],
    );
  }
}

class CategoryView extends StatelessWidget {
  final String name;
  final bool? isHome;
  const CategoryView({super.key, required this.name, this.isHome});

  @override
  Widget build(BuildContext context) {
    SwipeWare swipe = context.watch<SwipeWare>();
    SwipeWare tab = context.watch<SwipeWare>();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          SwipeWare swipe = Provider.of<SwipeWare>(context, listen: false);
          TabProvider tab = Provider.of<TabProvider>(context, listen: false);
          if (isHome == true) {
            tab.changeFilter(name);
          } else {
            swipe.changeFilter(name);
            if (swipe.filterName == "Women") {
              SwipeController.retrievSwipeController(
                  context, "female", swipe.country, swipe.state, swipe.city);
            } else if (swipe.filterName == "Men") {
              SwipeController.retrievSwipeController(
                  context, "male", swipe.country, swipe.state, swipe.city);
            } else {
              SwipeController.retrievSwipeController(
                  context,
                  swipe.filterName.toLowerCase(),
                  swipe.country,
                  swipe.state,
                  swipe.city);
            }
          }
        },
        child: isHome == true
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                width: 83,
                decoration: BoxDecoration(
                    color: tab.filterName.toLowerCase() == name.toLowerCase()
                        ? backgroundSecondary
                        : HexColor(backgroundColor),
                    border: Border.all(
                      color: tab.filterName.toLowerCase() == name.toLowerCase()
                          ? textPrimary
                          : textPrimary,
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment:
                      tab.filterName.toLowerCase() == name.toLowerCase()
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                  children: [
                    tab.filterName.toLowerCase() == name.toLowerCase()
                        ? SizedBox(
                            width: 3,
                          )
                        : SizedBox.shrink(),
                    AppText(
                      text: name,
                      color: tab.filterName.toLowerCase() == name.toLowerCase()
                          ? textWhite
                          : textPrimary,
                      size: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    tab.filterName.toLowerCase() == name.toLowerCase()
                        ? CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 5,
                            child: Icon(
                              Icons.done,
                              size: 8,
                              color: Colors.white,
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                width: 85,
                decoration: BoxDecoration(
                    color: swipe.filterName.toLowerCase() == name.toLowerCase()
                        ? backgroundSecondary
                        : HexColor(backgroundColor),
                    border: Border.all(
                      color:
                          swipe.filterName.toLowerCase() == name.toLowerCase()
                              ? Colors.grey
                              : HexColor("#EBEBEB"),
                    ),
                    borderRadius: BorderRadius.circular(50)),
                child: Row(
                  mainAxisAlignment:
                      swipe.filterName.toLowerCase() == name.toLowerCase()
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                  children: [
                    swipe.filterName.toLowerCase() == name.toLowerCase()
                        ? SizedBox(
                            width: 3,
                          )
                        : SizedBox.shrink(),
                    AppText(
                      text: name,
                      color:
                          swipe.filterName.toLowerCase() == name.toLowerCase()
                              ? textPrimary
                              : HexColor("#979797"),
                      size: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    swipe.filterName.toLowerCase() == name.toLowerCase()
                        ? CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 7,
                            child: Icon(
                              Icons.done,
                              size: 10,
                              color: Colors.white,
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                ),
              ),
      ),
    );
  }
}

class CategoryViewHome extends StatefulWidget {
  final String name;
  final bool? isHome;
  TabProvider tab;
  CategoryViewHome(
      {super.key, required this.name, this.isHome, required this.tab});

  @override
  State<CategoryViewHome> createState() => _CategoryViewHomeState();
}

class _CategoryViewHomeState extends State<CategoryViewHome> {
  @override
  Widget build(BuildContext context) {
    // TabProvider tab = context.watch<TabProvider>();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        width: 83,
        decoration: BoxDecoration(
            color: widget.tab.filterNameHome.toLowerCase() ==
                    widget.name.toLowerCase()
                ? backgroundSecondary
                : HexColor(backgroundColor),
            border: Border.all(
              color: widget.tab.filterNameHome.toLowerCase() ==
                      widget.name.toLowerCase()
                  ? textPrimary
                  : textPrimary,
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisAlignment: widget.tab.filterNameHome.toLowerCase() ==
                  widget.name.toLowerCase()
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            widget.tab.filterNameHome.toLowerCase() == widget.name.toLowerCase()
                ? SizedBox(
                    width: 3,
                  )
                : SizedBox.shrink(),
            AppText(
              text: widget.name,
              color: widget.tab.filterNameHome.toLowerCase() ==
                      widget.name.toLowerCase()
                  ? textWhite
                  : textPrimary,
              size: 12,
              fontWeight: FontWeight.w400,
            ),
            widget.tab.filterNameHome.toLowerCase() == widget.name.toLowerCase()
                ? CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 5,
                    child: Icon(
                      Icons.done,
                      size: 8,
                      color: Colors.white,
                    ),
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
