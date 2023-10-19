import 'package:flutter/services.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseExt{
  static const _apiKey = 'goog_CXwwRTJGIchlAIIDEuzthsnfFCp';
//IOS - appl_jAdAfQSdPhYmPoxZAVAxkdrotqe
  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_apiKey);
  }
  static Future<List<Offering>> fetchOffers() async{
   try{
     final offerings = await Purchases.getOfferings();
     final current = offerings.current;
     return current  == null ? [] : [current];
   } on PlatformException catch (e){
     return [];
   }
  }
}