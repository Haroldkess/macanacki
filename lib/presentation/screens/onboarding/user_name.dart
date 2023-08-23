import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/screens/onboarding/select_gender.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/api_url.dart';
import 'package:macanacki/services/controllers/register_username_controller.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:provider/provider.dart';

import '../../../services/controllers/url_launch_controller.dart';
import '../../../services/middleware/registeration_ware.dart';
import '../../allNavigation.dart';
import '../../widgets/buttons.dart';
import '../../widgets/loader.dart';

class SelectUserName extends StatefulWidget {
  final int genderId;
  const SelectUserName({super.key, required this.genderId});

  @override
  State<SelectUserName> createState() => _SelectUserNameState();
}

class _SelectUserNameState extends State<SelectUserName> {
  TextEditingController userName = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  bool iAgree = true;
  bool typing = false;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    RegisterationWare stream = context.watch<RegisterationWare>();
    RegisterationWare action =
        Provider.of<RegisterationWare>(context, listen: false);
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
                            text: "How would You like to be addressed?",
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
                        border: Border.all(color: HexColor(primaryColor)),
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
                          action.verifyUsernameFromApi(value);
                          // RegisterUsernameController.usernameController(
                          //     context, userName.text);
                        },
                        validator: ((value) {
                          if (value!.isEmpty || value.length < 3) {
                            return "name too short";
                          } else {
                            return null;
                          }
                        }),
                        decoration: InputDecoration(
                          suffixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              stream.verifyName
                                  ? SvgPicture.asset("assets/icon/tickgood.svg")
                                  : SvgPicture.asset("assets/icon/tickbad.svg")
                            ],
                          ),
                          contentPadding:
                              const EdgeInsets.only(left: 20, top: 17),
                          hintText: "Enter your User name here",
                          hintStyle: GoogleFonts.spartan(
                              color: HexColor('#C0C0C0'), fontSize: 12),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        AppText(
                            text: stream.verifyName
                                ? "Username is valid"
                                : "Username already exists",
                            color: stream.verifyName
                                ? HexColor("#0597FF")
                                : HexColor("#D82323")),
                      ],
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
                              text: "I consent to the use of MacaNacki ",
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
                                  recognizer: tapGestureRecognizer
                                    ..onTap = () async {
                                      await UrlLaunchController
                                          .launchInWebViewOrVC(
                                              Uri.parse(terms));
                                    },
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
                                  recognizer: tapGestureRecognizer
                                    ..onTap = () async {
                                      await UrlLaunchController
                                          .launchInWebViewOrVC(
                                              Uri.parse(terms));
                                    },
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
                            if (action.verifyName == false) {
                              showToast2(context, "Username already exists",
                                  isError: true);
                              return;
                            }
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

    userName.text = userName.text.replaceAll(" ", "_");

    Temp saveUsername = Provider.of<Temp>(context, listen: false);
    if (!isValid! || userName.text.isEmpty && typing == false) {
      return;
    } else {
      //  print(userName.text);
      saveUsername.addUserNameTemp(userName.text).whenComplete(() =>
          RegisterUsernameController.usernameController(
              context, userName.text));
    }
    _formKey.currentState?.save();
  }
}
