import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/middleware/gift_ware.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/params.dart';
import '../../../../widgets/buttons.dart';
import '../../../../widgets/form.dart';
import '../../../../widgets/loader.dart';
// import 'package:macanacki/services/middleware/plan_ware.dart';
// import 'package:macanacki/services/middleware/user_profile_ware.dart';
// import 'package:provider/provider.dart';

addBankModal(
  BuildContext cont,
  int id,
  String name,
  String shortName,
) async {
  bool pay = true;
  TextEditingController accountName = TextEditingController();
  TextEditingController number = TextEditingController();

  return showModalBottomSheet(
      context: cont,
      isScrollControlled: true,
      backgroundColor: HexColor(backgroundColor),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        // PlanWare stream = context.watch<PlanWare>();
        // UserProfileWare user = context.watch<UserProfileWare>();
        // PlanWare action = Provider.of<PlanWare>(context,listen: false);
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(
                        //   "assets/icon/bank.svg",
                        //   height: 30,
                        //   width: 30,
                        //   color: HexColor(diamondColor),
                        // ),

                        SizedBox(
                          height: 10,
                        ),
                        AppText(
                          text: "$name",
                          size: 17,
                          fontWeight: FontWeight.w400,
                          color: textWhite,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        AppText(
                          text: "Add your bank details for $shortName",
                          size: 13,
                          fontWeight: FontWeight.w400,
                          align: TextAlign.center,
                          color: textPrimary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 38,
                  ),
                  Container(
                    color: backgroundSecondary,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(children: [
                        SizedBox(
                          height: 10,
                        ),
                        AppFormAccount(
                          borderRad: 5.0,
                          backColor: Colors.transparent,
                          hint: "Account Number",
                          hintColor: HexColor("#C0C0C0"),
                          controller: number,
                          textInputType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AppFormAccount(
                          borderRad: 5.0,
                          backColor: Colors.transparent,
                          hint: "Account Name",
                          hintColor: HexColor("#C0C0C0"),
                          controller: accountName,
                        ),
                        SizedBox(
                          height: 38,
                        ),
                        ObxValue((tapped) {
                          return tapped.value
                              ? Visibility(
                                  visible: tapped.value,
                                  child: Center(
                                    child: Loader(color: textWhite),
                                  ))
                              : AppButton(
                                  width: 0.8,
                                  height: 0.06,
                                  color: backgroundColor,
                                  text: "Add bank",
                                  backColor: backgroundColor,
                                  curves: buttonCurves * 5,
                                  textColor: "#FFFFFF",
                                  onTap: () async {
                                    if (number.text.isEmpty ||
                                        accountName.text.isEmpty) {
                                      showToast2(context,
                                          "Please enter bank information",
                                          isError: true);
                                      return;
                                    }
                                    // GiftWare.instance.doAddLocalBankFromApi(id,
                                    //     number.text, accountName.text, name);
                                    GiftWare.instance.doAddBankFromApi(id,
                                        number.text, accountName.text, name);

                                    //  _submit(context);
                                    //  //  PageRouting.pushToPage(context, const EmailOtp());
                                  });
                        }, GiftWare.instance.loadBank)
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
