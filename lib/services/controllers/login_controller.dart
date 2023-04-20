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
import 'package:makanaki/services/controllers/mode_controller.dart';
import 'package:makanaki/services/controllers/user_profile_controller.dart';
import 'package:makanaki/services/middleware/login_ware.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:makanaki/services/temps/temps_id.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // ignore: use_build_context_synchronously
    LoginWare ware = Provider.of<LoginWare>(context, listen: false);
    // ignore: use_build_context_synchronously
    Temp temp = Provider.of<Temp>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .loginUserFromApi(data)
        .whenComplete(() => log("can now navigate to home"));

    if (isDone) {
      ware.isLoading(false);
      await temp.addEmailTemp(email);
      await temp.addPasswordTemp(password);
      await temp.addIsLoggedInTemp(true);
      // ignore: use_build_context_synchronously
      await runTask(
        context,
      );
      // ignore: use_build_context_synchronously
      await UserProfileController.retrievProfileController(context, true);
      log("removing all previous screens");
      await ModeController.handleMode("online");
      // ignore: use_build_context_synchronously
      PageRouting.removeAllToPage(context, const TabScreen());
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message, isError: true);
      if (isSplash) {
        // ignore: use_build_context_synchronously
        PageRouting.pushToPage(context, const LoginScreen());
      }
    }
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
      print("access granted");
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
      print("user granteed provitional access");
    } else {
      print("user denied access");
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
    log("the token is $token");
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString(deviceTokenKey, token);
  }

  static Future _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }
}
