// import 'package:geolocator/geolocator.dart';
// import 'package:macanacki/main.dart';
// import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/operations.dart';
//import 'dart:io' show Platform;
import 'dart:async';
//import 'package:macanacki/presentation/screens/onboarding/first_screen.dart';
import 'package:macanacki/presentation/screens/onboarding/login_screen.dart';
// import 'package:macanacki/presentation/screens/onboarding/splash_screen.dart';
// import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:location/location.dart' hide LocationAccuracy;
// import 'package:app_settings/app_settings.dart';




class LocationController {
  // static Future checkDeviceLocation(context) async {
  //   Location location = Location();
  //   bool ison = await location.serviceEnabled();
  //   if (ison == false) {
  //     //  showToast2(context, "App requires location to function");
  //     await AppSettings.openLocationSettings();
  //     bool isFinished = await getAndSaveLatLong(context);
  //     if (isFinished) {
  //       Operations.delayScreen(context, const FirstScreen());
  //     } else {
  //       PageRouting.removePreviousToPage(context, const Splash());
  //     }

  //     //if defvice is off
  //     // bool isturnedon = await location.requestService();
  //     // if (isturnedon) {
  //     //   //   await getAndSaveLatLong(context);
  //     //   print("GPS device is turned ON");
  //     // } else {
  //     //   // AppSettings.openLocationSettings();
  //     //   // PageRouting.removePreviousToPage(context, const Splash());
  //     //   print("GPS Device is still OFF");
  //     // }
  //   } else {
  //     bool isFinished = await getAndSaveLatLong(context);
  //     if (isFinished) {
  //       Operations.delayScreen(context, const FirstScreen());
  //     } else {
  //       PageRouting.removePreviousToPage(context, const Splash());
  //     }
  //     //print(" enableded ooo");
  //   }
  // }

  static Future<void> sendPage(context) async {
    Restart.restartApp();
    // PageRouting.removePreviousToPage(context, const Splash());
  }

  static Future<void> getAndSaveLatLong(context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setDouble(latitudeKey, 0.0);
    await pref.setDouble(longitudeKey, 0.0);
    Operations.delayScreen(context, const LoginScreen());

    //   Position? currentPosition = await determinePosition(context);
    //   late bool isDone;

    // if (currentPosition == null) {
    //   showToast2(context, "Location service is needed for app to work",
    //       isError: true);
    //   await Future.delayed(const Duration(seconds: 3));

    //   //   isDone = false;
    //   await AppSettings.openLocationSettings();
    //   await Future.delayed(const Duration(seconds: 19));
    //   sendPage(context);

    //   // PageRouting.removePreviousToPage(context, const Splash());
    // } else {
    //   emitter(currentPosition.latitude.toString());
    //   emitter(currentPosition.longitude.toString());

    //   await pref.setDouble(latitudeKey, currentPosition.latitude);
    //   await pref.setDouble(longitudeKey, currentPosition.longitude);
    //   //isDone = true;
    //   Operations.delayScreen(context, const LoginScreen());
    // }

    // return isDone;
  }

  // static Future<Position?> determinePosition(context) async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     //  getAndSaveLatLong(context);
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     //  Future.error('Location services are disabled.');
  //     return null;
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return null;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     // Future.error(
  //     //     'Location permissions are permanently denied, we cannot request permissions.');
  //     return null;
  //   }

  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.low);
  // }

}
