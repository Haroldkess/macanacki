import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/middleware/gender_ware.dart';
import 'package:provider/provider.dart';

import '../../presentation/widgets/debug_emitter.dart';

class GenderController {
  static Future<void> retrievGenderController(BuildContext context) async {
    genderWare ware = Provider.of<genderWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .getGenderFromApi()
        .whenComplete(() => emitter("everything from api and provider is done"));

    if (isDone) {
      ware.isLoading(false);
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, "An error occured", isError: true);
    }
  }
}
