import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macanacki/model/reg_email_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/screens/onboarding/select_gender.dart';
import 'package:macanacki/presentation/screens/verification/otp_screen.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/middleware/registeration_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/register_model.dart';
import '../../presentation/screens/onboarding/business/business_modal.dart';
import '../../presentation/screens/onboarding/dob_screen.dart';
import '../middleware/user_profile_ware.dart';

class VerifyController {
  static Future<void> business(BuildContext context) async {
    RegisterationWare ware =
        Provider.of<RegisterationWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    ware.isLoadingBus(true);
    RegisterBusinessModel registerBusinessModel = RegisterBusinessModel(
        name: user.verifyUserModel.name,
        busName: user.registerBusinessModel.busName,
        phone: user.registerBusinessModel.phone,
        email: user.registerBusinessModel.email,
        description: user.registerBusinessModel.description,
        regNo: user.registerBusinessModel.regNo,
        businessAddress: user.registerBusinessModel.businessAddress,
        country: user.registerBusinessModel.country,
        evidence: user.registerBusinessModel.evidence,
        isReg: user.registerBusinessModel.isReg,
        idType: user.verifyUserModel.idType,
        idNumb: user.verifyUserModel.idNumb,
        address: user.verifyUserModel.address,
        photo: user.verifyUserModel.photo);

    bool isDone = await ware
        .verifyBusinessFromApi(registerBusinessModel)
        .whenComplete(() => log("verification done "));

    if (isDone) {
      ware.isLoadingBus(false);
      // ignore: use_build_context_synchronously
      showToast2(
        context,
        "Successful. Verification in progress. You will get a notification once your document is verified",
      );
    } else {
      ware.isLoadingBus(false);
      // ignore: use_build_context_synchronously
      showToast2(context, "something went wrong. pls try again", isError: true);

      //print("something went wrong");
    }

    ware.isLoadingBus(false);
  }

  static Future<void> userVerify(
    BuildContext context,
  ) async {
    RegisterationWare ware =
        Provider.of<RegisterationWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    ware.isLoadingUser(true);

    bool isDone = await ware
        .verifyUserFromApi(user.verifyUserModel)
        .whenComplete(() => log("complete"));

    if (isDone) {
      ware.isLoadingUser(false);
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
