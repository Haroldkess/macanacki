import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexagon/hexagon.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/onboarding/email_screen.dart';
import 'package:makanaki/presentation/screens/onboarding/user_name.dart';
import 'package:makanaki/presentation/widgets/app_icon.dart';
import 'package:makanaki/services/controllers/login_controller.dart';
import 'package:makanaki/services/middleware/login_ware.dart';
import 'package:provider/provider.dart';

import '../../constants/params.dart';
import '../../widgets/buttons.dart';
import '../../widgets/loader.dart';
import '../../widgets/text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  bool hide1 = true;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    var padding = 8.0;
    var w = (size.width - 4 * 1) / 6;
    LoginWare stream = context.watch<LoginWare>();
    return Scaffold(
      backgroundColor: HexColor(primaryColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: height * 0.33,
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
                                    "assets/icon/profile.svg",
                                    color: HexColor(backgroundColor),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    AppText(
                      text: "Welcome",
                      fontWeight: FontWeight.w400,
                      size: 20,
                      align: TextAlign.center,
                      color: HexColor(backgroundColor),
                    ),
                    // AppText(
                    //   text: "usertagname@email.com",
                    //   fontWeight: FontWeight.w400,
                    //   size: 16,
                    //   align: TextAlign.center,
                    //   color: HexColor(backgroundColor),
                    // ),
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
                              text: "Login ",
                              size: 24,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              color: HexColor(backgroundColor),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: width / 1.7,
                      //       child: AppText(
                      //         text: "Enter your Password to login",
                      //         size: 14,
                      //         maxLines: 3,
                      //         overflow: TextOverflow.ellipsis,
                      //         color: HexColor(backgroundColor),
                      //         fontWeight: FontWeight.w400,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                AppText(
                                  text: "Email",
                                  size: 14,
                                  color: HexColor(backgroundColor),
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: HexColor('#FC9DBF'),
                                  shape: BoxShape.rectangle,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8.0))),
                              child: TextFormField(
                                controller: email,
                                cursorColor: Colors.white,
                                validator: (value) {
                                  return EmailValidator.validate(value!)
                                      ? null
                                      : "Enter a valid email";
                                },
                                style: GoogleFonts.spartan(
                                  color: HexColor('#F5F2F9'),
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(left: 20),
                                  hintText: "Enter your email here",
                                  hintStyle: GoogleFonts.spartan(
                                      color: HexColor('#F5F2F9'), fontSize: 14),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
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
                                    style: GoogleFonts.spartan(
                                      color: HexColor('#F5F2F9'),
                                      fontSize: 14,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          left: 20, top: 17),
                                      hintText: "Enter your password here",
                                      hintStyle: GoogleFonts.spartan(
                                          color: HexColor('#F5F2F9'),
                                          fontSize: 14),
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
                                                  color: HexColor('#F5F2F9'))),
                                        ],
                                      ),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AppText(
                                      text: "Forgot Password?",
                                      size: 12,
                                      color: HexColor(backgroundColor),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: HexColor('#FC9DBF'),
                              child: SvgPicture.asset(
                                  "assets/icon/Fingerprint.svg"),
                            )
                          ],
                        ),
                      ),
                      stream.loadStatus
                          ? const Loader(color: Colors.white)
                          : AppButton(
                              width: 0.8,
                              height: 0.06,
                              color: backgroundColor,
                              text: "Continue",
                              backColor: backgroundColor,
                              curves: buttonCurves * 5,
                              textColor: primaryColor,
                              onTap: () async {
                                _submit(context);
                                // PageRouting.pushToPage(
                                //     context, const SelectUserName());
                              }),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: "Don't have an account? ",
                            color: HexColor("#FF94B7"),
                          ),
                          InkWell(
                            onTap: (){
                              PageRouting.pushToPage( 
                                    context,  EmailScreen());
                            },
                            child: AppText(
                              text: " SignUp",
                              color: HexColor(backgroundColor),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    } else {
      LoginController.loginUserController(
          context, email.text, password.text, false);
      //  RegisterEmailController.registerationController(context, email.text);
    }
    _formKey.currentState?.save();
  }
}
