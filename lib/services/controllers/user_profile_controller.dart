import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/screens/onboarding/splash_screen.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../../presentation/widgets/screen_loader.dart';
import '../middleware/action_ware.dart';
import '../temps/temps_id.dart';

class UserProfileController {
  static Future<void> retrievProfileController(
      BuildContext context, bool isFirstLoad) async {
    UserProfileWare ware = Provider.of<UserProfileWare>(context, listen: false);
    //    ActionWare action =  Provider.of<ActionWare>(context, listen: false);
    // log("here4");

    if (isFirstLoad == false) {
      ware.isLoading(true);
      log("true");
    }

    bool isDone = await ware.getUserProfileFromApi(context).whenComplete(
        () => emitter("everything from api and provider is done"));

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
      if (isFirstLoad == false) {
        showToast2(context, "An error occured", isError: true);
      }
    }
    if (isFirstLoad == false) {
      ware.isLoading(false);
    }
  }

  static Future<void> retrievPublicProfileController(
      BuildContext context, String username) async {
    UserProfileWare ware = Provider.of<UserProfileWare>(context, listen: false);
    ware.resetPublicUser();

    ware.isLoading2(true);

    bool isDone = await ware.getPublicUserProfileFromApi(username).whenComplete(
        () => emitter("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading2(false);
    } else {
      ware.isLoading2(false);

      // ignore: use_build_context_synchronously
      showToast2(context, "An error occured", isError: true);
    }
    ware.isLoading2(false);
  }

  static Future deleteUserProfile(context) async {
    UserProfileWare ware = Provider.of<UserProfileWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    ware.resetPublicUser();

    ware.isDeleting(true);
    progressIndicator(context, message: "Deleting account");

    bool isDone = await ware.deleteUserFromApi().whenComplete(
        () => emitter("everything from api and provider is done"));

    if (isDone) {
      ware.isDeleting(false);
      //  PageRouting.popToPage(context);

      await pref.remove(isLoggedInKey);
      await pref.remove(tokenKey);
      await pref.remove(passwordKey);
      await pref.remove(emailKey);
      await pref.remove(dobKey);
      await pref.remove(isFirstTimeKey);
      await pref.remove(photoKey);
      await pref.remove(userNameKey);

      await pref.clear();

      // ignore: use_build_context_synchronously
      await removeProviders(context);

      // ignore: use_build_context_synchronously
      PageRouting.removeAllToPage(context, const Splash());
      if (Platform.isAndroid) {
        Restart.restartApp();
      } else {
         try {
                              Phoenix.rebirth(context);
                            } catch (e) {
                              PageRouting.removeAllToPage(
                                  context, const Splash());
                              Restart.restartApp();
                            }
      }
    } else {
      ware.isDeleting(false);
      PageRouting.popToPage(context);
      // ignore: use_build_context_synchronously
      showToast2(context, "An error occured", isError: true);
    }
    ware.isDeleting(false);
  }
}
