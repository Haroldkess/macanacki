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
import 'package:macanacki/services/middleware/notification_ware..dart';
import 'package:macanacki/services/middleware/swipe_ware.dart';
import 'package:provider/provider.dart';

import '../../../../model/swiped_user_model.dart';
import '../../../../services/controllers/mode_controller.dart';
import '../../../../services/controllers/swipe_users_controller.dart';
import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
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
              actions: [],
              title: MenuCategory()

              //  Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     // myIcon("assets/icon/macanackiicon.svg", primaryColor, 16.52,
              //     //     70, false),
              //     // InkWell(
              //     //   onTap: () =>
              //     //       PageRouting.pushToPage(context, const NotificationScreen()),
              //     //   child: Stack(
              //     //     children: [
              //     //       SvgPicture.asset(
              //     //         "assets/icon/notification.svg",
              //     //       ),
              //     //       Positioned(
              //     //         right: 0,
              //     //         child: Align(
              //     //           alignment: Alignment.topRight,
              //     //           child: Container(
              //     //             height: 15,
              //     //             width: 20,
              //     //             decoration: const BoxDecoration(
              //     //                 shape: BoxShape.circle, color: Colors.red),
              //     //             child: Padding(
              //     //               padding: const EdgeInsets.all(2.0),
              //     //               child: Center(
              //     //                 child: AppText(
              //     //                   text: notify.notifyData.length > 9
              //     //                       ? "9+"
              //     //                       : notify.notifyData.length.toString(),
              //     //                   size: 8,
              //     //                   fontWeight: FontWeight.bold,
              //     //                 ),
              //     //               ),
              //     //             ),
              //     //           ),
              //     //         ),
              //     //       )
              //     //     ],
              //     //   ),

              //     //   // myIcon("assets/icon/notification.svg", "#828282",
              //     //   //     19.13, 17.31, true),
              //     // ),
              //   ],
              // ),

              ),
          body: SizedBox(
                height: Get.height,
      width: Get.width,
      child: swipe.loadStatus
              ? const Center(child: ScanningPerimeter())
              : Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: buildCards(stream.swipedUser),
                ),
          )
          
          ),
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
                  color: HexColor(primaryColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: AppText(
                    text: "No ${swipe.filterName} user found",
                    size: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black38,
                  ),
                )
              ],
            )
          : TinderCard(users: data)
    ]);
  }
}

List<String> cat = [
  "Verified",
  "Women",
  "Men",
  "Business",
];

class MenuCategory extends StatelessWidget {
  const MenuCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Row(
          children: [
            Row(
              children: [
                ...cat.map((e) => CategoryView(
                      name: e,
                    ))
              ],
            )
          ],
        ));
  }
}

class CategoryView extends StatelessWidget {
  final String name;
  const CategoryView({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    SwipeWare swipe = context.watch<SwipeWare>();
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          SwipeWare swipe = Provider.of<SwipeWare>(context, listen: false);
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
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          width: 85,
          decoration: BoxDecoration(
              color: swipe.filterName.toLowerCase() == name.toLowerCase()
                  ? HexColor(primaryColor)
                  : HexColor(backgroundColor),
              border: Border.all(
                color: swipe.filterName.toLowerCase() == name.toLowerCase()
                    ? HexColor(primaryColor)
                    : HexColor("#EBEBEB"),
              ),
              borderRadius: BorderRadius.circular(50)),
          child: Row(
            mainAxisAlignment:
                swipe.filterName.toLowerCase() == name.toLowerCase()
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
            children: [
              AppText(
                text: name,
                color: swipe.filterName.toLowerCase() == name.toLowerCase()
                    ? HexColor(backgroundColor)
                    : HexColor("#979797"),
                size: 12,
                fontWeight: FontWeight.w400,
              ),
              swipe.filterName.toLowerCase() == name.toLowerCase()
                  ? CircleAvatar(
                      backgroundColor: HexColor(backgroundColor),
                      radius: 7,
                      child: Icon(
                        Icons.done,
                        size: 10,
                        color: HexColor(primaryColor),
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
