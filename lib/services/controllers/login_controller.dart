// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/model/reg_email_model.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/tab_screen.dart';
import 'package:makanaki/presentation/screens/onboarding/login_screen.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/action_controller.dart';
import 'package:makanaki/services/controllers/chat_controller.dart';
import 'package:makanaki/services/controllers/feed_post_controller.dart';
import 'package:makanaki/services/controllers/mode_controller.dart';
import 'package:makanaki/services/controllers/plan_controller.dart';
import 'package:makanaki/services/controllers/user_profile_controller.dart';
import 'package:makanaki/services/controllers/verify_controller.dart';
import 'package:makanaki/services/middleware/login_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/screens/onboarding/business/sub_plan.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../middleware/user_profile_ware.dart';

class LoginController {
  static Future<void> loginUserController(BuildContext context, String email,
      String password, bool isSplash) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    await requestPermission();
    // String? _token = await FirebaseMessaging.instance.getToken();
    //  log(_token.toString());
    /// print(pref.getString(deviceTokenKey));
    SendLoginModel data = SendLoginModel(
      userName: email,
      password: password,
      token: pref.containsKey(deviceTokenKey)
          ? pref.getString(deviceTokenKey)
          : '',
      longitude: pref.getDouble(longitudeKey).toString(),
      latitude: pref.getDouble(latitudeKey).toString(),
    );

    LoginWare ware = Provider.of<LoginWare>(context, listen: false);

    Temp temp = Provider.of<Temp>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .loginUserFromApi(data)
        .whenComplete(() => log("can now navigate to home"));
    if (isSplash != true) {
      await VerifyController.business(context);
    }

    if (isDone) {
      emitter("Done with Login");
      await temp.addEmailTemp(email);
      await temp.addPasswordTemp(password);
      await temp.addIsLoggedInTemp(true);

      await UserProfileController.retrievProfileController(context, true);
      ModeController.handleMode("online");

      await runTask(
        context,
      );
      UserProfileWare user =
          Provider.of<UserProfileWare>(context, listen: false);

      if (user.userProfileModel.gender == "Business" &&
          user.userProfileModel.activePlan == "inactive subscription") {
        callFeedPost(context);
        await PlanController.retrievPlanController(context, true);
        PageRouting.pushToPage(context, const SubscriptionPlansBusiness());
      } else {
        await callFeedPost(context);
        emitter("removing all previous screens");
        PageRouting.removeAllToPage(context, const TabScreen());
      }
      ware.isLoading(false);
    } else {
      ware.isLoading(false);
      showToast2(context, ware.message, isError: true);
      if (isSplash) {
        PageRouting.pushToPage(context, const LoginScreen());
      }
    }
    ware.isLoading(false);
  }

  static Future callFeedPost(BuildContext context) async {
    await FeedPostController.getFeedPostController(context, 1, false);
    ChatController.retrievChatController(context, false);
    // ActionController.retrievAllUserFollowingController(context);
    // ActionController.retrievAllUserLikedCommentsController(context);
  }

  static Future requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      emitter("access granted");
      await getToken();
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
        // For displaying the notification as an overlay
        if (message == null) return;
        if (message.notification == null) return;
        if (message.notification != null) {
          if (message.notification!.title != null &&
              message.notification!.body != null) {
            showSimpleNotification(
              AppText(
                  text: message.notification!.body!,
                  color: HexColor(primaryColor),
                  fontWeight: FontWeight.bold,
                  size: 12),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              // ignore: deprecated_member_use
              slideDismiss: true,
              subtitle: AppText(
                text: "",
                color: HexColor(primaryColor),
              ),
              elevation: 10,
              background: Colors.white,
              duration: const Duration(seconds: 5),
            );

            // showToast2(context,
            //     "${message.notification!.title} \n\n${message.notification!.body!}",
            //     isError: false);
          }
        }
      });
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      emitter("user granteed provitional access");
    } else {
      emitter("user denied access");
    }
  }

  static Future<String> getToken() async {
    late String _token;

    try {
      await FirebaseMessaging.instance.getToken().then((token) async {
        _token = token!;
        await saveToken(token);
      });
    } catch (e) {
      _token = "";
    }

    return _token;
  }

  static Future saveToken(String token) async {
    emitter("the token is $token");
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString(deviceTokenKey, token);
  }

  static Future _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    emitter("Handling a background message: ${message.messageId}");
  }
}
