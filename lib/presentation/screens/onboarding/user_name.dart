import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/screens/onboarding/select_gender.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/register_username_controller.dart';
import 'package:makanaki/services/temps/temp.dart';
import 'package:provider/provider.dart';

import '../../../services/middleware/registeration_ware.dart';
import '../../allNavigation.dart';
import '../../widgets/buttons.dart';
import '../../widgets/loader.dart';

class SelectUserName extends StatefulWidget {
  const SelectUserName({super.key});

  @override
  State<SelectUserName> createState() => _SelectUserNameState();
}

class _SelectUserNameState extends State<SelectUserName> {
  TextEditingController userName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool iAgree = true;
  bool typing = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    RegisterationWare stream = context.watch<RegisterationWare>();
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding - 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height * 0.4,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: width / 1.2,
                          child: AppText(
                            text: "How would You like to be address?",
                            align: TextAlign.start,
                            size: 30,
                            fontWeight: FontWeight.w700,
                          ))
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      AppText(
                        text: "User Name",
                        size: 14,
                        color: HexColor(darkColor),
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: HexColor('#F5F2F9'),
                        shape: BoxShape.rectangle,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: userName,
                        cursorColor: HexColor(primaryColor),
                        style: GoogleFonts.spartan(
                          color: HexColor(darkColor),
                          fontSize: 14,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              typing = true;
                            });
                          } else {
                            setState(() {
                              typing = false;
                            });
                          }
                          // RegisterUsernameController.usernameController(
                          //     context, userName.text);
                        },
                        validator: ((value) {
                          if (value!.isEmpty || value.length < 3) {
                            return "username too short";
                          } else {
                            return null;
                          }
                        }),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20),
                          hintText: "Enter your User name here",
                          hintStyle: GoogleFonts.spartan(
                              color: HexColor('#C0C0C0'), fontSize: 14),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Checkbox(
                          fillColor:
                              MaterialStatePropertyAll(HexColor(primaryColor)),
                          value: iAgree,
                          onChanged: ((value) {
                            setState(() {
                              iAgree = value!;
                            });
                          })),
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        width: width * 0.7,
                        child: RichText(
                          text: TextSpan(
                              text: "I consent to the The MacaNacki",
                              style: GoogleFonts.spartan(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: HexColor(darkColor),
                                      decorationStyle:
                                          TextDecorationStyle.solid,
                                      fontSize: 12)),
                              children: [
                                TextSpan(
                                  text: "Terms of Use",
                                  style: GoogleFonts.spartan(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: HexColor(primaryColor),
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          fontSize: 12)),
                                ),
                                TextSpan(
                                  text: " and ",
                                  style: GoogleFonts.spartan(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: HexColor(darkColor),
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          fontSize: 12)),
                                ),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: GoogleFonts.spartan(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: HexColor(primaryColor),
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          fontSize: 12)),
                                )
                              ]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  stream.loadStatus2
                      ? Loader(color: HexColor(primaryColor))
                      : AppButton(
                          width: 0.9,
                          height: 0.06,
                          color: typing ? primaryColor : "#AEAEAE",
                          text: "Continue",
                          backColor: typing ? primaryColor : "#AEAEAE",
                          curves: buttonCurves * 5,
                          textColor: backgroundColor,
                          onTap: () async {
                            if (iAgree) {
                              _submit(context);
                            } else {
                              showToast(
                                  context,
                                  "Please consent to the terms of use",
                                  HexColor(primaryColor));
                            }
                            //  PageRouting.pushToPage(context, const SelectGender());
                          })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final isValid = _formKey.currentState?.validate();
    Temp saveUsername = Provider.of<Temp>(context, listen: false);
    if (!isValid! || userName.text.isEmpty && typing == false) {
      return;
    } else {
      saveUsername.addUserNameTemp(userName.text).whenComplete(() =>
          RegisterUsernameController.usernameController(
              context, userName.text));
    }
    _formKey.currentState?.save();
  }
}
