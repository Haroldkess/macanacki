import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macanacki/config/pay_config.dart';
import 'package:macanacki/config/pay_constant.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayExt{
  static Future<void> configureSDK() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);


    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
    PurchasesConfiguration configuration;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String username = pref.getString(userNameKey) ?? "";
    if(username != "") {
      configuration = PurchasesConfiguration(PayConfig.instance.apiKey)
        ..appUserID = username
        ..observerMode = false;
    }else{
      configuration = PurchasesConfiguration(PayConfig.instance.apiKey)
        ..observerMode = false;
    }

    await Purchases.configure(configuration);

    debugPrint("-------------------------------------- SDK Configured----------");
  }


  static void initializeStore(){
    if (Platform.isIOS || Platform.isMacOS) {
      PayConfig(
        store: Store.appStore,
        apiKey: appleApiKey,
      );
    } else if (Platform.isAndroid) {
      PayConfig(
        store: Store.playStore,
        apiKey: googleApiKey,
      );
    }

    debugPrint("-------------------------------------- STORE Initialized----------");
  }


  static void loginUser() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String username = pref.getString(userNameKey) ?? "";
      if(username != "") {
        await Purchases.logIn(username);
      }
      debugPrint("-------------------------------------- LOGIN Successful ----------");
      //appData.appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      debugPrint("display error  ---------- ${e.message.toString()}");
    }
  }


  static void logoutUser() async {
    try {
      await Purchases.logOut();

      debugPrint("-------------------------------------- INAPP Logout----------");
      //appData.appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
       // debugPrint("display error");
    }
  }


  static void restoreUser(String newAppUserID) async {
    try {
      await Purchases.restorePurchases();
      //appData.appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      // debugPrint("display error");
    }
  }

  static Future<List<Offering>> fetchDiamondOfferings() async {
    Offerings offerings = await Purchases.getOfferings();
    return offerings.all.values.where((element) => element.identifier.contains('diamond')).toList();
  }

  static Future<List<Package>> fetchPackagesFromOfferings({ required String identifier }) async {
    Offerings offerings = await Purchases.getOfferings();
    List<Offering> extractedOfferings = offerings.all.values.where((element) => element.identifier.contains(identifier)).toList();
    List<Package> result = [];
    for (final x in extractedOfferings){
      result.addAll(x.availablePackages);
    }
    return result;
  }



}