import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:macanacki/services/middleware/plan_ware.dart';
import 'package:provider/provider.dart';

import '../../presentation/allNavigation.dart';
import '../../presentation/screens/home/subscription/subscrtiption_plan.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../../presentation/widgets/snack_msg.dart';

class PlanController {
  static Future<void> retrievPlanController(BuildContext context,
      [bool? isSignUp]) async {
    PlanWare ware = Provider.of<PlanWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware.getPlansFromApi().whenComplete(
        () => emitter("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading(false);
      if (isSignUp != true) {
        // ignore: use_build_context_synchronously
        PageRouting.pushToPage(context, const SubscriptionPlans());
      }
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message, isError: true);
    }
  }

  static Future<void> diamondLinkController(
      BuildContext context, String amount) async {
    PlanWare ware = Provider.of<PlanWare>(context, listen: false);

    ware.isLoadingDiamond(true);

    bool isDone = await ware.getDiamondLinkFromApi(amount).whenComplete(
        () => emitter("everything from api and provider is done"));

    // ignore: use_build_context_synchronously

    if (isDone) {
      ware.isLoadingDiamond(false);
    } else {
      ware.isLoadingDiamond(false);

      // ignore: use_build_context_synchronously
      // showToast(context, "An error occured", Colors.red);
    }

    ware.isLoadingDiamond(false);
  }

  static Future<void> verificationLinkController(BuildContext context) async {
    PlanWare ware = Provider.of<PlanWare>(context, listen: false);

    ware.isLoadingVerificatioin(true);

    bool isDone = await ware.getVerificationLinkFromApi().whenComplete(
        () => emitter("everything from api and provider is done"));

    // ignore: use_build_context_synchronously

    if (isDone) {
      ware.isLoadingVerificatioin(false);
    } else {
      ware.isLoadingVerificatioin(false);

      // ignore: use_build_context_synchronously
      // showToast(context, "An error occured", Colors.red);
    }

    ware.isLoadingVerificatioin(false);
  }

  static Future<void> promotePostLink(
      BuildContext context, postId, planId) async {
    PlanWare ware = Provider.of<PlanWare>(context, listen: false);

    ware.isLoadingPromote(true);

    bool isDone = await ware
        .getPromotePostLinkFromApi(postId, planId)
        .whenComplete(
            () => emitter("everything from api and provider is done"));

    // ignore: use_build_context_synchronously

    if (isDone) {
      ware.isLoadingPromote(false);
    } else {
      ware.isLoadingPromote(false);

      // ignore: use_build_context_synchronously
      // showToast(context, "An error occured", Colors.red);
    }

    ware.isLoadingPromote(false);
  }
}
