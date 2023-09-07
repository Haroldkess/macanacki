import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/screens/onboarding/business/sub_plan.dart';
import 'package:macanacki/presentation/widgets/dialogue.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/middleware/ads_ware.dart';
import 'package:macanacki/services/middleware/category_ware.dart';
import 'package:macanacki/services/middleware/gender_ware.dart';
import 'package:provider/provider.dart';

import '../../model/ads_price_model.dart';
import '../../model/plan_model.dart';
import '../../presentation/widgets/debug_emitter.dart';

class AdsController {
  static Future<void> retrievAdsController(BuildContext context) async {
    AdsWare ware = Provider.of<AdsWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware.getAdsFromApi().whenComplete(
        () => emitter("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading(false);
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, "Cannot process. please try again", isError: true);
    }
    ware.isLoading(false);
  }

  static Future<void> sendAdRequeest(
      BuildContext context, SendAdModel data) async {
    AdsWare ware = Provider.of<AdsWare>(context, listen: false);
    final PlanData finalPay = PlanData(
      amountInNaira: double.tryParse(ware.selected.price.toString()),
    );

    ware.isLoading2(true);

    bool isDone = await ware.sendAdsFromApi(data).whenComplete(
        () => emitter("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading2(false);
      // ignore: use_build_context_synchronously
      payModal(context, finalPay, null, true, data.postId);
     
      //   ware.clear();
      // ignore: use_build_context_synchronously
      //   PageRouting.popToPage(context);

    } else {
      ware.isLoading2(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message2, isError: true);
    }
    ware.isLoading2(false);
  }
}
