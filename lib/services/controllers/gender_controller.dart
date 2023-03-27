import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/middleware/gender_ware.dart';
import 'package:provider/provider.dart';

class GenderController {
  static Future<void> retrievGenderController(BuildContext context) async {
    genderWare ware = Provider.of<genderWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .getGenderFromApi()
        .whenComplete(() => log("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading(false);
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast(context, "An error occured", Colors.red);
    }
  }
}
