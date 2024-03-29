import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:macanacki/services/middleware/plan_ware.dart';
import 'package:provider/provider.dart';

import '../../presentation/allNavigation.dart';
import '../../presentation/screens/home/subscription/subscrtiption_plan.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../../presentation/widgets/snack_msg.dart';
import '../middleware/button_ware.dart';

class ButtonController {
  static Future<void> retrievButtonsController(BuildContext context) async {
    ButtonWare ware = Provider.of<ButtonWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .getButtonFromApi()
        .whenComplete(() => emitter("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously

    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message, isError: true);
    }
  }
}
