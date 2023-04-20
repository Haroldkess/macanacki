import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:makanaki/services/middleware/plan_ware.dart';
import 'package:provider/provider.dart';

import '../../presentation/allNavigation.dart';
import '../../presentation/screens/home/subscription/subscrtiption_plan.dart';
import '../../presentation/widgets/snack_msg.dart';

class PlanController {
  static Future<void> retrievPlanController(BuildContext context) async {
    PlanWare ware = Provider.of<PlanWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .getPlansFromApi()
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      PageRouting.pushToPage(context, const SubscriptionPlans());
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message, isError: true);
    }
  }

  
}
