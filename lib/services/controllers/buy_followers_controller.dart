import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/widgets/debug_emitter.dart';
import '../middleware/user_profile_ware.dart';

class BuyFollowersController {
  static Future<void> buyFollowers(BuildContext context, diamondValue) async {
    UserProfileWare ware = Provider.of<UserProfileWare>(context, listen: false);

    ware.loadPromomte(true);
    emitter(diamondValue);

    bool isDone = await ware
        .buyFollowersFromApi(context, diamondValue)
        .whenComplete(() => emitter("but api call attempt done "));

    if (isDone) {
      ware.loadPromomte(false);
    } else {
      ware.loadPromomte(false);
      // ignore: use_build_context_synchronously
      //showToast(context, "something went wrong. pls try again", Colors.red);
      //print("something went wrong");
    }
    ware.loadPromomte(false);
  }
}
