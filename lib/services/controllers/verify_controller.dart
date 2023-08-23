import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:macanacki/model/reg_email_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/screens/onboarding/select_gender.dart';
import 'package:macanacki/presentation/screens/verification/otp_screen.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/user_profile_controller.dart';
import 'package:macanacki/services/middleware/registeration_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/register_model.dart';
import '../../presentation/screens/onboarding/business/business_modal.dart';
import '../../presentation/screens/onboarding/dob_screen.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../middleware/user_profile_ware.dart';

class VerifyController {
  static Future<void> business(BuildContext context, [bool? onlyReg]) async {
    RegisterationWare ware =
        Provider.of<RegisterationWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    ware.isLoadingBus(true);
    RegisterBusinessModel registerBusinessModel = RegisterBusinessModel(
        name: "",
        busName: user.registerBusinessModel.busName,
        phone: user.registerBusinessModel.phone,
        email: user.registerBusinessModel.email,
        description: user.registerBusinessModel.description,
        regNo: user.registerBusinessModel.regNo,
        businessAddress: user.registerBusinessModel.businessAddress,
        country: user.registerBusinessModel.country,
        evidence: user.registerBusinessModel.evidence,
        isReg: user.registerBusinessModel.isReg,
        idType: "",
        idNumb: "",
        address: "",
        photo: null);

    bool isDone = await ware
        .verifyBusinessFromApi(registerBusinessModel)
        .whenComplete(() => emitter("verification done "));

    if (isDone) {
      UserProfileController.retrievProfileController(context, true);
      ware.isLoadingBus(false);
      // ignore: use_build_context_synchronously
      showToast2(
        context,
        ware.busMsg,
      );
      if (onlyReg == true) {
        PageRouting.popToPage(context);
      }
      pref.setBool(isVerifiedFirstKey, false);
    } else {
      ware.isLoadingBus(false);
      // ignore: use_build_context_synchronously
      showToast2(context, "something went wrong. pls try again ${ware.busMsg}",
          isError: true);

      //print("something went wrong");
    }

    ware.isLoadingBus(false);
  }

  static Future<void> userVerify(BuildContext context, [bool? onlyReg]) async {
    RegisterationWare ware =
        Provider.of<RegisterationWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    ware.isLoadingUser(true);

    bool isDone = await ware
        .verifyUserFromApi(user.verifyUserModel)
        .whenComplete(() => emitter("complete"));

    if (isDone) {
      UserProfileController.retrievProfileController(context, true);

      ware.isLoadingUser(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.IndividualMsg, isError: false);
      if (onlyReg == true) {
        PageRouting.popToPage(context);
      }
      pref.setBool(isVerifiedFirstKey, false);

      // ignore: use_build_context_synchronously
      // PageRouting.pushToPage(context, const DobScreen());
    } else {
      ware.isLoadingUser(false);
      // ignore: use_build_context_synchronously
      showToast2(context, "something went wrong. pls try again", isError: true);

      //print("something went wrong");
    }
    ware.isLoadingUser(false);
  }
}
