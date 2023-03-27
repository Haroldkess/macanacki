import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

import '../middleware/action_ware.dart';

class UserProfileController {
  static Future<void> retrievProfileController(
      BuildContext context, bool isFirstLoad) async {
    UserProfileWare ware = Provider.of<UserProfileWare>(context, listen: false);
    //    ActionWare action =  Provider.of<ActionWare>(context, listen: false);


    if (isFirstLoad == false) {
      ware.isLoading(true);
      log("true");
    }

    bool isDone = await ware
        .getUserProfileFromApi()
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      //        await Future.forEach(ware.publicUserProfileModel., (element) async {
      //   await action.addFollowId(element.id!);
      // }); 
      if (isFirstLoad == false) {
        ware.isLoading(false);
      }
    } else {
      if (isFirstLoad == false) {
        ware.isLoading(false);
      }

      // ignore: use_build_context_synchronously
      showToast(context, "An error occured", Colors.red);
    }
  }

  static Future<void> retrievPublicProfileController(
      BuildContext context, String username) async {
    UserProfileWare ware = Provider.of<UserProfileWare>(context, listen: false);
    ware.resetPublicUser();

    ware.isLoading2(true);
    log("true");

    bool isDone = await ware
        .getPublicUserProfileFromApi(username)
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading2(false);
    } else {
      ware.isLoading2(false);

      // ignore: use_build_context_synchronously
      showToast(context, "An error occured", Colors.red);
    }
  }
}
