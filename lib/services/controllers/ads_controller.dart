import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/screens/onboarding/business/sub_plan.dart';
import 'package:macanacki/presentation/widgets/dialogue.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/middleware/ads_ware.dart';
import 'package:macanacki/services/middleware/category_ware.dart';
import 'package:macanacki/services/middleware/gender_ware.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

import '../../config/pay_ext.dart';
import '../../config/pay_wall.dart';
import '../../model/ads_price_model.dart';
import '../../model/plan_model.dart';
import '../../presentation/constants/colors.dart';
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

    ware.isLoading2(true);

    print(" ----- Inside SendAdRequest");
    bool isDone = await ware.sendAdsFromApi(data).whenComplete(
        () => emitter("everything from api and provider is done"));

    print(" ----- Outside SendAdRequest");

    if (isDone) {
      ware.isLoading2(false);
      // ignore: use_build_context_synchronously
      List<Package> verificationPackages = await PayExt.fetchPackagesFromOfferings(identifier: 'promotion');
      print(verificationPackages.length);
      if(!context.mounted) return;
      await showModalBottomSheet(
        useRootNavigator: true,
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.brown,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return FractionallySizedBox(
                  heightFactor: 0.95,
                  child: Paywall(
                    isOneTimePurchase: true,
                    showTermsOfUseAndPrivacyPolicy: true,
                    title: "Promotion Packages",
                    description: "Unlock the full promotion experience",
                    packages: verificationPackages,
                    onError: (String e){
                      showToast2(context, "Payment not verified try again", isError: true);
                      Navigator.pop(context);

                    },
                    onSucess: (){
                      Get.back();
                      Get.dialog(
                          confirmationDialog(
                              title: "Promotion Successful",
                              message: "You just promoted a post",
                              confirmText: "Okay",
                              cancelText: "Go back",
                              icon: Icons.donut_small_outlined,
                              iconColor: [HexColor(primaryColor), Colors.green],
                              onPressedCancel: () {
                                Get.back();
                              },
                              onPressed: () {
                                Get.back();
                              }));
                    },

                  ),
                );
              });
        },
      );

      //   ware.clear();
      // ignore: use_build_context_synchronously
      //   PageRouting.popToPage(context);
    } else {
      ware.isLoading2(false);
    //  payModal(context, finalPay, null, true, data.postId);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message2, isError: true);
    }
    ware.isLoading2(false);
  }
}
