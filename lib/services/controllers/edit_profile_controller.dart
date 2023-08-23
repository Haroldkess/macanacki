import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macanacki/model/create_post_model.dart';
import 'package:macanacki/services/controllers/user_profile_controller.dart';
import 'package:macanacki/services/middleware/edit_profile_ware.dart';
import 'package:macanacki/services/middleware/facial_ware.dart';
import 'package:provider/provider.dart';

import '../../presentation/widgets/debug_emitter.dart';
import '../../presentation/widgets/snack_msg.dart';
import '../middleware/user_profile_ware.dart';

class EditProfileController {
  static Future<EditProfileModel> regData(
      BuildContext context, String description, String phone, [String? country, state, city]) async {
    EditProfileWare pic = Provider.of<EditProfileWare>(context, listen: false);
    FacialWare img = Provider.of<FacialWare>(context, listen: false);
     UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);

    EditProfileModel data = EditProfileModel(
      description: description,
      phone: phone,
      media: img.addedDp == null ? "" : img.addedDp!.path,
      country: country ?? user.userProfileModel.country ,
      state:  state ?? user.userProfileModel.state,
      city: city ?? user.userProfileModel.city ,
    );
    return data;
  }

  static Future<void> editProfileController(
    BuildContext context,
    String description,
    String phone,
    [String? country, state, city]
  ) async {
    EditProfileWare ware = Provider.of<EditProfileWare>(context, listen: false);

    EditProfileModel data = await regData(context, description, phone,country,state,city);
    ware.isLoading(true);

    bool isDone = await ware
        .editProfileFromApi(data)
        .whenComplete(() => emitter("api function done"));

    // ignore: use_build_context_synchronously

    if (isDone) {
      // ignore: use_build_context_synchronously
      await UserProfileController.retrievProfileController(context, false);
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message, isError: false);
    } else {
      ware.isLoading(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message, isError: true);
      //print("something went wrong");
    }
  }
}
