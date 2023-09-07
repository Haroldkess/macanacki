import 'package:email_validator/email_validator.dart';
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
import 'package:macanacki/services/controllers/forget_pass_controller.dart';
import 'package:macanacki/services/controllers/register_email_controller.dart';
import 'package:macanacki/services/middleware/registeration_ware.dart';
import 'package:provider/provider.dart';

class ForgetPasswordEmail extends StatefulWidget {
  ForgetPasswordEmail({super.key});

  @override
  State<ForgetPasswordEmail> createState() => _ForgetPasswordEmailState();
}

class _ForgetPasswordEmailState extends State<ForgetPasswordEmail> {
  TextEditingController email = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    RegisterationWare stream = context.watch<RegisterationWare>();

    return Scaffold(
      backgroundColor: HexColor(primaryColor),
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
                    width: 22.3,
                    height: 20,
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
                        text: "Forget password",
                        size: 25,
                        color: HexColor(backgroundColor),
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
                        color: HexColor(backgroundColor),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0))),
                    child: Form(
                      key: _formKey,
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
                          contentPadding: const EdgeInsets.only(left: 20),
                          hintText: "Enter your email here",
                          hintStyle: GoogleFonts.spartan(
                              color: HexColor('#F5F2F9'), fontSize: 12),
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
                  stream.sendForgetOtp
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
                        color: HexColor("#FF94B7"),
                      ),
                      InkWell(
                        onTap: () async {
                          PageRouting.pushToPage(context, const LoginScreen());
                        },
                        child: AppText(
                          text: " Login",
                          color: HexColor(backgroundColor),
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

  void _submit(BuildContext context) {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    } else {
// call otp mfunc
      ForgetPasswordController.resetPass(context, email.text);
    }
    _formKey.currentState?.save();
  }
}
