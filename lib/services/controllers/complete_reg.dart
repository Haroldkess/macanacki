import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/model/register_model.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/tab_screen.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/login_controller.dart';
import 'package:macanacki/services/middleware/facial_ware.dart';
import 'package:macanacki/services/middleware/registeration_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:macanacki/services/temps/temps_id.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/allNavigation.dart';
import '../../presentation/widgets/debug_emitter.dart';
import '../middleware/category_ware.dart';

class CompleteRegisterationController {
  static Future<RegisterUserModel> regData(BuildContext context) async {
    FacialWare pic = Provider.of<FacialWare>(context, listen: false);
       CategoryWare cat =
                              Provider.of<CategoryWare>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    RegisterUserModel data = RegisterUserModel(
        username: pref.getString(userNameKey),
        genderId: pref.getInt(genderId),
        dob: pref.getString(dobKey),
        email: pref.getString(emailKey),
        password: pref.getString(passwordKey),
        photo: pic.addedPhoto,
        country: pref.getString(countryKey),
        state: pref.getString(stateKey) ,
        city:  pref.getString(cityKey),
        catId: cat.selected.id.toString(),);
    return data;
  }

  static Future<void> registerationController(
      BuildContext context, bool isSplash) async {
    RegisterationWare ware =
        Provider.of<RegisterationWare>(context, listen: false);
    Temp temp = Provider.of<Temp>(context, listen: false);

    RegisterUserModel data = await regData(context);
    ware.isLoading3(true);

    bool isDone = await ware
        .registerUserFromApi(data)
        .whenComplete(() => emitter("api function done"));

    if (isDone) {
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message2, isError: false);
      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      temp.addIsLoggedInTemp(true);
      SharedPreferences pref = await SharedPreferences.getInstance();

      // ignore: use_build_context_synchronously
      await LoginController.loginUserController(context,
          pref.getString(emailKey)!, pref.getString(passwordKey)!, isSplash);
      ware.isLoading3(false);

      // ignore: use_build_context_synchronously
      //  PageRouting.removeAllToPage(context, const TabScreen());
    } else {
      await ware.isLoading3(false);
      // ignore: use_build_context_synchronously
      showToast2(context, ware.message2, isError: true);
      //print("something went wrong");
    }
    await ware.isLoading3(false);
  }
}
