import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/kyc/kyc_notification.dart';
import 'package:macanacki/presentation/screens/onboarding/user_name.dart';
import 'package:macanacki/presentation/widgets/buttons.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/gender_controller.dart';
import 'package:macanacki/services/middleware/gender_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:provider/provider.dart';

import '../../uiproviders/screen/gender_provider.dart';
import '../../widgets/text.dart';
import 'business/business_info.dart';
import 'dob_screen.dart';

class SelectGender extends StatefulWidget {
  const SelectGender({super.key});

  @override
  State<SelectGender> createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    genderWare watch = context.watch<genderWare>();
    genderWare genderSelected = Provider.of<genderWare>(context, listen: false);

    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding - 20),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.35,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: width / 1.2,
                        child: AppText(
                          text: "What is your gender?",
                          align: TextAlign.center,
                          size: 30,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
            ),
            watch.loadStatus
                ? Loader(color: HexColor(primaryColor))
                : Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                          children: watch.genderList.reversed
                              .map((e) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            backgroundColor: e.selected!
                                                ? HexColor(primaryColor)
                                                : null,
                                            fixedSize: const Size(169, 48),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            side: BorderSide(
                                                color: e.selected!
                                                    ? HexColor(primaryColor)
                                                    : HexColor('#979797'),
                                                width: 1.0,
                                                style: BorderStyle.solid)),
                                        onPressed: () async {
                                          GenderList send = GenderList(
                                              name: e.name,
                                              selected: true,
                                              id: e.id);
                                          await Operations.funcAddGender(
                                              context, send);
                                        },
                                        child: Row(
                                          mainAxisAlignment: e.selected!
                                              ? MainAxisAlignment.spaceBetween
                                              : MainAxisAlignment.center,
                                          children: [
                                            AppText(
                                              text: e.name!,
                                              scaleFactor: 0.8,
                                              color: e.selected!
                                                  ? HexColor(backgroundColor)
                                                  : HexColor('#979797'),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            e.selected!
                                                ? CircleAvatar(
                                                    radius: 13,
                                                    backgroundColor: HexColor(
                                                        backgroundColor),
                                                    child: Icon(
                                                      Icons.done,
                                                      size: 20,
                                                      color: HexColor(
                                                          primaryColor),
                                                    ),
                                                  )
                                                : const SizedBox.shrink()
                                          ],
                                        )),
                                  ))
                              .toList()),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: AppButton(
                            width: 0.8,
                            height: 0.06,
                            color: primaryColor,
                            text: "Continue",
                            backColor: primaryColor,
                            curves: buttonCurves * 5,
                            textColor: backgroundColor,
                            onTap: () async {
                              genderSelected.genderList.forEach((element) {
                                if (element.selected!) {
                                  log(element.name! +
                                      "  is selected" +
                                      " With id " +
                                      element.id.toString());
                                  _submit(context, element);
                                }
                              });
                            }),
                      ),
                    ],
                  ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      GenderController.retrievGenderController(context);
    });
  }

  Future<void> _submit(BuildContext context, GenderList data) async {
    Temp temp = Provider.of<Temp>(context, listen: false);
    print(data.name);
    if (data.name == "Business") {
      temp.addGenderIdTemp(data.id!).whenComplete(() => PageRouting.pushToPage(
          context,
          BusinessInfo(
            data: data,
          )));
    } else {
      temp.addGenderIdTemp(data.id!).whenComplete(() => PageRouting.pushToPage(
          context,
          SelectUserName(
            genderId: data.id!,
          )));
    }
  }
}
