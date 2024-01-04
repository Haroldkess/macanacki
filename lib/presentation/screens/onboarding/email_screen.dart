import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/screens/onboarding/login_screen.dart';
import 'package:macanacki/presentation/screens/verification/otp_screen.dart';
import 'package:macanacki/presentation/widgets/app_icon.dart';
import 'package:macanacki/presentation/widgets/buttons.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/register_email_controller.dart';
import 'package:macanacki/services/middleware/registeration_ware.dart';
import 'package:provider/provider.dart';

import '../../widgets/snack_msg.dart';

class EmailScreen extends StatefulWidget {
  EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    RegisterationWare stream = context.watch<RegisterationWare>();

    return Scaffold(
      backgroundColor: Colors.black,
      //   backgroundColor: HexColor(primaryColor),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.37,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  AppIcon(
                    width: 40.3,
                    height: 40,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      AppText(
                        text: "Welcome",
                        size: 25,
                        color: textWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      AppText(
                        text: "Enter your email address to get started",
                        size: 12,
                        color: textWhite,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      AppText(
                        text: "Email",
                        size: 14,
                        color: textWhite,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        //   color: HexColor('#FC9DBF'),
                        shape: BoxShape.rectangle,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: email,
                        cursorColor: Colors.black,
                        validator: (value) {
                          return EmailValidator.validate(value!)
                              ? null
                              : "Enter a valid email";
                        },
                        style: GoogleFonts.leagueSpartan(
                          color: Colors.black,
                          //  color: HexColor('#F5F2F9'),
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20),
                          hintText: "Enter your email here",
                          hintStyle: GoogleFonts.leagueSpartan(
                              //  color: HexColor('#F5F2F9'),
                              color: Colors.black,
                              fontSize: 16),
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
                  stream.loadStatus
                      ? const Loader(color: Colors.white)
                      : AppButton(
                          width: 0.8,
                          height: 0.06,
                          color: "#FFFFFF",
                          text: "Continue",
                          backColor: "#FFFFFF",
                          curves: buttonCurves * 5,
                          textColor: backgroundColor,
                          onTap: () async {
                            await _submit(context);
                            //  PageRouting.pushToPage(context, const EmailOtp());
                          }),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: "Already have an account? ",
                        // color: HexColor("#FF94B7"),
                        color: Colors.white,
                      ),
                      InkWell(
                        onTap: () async {
                          PageRouting.pushToPage(context, const LoginScreen());
                        },
                        child: AppText(
                          text: " Login",
                          color: textWhite,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    } else {
      final fcmId = await _getToken();
      RegisterEmailController.registerationController(
          context, email.text, fcmId);
    }
    _formKey.currentState?.save();
  }

  Future<String> _getToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      debugPrint("token is $token");
      return token ?? "";
    } catch (e) {
      return "";
    }
  }
}
