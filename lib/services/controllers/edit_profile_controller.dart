import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:makanaki/model/create_post_model.dart';
import 'package:makanaki/services/controllers/user_profile_controller.dart';
import 'package:makanaki/services/middleware/edit_profile_ware.dart';
import 'package:makanaki/services/middleware/facial_ware.dart';
import 'package:provider/provider.dart';

import '../../presentation/widgets/snack_msg.dart';

class EditProfileController {
  static Future<EditProfileModel> regData(
      BuildContext context, String description, String phone) async {
    EditProfileWare pic = Provider.of<EditProfileWare>(context, listen: false);
    FacialWare img = Provider.of<FacialWare>(context, listen: false);
    print(img.addedDp);

    EditProfileModel data = EditProfileModel(
      description: description,
      phone: phone,
      media: img.addedDp == null ? "" : img.addedDp!.path,
    );
    return data;
  }

  static Future<void> editProfileController(
    BuildContext context,
    String description,
    String phone,
  ) async {
    EditProfileWare ware = Provider.of<EditProfileWare>(context, listen: false);

    EditProfileModel data = await regData(context, description, phone);
    ware.isLoading(true);

    bool isDone = await ware
        .editProfileFromApi(data)
        .whenComplete(() => log("api function done"));

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
