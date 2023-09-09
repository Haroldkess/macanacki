import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/middleware/action_ware.dart';
import 'package:macanacki/services/middleware/search_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

import '../../presentation/widgets/debug_emitter.dart';

class SearchAppController {
  static Future<void> retrievSearchUserController(
      BuildContext context, String x) async {
    SearchWare ware = Provider.of<SearchWare>(context, listen: false);
    ActionWare action = Provider.of<ActionWare>(context, listen: false);

    ware.isLoading(true);

    bool isDone = await ware
        .getSearchedUserFromApi(x)
        .whenComplete(() => emitter("everything from api and provider is done"));

    if (isDone) {
      await Future.forEach(ware.userFound, (element) async {
        if (element.followingStatus == 1) {
          action.addFollowId(element.id!);
        } else {}
      });

      ware.isLoading(false);
    } else {
      ware.clearSearch();

      ware.isLoading(false);

      // ignore: use_build_context_synchronously
      ///  showToast(context, "An error occured", Colors.red);
    }
    ware.isLoading(false);
  }
}
