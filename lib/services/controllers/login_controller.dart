// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/config/pay_ext.dart';
import 'package:macanacki/model/reg_email_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/tab_screen.dart';
import 'package:macanacki/presentation/screens/onboarding/login_screen.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/action_controller.dart';
import 'package:macanacki/services/controllers/chat_controller.dart';
import 'package:macanacki/services/controllers/feed_post_controller.dart';
import 'package:macanacki/services/controllers/mode_controller.dart';
import 'package:macanacki/services/controllers/notification_controller.dart';
import 'package:macanacki/services/controllers/plan_controller.dart';
import 'package:macanacki/services/controllers/user_profile_controller.dart';
import 'package:macanacki/services/controllers/verify_controller.dart';
import 'package:macanacki/services/middleware/gender_ware.dart';
import 'package:macanacki/services/middleware/login_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../model/gender_model.dart';
import '../../presentation/constants/params.dart';
import '../../presentation/screens/onboarding/business/sub_plan.dart';
import '../../presentation/uiproviders/screen/tab_provider.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../middleware/user_profile_ware.dart';

class LoginController {
  static Future<void> loginUserController(
      BuildContext context, String email, String password, bool isSplash,
      [bool? isLogin]) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(readAllKey)) {
      pref.setBool(readAllKey, false);
    }
    if (!pref.containsKey(lastMsgKey)) {
      pref.setString(lastMsgKey, "");
    }
    if (!pref.containsKey(isVerifiedFirstKey)) {
      pref.setBool(isVerifiedFirstKey, false);
    }
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
    genderWare gender = Provider.of<genderWare>(context, listen: false);

    Temp temp = Provider.of<Temp>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .loginUserFromApi(data)
        .whenComplete(() => emitter("can now navigate to home"));
    // if (isSplash != true) {
    //   List<GenderList> selected = gender.genderList
    //       .where((element) => element.selected == true)
    //       .toList();
    //   if (selected.isNotEmpty) {
    //     if (selected.first.name == "Business") {
    //       await VerifyController.business(context);
    //     } else {
    //       emitter("Business not selected rather it is ${selected.first.name}");
    //     }
    //   } else {
    //     emitter("Business not selected");
    //   }
    // }

    if (isDone) {
      emitter("Done with Login");
      await temp.addEmailTemp(email);
      await temp.addPasswordTemp(password);
      await temp.addIsLoggedInTemp(true);

      await UserProfileController.retrievProfileController(context, true);
      // ModeController.handleMode("online");

      await runTask(
        context,
      );
      // UserProfileWare user =
      //     Provider.of<UserProfileWare>(context, listen: false);

      // if (user.userProfileModel.gender == "Business" &&
      //     user.userProfileModel.activePlan == "inactive subscription") {
      //   callFeedPost(context);
      //   await PlanController.retrievPlanController(context, true);
      //   PageRouting.pushToPage(context, const SubscriptionPlansBusiness());
      // } else {
      //   await callFeedPost(context);
      //   emitter("removing all previous screens");
      //   PageRouting.removeAllToPage(context, const TabScreen());
      // }

      try {
        PayExt.loginUser();
      } catch (e) {}

      await callFeedPost(context);
      emitter("removing all previous screens");
      PageRouting.removeAllToPage(context, const TabScreen());
      ware.isLoading(false);
    } else {
      ware.isLoading(false);
      showToast2(context, ware.message, isError: true);
      if (isSplash) {
        if (isLogin == true) {
        } else {
          PageRouting.pushToPage(context, const LoginScreen());
        }
      }
    }
    ware.isLoading(false);
  }

  static Future callFeedPost(BuildContext context) async {
    await FeedPostController.getFeedPostController(context, 1, false);
    await FeedPostController.getRoyaltyController(context, "king");
    //  await UserProfileController.retrievProfileController(context, true);
    ChatController.retreiveUnread(context);
    ChatController.retrievChatController(context, false, false);
    FeedPostController.getUserPostController(context);
    FeedPostController.getUserPostAudioController(context);
    //  ActionController.retrievAllUserFollowingController(context);
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
        print(message!.notification!.toMap());
        if (message == null) return;
        if (message.notification == null) return;
        if (message.notification != null) {
          if (message.notification!.title != null &&
              message.notification!.body != null) {
            showSimpleNotification(
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              url,
                            ))),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: Get.width * 0.7),
                    decoration: BoxDecoration(
                      backgroundBlendMode: BlendMode.colorDodge,
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(.0),
                            Colors.black.withOpacity(.1),
                            Colors.black.withOpacity(.4),
                            Colors.black.withOpacity(.5),
                            Colors.black.withOpacity(.6),
                          ],
                          stops: [
                            0.0,
                            0.1,
                            0.3,
                            0.8,
                            0.9
                          ]),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: AppText(
                          text: message.notification!.body!,
                          color: textWhite,
                          fontWeight: FontWeight.bold,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          size: 14),
                    ),
                  ),
                ],
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              // ignore: deprecated_member_use
              slideDismiss: true,

              elevation: 0,
              background: HexColor(backgroundColor),
              duration: const Duration(seconds: 3),
            );

            // showToast2(context,
            //     "${message.notification!.title} \n\n${message.notification!.body!}",
            //     isError: false);
          }
        }
      });
      // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //   // Handle the incoming message when the app is in the background or terminated
      //   handleNotification(message.data);
      // });
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      emitter("user granteed provitional access");
    } else {
      emitter("user denied access");
    }
  }

  static void handleNotification(Map<String, dynamic> data) {
//    log("data =>  " + data.toString());

    ///Extract custom data
    String notificationType = data['notification_type'];
    String targetPage = data['target_page'];
    //  log("Notification type =>  " + notificationType);
    // log("Target page =>  " + targetPage);

    // Navigate based on notification type
    if (notificationType == 'post') {
      // Navigate to a specific page
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        navigatorKey.currentState?.pushNamed('/post', arguments: targetPage);
      });
    } else if (notificationType == "user") {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        navigatorKey.currentState?.pushNamed('/profile', arguments: targetPage);
      });
    } else if (notificationType == "chat") {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        PersistentNavController.instance.changePersistentTabIndex();
      });
    }

    //   //  Navigator.pushNamed(context, '/$targetPage');
    //   //Get.toNamed(page, preventDuplicates: true);
    // }
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
