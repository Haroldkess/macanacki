import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/screens/home/swipes/swipeextra/tinder_card.dart';
import 'package:makanaki/presentation/uiproviders/screen/card_provider.dart';
import 'package:makanaki/services/middleware/swipe_ware.dart';
import 'package:provider/provider.dart';

import '../../../../model/swiped_user_model.dart';
import '../../../../services/controllers/swipe_users_controller.dart';
import '../../../constants/colors.dart';

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
   // SwipeWare stream = context.watch<SwipeWare>();
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: buildCards(stream.swipedUser),
    ));
  }

  Widget buildCards(List<SwipedUser> data) {
    return Stack(children: [TinderCard(users: data)]);
  }
}
