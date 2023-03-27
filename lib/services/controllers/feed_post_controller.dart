import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:makanaki/presentation/widgets/float_toast.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/controllers/user_profile_controller.dart';
import 'package:makanaki/services/middleware/action_ware.dart';
import 'package:provider/provider.dart';

import '../middleware/feed_post_ware.dart';

class FeedPostController {
  static Future<void> getFeedPostController(BuildContext context) async {
    FeedPostWare ware = Provider.of<FeedPostWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .getFeedPostFromApi()
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading(false);
      log("feed post stored");
    } else {
      ware.isLoading(false);
      floatToast("Can't get your feed",Colors.red.shade300);

      // ignore: use_build_context_synchronously
      // showToast(context, "An error occured", Colors.red);
    }
  }

  static Future<void> getUserPostController(BuildContext context) async {
    FeedPostWare ware = Provider.of<FeedPostWare>(context, listen: false);

    ware.isLoading2(true);

    bool isDone = await ware
        .getUserPostFromApi()
        .whenComplete(() => log("everything from api and provider is done"));
    // ignore: use_build_context_synchronously
    await UserProfileController.retrievProfileController(context, false);

    if (isDone) {
  
      ware.isLoading2(false);
    } else {
      ware.isLoading2(false);

      floatToast("Can't get your posts",Colors.red.shade300);

      // ignore: use_build_context_synchronously

    }
  }
}
