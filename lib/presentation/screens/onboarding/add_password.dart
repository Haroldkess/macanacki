import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/onboarding/user_name.dart';
import 'package:macanacki/presentation/widgets/app_icon.dart';
import 'package:macanacki/services/controllers/complete_reg.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:provider/provider.dart';

import '../../../services/middleware/registeration_ware.dart';
import '../../constants/params.dart';
import '../../widgets/buttons.dart';
import '../../widgets/loader.dart';
import '../../widgets/text.dart';
import '../home/tab_screen.dart';

class AddPasswordScreen extends StatefulWidget {
  const AddPasswordScreen({super.key});

  @override
  State<AddPasswordScreen> createState() => _AddPasswordScreenState();
}

class _AddPasswordScreenState extends State<AddPasswordScreen> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool hide1 = true;
  bool hide2 = true;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 6;
    RegisterationWare stream = context.watch<RegisterationWare>();
    return Scaffold(
      backgroundColor: HexColor(primaryColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: height * 0.37,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 56,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          AppIcon(
                            width: 8,
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // CircleAvatar(
                          //   radius: 40,
                          //   backgroundColor: HexColor('#FC9DBF'),
                          //   child: SvgPicture.asset("assets/icon/email.svg"),
                          // ),

                          HexagonWidget.pointy(
                            width: w,
                            elevation: 0.0,
                            color: HexColor('#FC9DBF'),
                            padding: 2,
                            cornerRadius: 20.0,
                            child: AspectRatio(
                                aspectRatio: HexagonType.POINTY.ratio,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/icon/key.svg",
                                    color: HexColor(backgroundColor),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: width / 1.7,
                            child: AppText(
                              text: "Create Password",
                              size: 20,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              color: HexColor(backgroundColor),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width / 1.7,
                            child: AppText(
                              text: "Enter your Password ",
                              size: 12,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              color: HexColor(backgroundColor),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  AppText(
                                    text: "Password",
                                    size: 14,
                                    color: HexColor(backgroundColor),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: HexColor('#FC9DBF'),
                                        shape: BoxShape.rectangle,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: TextFormField(
                                      controller: password,
                                      cursorColor: Colors.white,
                                      obscureText: hide1 ? true : false,
                                      validator: (value) {
                                        return value!.length > 5
                                            ? null
                                            : "Password too short";
                                      },
                                      style: GoogleFonts.leagueSpartan(
                                        color: HexColor('#F5F2F9'),
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 20, top: 17),
                                        hintText: "Enter your password here",
                                        hintStyle: GoogleFonts.leagueSpartan(
                                            color: HexColor('#F5F2F9'),
                                            fontSize: 12),
                                        border: InputBorder.none,
                                        suffixIcon: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async {
                                                  if (hide1) {
                                                    setState(() {
                                                      hide1 = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      hide1 = true;
                                                    });
                                                  }
                                                },
                                                icon: Icon(
                                                    hide1 == false
                                                        ? Icons
                                                            .hide_source_outlined
                                                        : Icons
                                                            .remove_red_eye_outlined,
                                                    size: 13,
                                                    color:
                                                        HexColor('#F5F2F9'))),
                                          ],
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  AppText(
                                    text: "Confirm Password",
                                    size: 14,
                                    color: HexColor(backgroundColor),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: HexColor('#FC9DBF'),
                                        shape: BoxShape.rectangle,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: TextFormField(
                                      controller: confirmPassword,
                                      cursorColor: Colors.white,
                                      obscureText: hide2 ? true : false,
                                      validator: (value) {
                                        return value! == password.text
                                            ? null
                                            : "Password does not match";
                                      },
                                      style: GoogleFonts.leagueSpartan(
                                        color: HexColor('#F5F2F9'),
                                        fontSize: 14,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 20, top: 17),
                                        hintText: "Confirm password",
                                        hintStyle: GoogleFonts.leagueSpartan(
                                            color: HexColor('#F5F2F9'),
                                            fontSize: 12),
                                        border: InputBorder.none,
                                        suffixIcon: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async {
                                                  if (hide2) {
                                                    setState(() {
                                                      hide2 = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      hide2 = true;
                                                    });
                                                  }
                                                },
                                                icon: Icon(
                                                    hide2 == false
                                                        ? Icons
                                                            .hide_source_outlined
                                                        : Icons
                                                            .remove_red_eye_outlined,
                                                    size: 13,
                                                    color:
                                                        HexColor('#F5F2F9'))),
                                          ],
                                        ),
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      stream.loadStatus3
                          ? const Loader(color: Colors.white)
                          : AppButton(
                              width: 0.8,
                              height: 0.06,
                              color: backgroundColor,
                              text: "Continue",
                              backColor: backgroundColor,
                              curves: buttonCurves * 5,
                              textColor: primaryColor,
                              onTap: () {
                                _submit(context);
                                // PageRouting.pushToPage(context, const TabScreen());
                                // PageRouting.pushToPage(
                                //     context, const SelectUserName());
                              }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) async {
    final isValid = _formKey.currentState?.validate();
    Temp temp = Provider.of<Temp>(context, listen: false);

    if (!isValid!) {
      log("incorrect");
      return;
    } else {
      await temp.addPasswordTemp(password.text).whenComplete(() async {
        await CompleteRegisterationController.registerationController(
            context, false);
      });
    }
    _formKey.currentState?.save();
  }
}
