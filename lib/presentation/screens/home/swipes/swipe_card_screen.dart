import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/screens/home/Feed/scanning.dart';
import 'package:makanaki/presentation/screens/home/swipes/swipeextra/tinder_card.dart';
import 'package:makanaki/presentation/uiproviders/screen/card_provider.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/middleware/notification_ware..dart';
import 'package:makanaki/services/middleware/swipe_ware.dart';
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
      SwipeController.retrievSwipeController(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    SwipeWare stream = Provider.of<SwipeWare>(context, listen: false);
    SwipeWare swipe = context.watch<SwipeWare>();
    NotificationWare notify = context.watch<NotificationWare>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor(backgroundColor),
          elevation: 0,
          actions: [],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // myIcon("assets/icon/makanakiicon.svg", primaryColor, 16.52,
              //     70, false),
              InkWell(
                onTap: () =>
                    PageRouting.pushToPage(context, const NotificationScreen()),
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      "assets/icon/notification.svg",
                    ),
                    Positioned(
                      right: 0,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 15,
                          width: 20,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Center(
                              child: AppText(
                                text: notify.notifyData.length > 9
                                    ? "9+"
                                    : notify.notifyData.length.toString(),
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
        ),
        body: swipe.loadStatus
            ? const Center(child: ScanningPerimeter())
            : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: buildCards(stream.swipedUser),
              ));
  }

  Widget buildCards(List<SwipedUser> data) {
    return Stack(children: [TinderCard(users: data)]);
  }
}
