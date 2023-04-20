// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'dart:io';
// import 'package:shared_preferences/shared_preferences.dart';

// FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// Future configureRealTimePushNotifications() async {
//   SharedPreferences pref = await SharedPreferences.getInstance();

//   if (Platform.isIOS) {
//     getIosPermisions();
//   }
 
//   _firebaseMessaging.configure(onMessage: (Map<String, dynamic> msg) async {
//     final String recipientId = msg["data"]["recipient"];
//     final String body = msg["notification"]["body"];

//     // if (recipientId == widget.uidOfUser) {

     
//     // }
//   });
// }

// getIosPermisions() {
//   _firebaseMessaging.requestPermission(
//       IosNotificationSettings(alert: true, badge: true, sound: true));

//   _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
//     print("Settings Registered : $settings");
//   });
// }
