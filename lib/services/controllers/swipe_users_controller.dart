import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/middleware/gender_ware.dart';
import 'package:makanaki/services/middleware/swipe_ware.dart';
import 'package:provider/provider.dart';

class SwipeController {
  static Future<void> retrievSwipeController(BuildContext context, String type) async {
    SwipeWare ware = Provider.of<SwipeWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .getSwipeFromApi(type)
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      await Future.delayed(const Duration(seconds: 3));
      ware.isLoading(false);
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, "An error occured", isError: true);
    }
     ware.isLoading(false);
  }
}
