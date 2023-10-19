import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macanacki/config/store_config.dart';
import 'package:macanacki/config/store_constant.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class StoreExt{
  static Future<void> configureSDK() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setLogLevel(LogLevel.debug);

    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..observerMode = false;
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
        ..appUserID = null
        ..observerMode = false;
    }
    await Purchases.configure(configuration);
  }


  static void initializeStore(){
    if (Platform.isIOS || Platform.isMacOS) {
      StoreConfig(
        store: Store.appStore,
        apiKey: appleApiKey,
      );
    } else if (Platform.isAndroid) {
      StoreConfig(
        store: Store.playStore,
        apiKey: googleApiKey,
      );
    }
  }


  static void loginUser(String newAppUserID) async {
    try {
      await Purchases.logIn(newAppUserID);
      //appData.appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      // debugPrint("display error");
    }
  }


  static void logoutUser(String newAppUserID) async {
    try {
      await Purchases.logOut();
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



}