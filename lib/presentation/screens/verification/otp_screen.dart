import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/screens/onboarding/login_screen.dart';
import 'package:makanaki/presentation/screens/onboarding/user_name.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:makanaki/presentation/widgets/otp.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/services/controllers/otp_controller.dart';
import 'package:makanaki/services/middleware/otp_ware.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/params.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/buttons.dart';
import '../../widgets/text.dart';

class EmailOtp extends StatefulWidget {
  final String email;
  const EmailOtp({super.key, required this.email});

  @override
  State<EmailOtp> createState() => _EmailOtpState();
}

class _EmailOtpState extends State<EmailOtp> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    OtpWare stream = context.watch<OtpWare>();
    return Scaffold(
      backgroundColor: HexColor(primaryColor),
      body: SizedBox(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: height * 0.42,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 56,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: HexColor('#FC9DBF'),
                              child: SvgPicture.asset("assets/icon/email.svg"),
                            )
                          ],
                        ),
                      ),
                      AppText(
                        text: "Verify Email",
                        fontWeight: FontWeight.w700,
                        size: 25,
                        align: TextAlign.center,
                        color: HexColor(backgroundColor),
                      )
                    ],
                  )),
              Container(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                text:
                                    "Please enter the Code sent to ${widget.email}",
                                size: 12,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                color: HexColor(backgroundColor),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            AppText(
                              text: "OTP",
                              size: 14,
                              color: HexColor(backgroundColor),
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        OtpInputs(
                          textEditingController: textEditingController,
                        ),
                        const SizedBox(
                          height: 25,
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
                                onTap: () {
                                  _Submit(context);
                                  // PageRouting.pushToPage(
                                  //     context, const SelectUserName());
                                }),
                      ],
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: "Not You? ",
                              color: HexColor("#FF94B7"),
                            ),
                            InkWell(
                              child: AppText(
                                text: "Switch Account",
                                color: HexColor(backgroundColor),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 93,
                        )
                      ],
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  _Submit(BuildContext context) async {
    if (textEditingController.text.length < 4) {
      showToast(context, "Invalid Otp", Colors.red);
      return;
    } else {
      VerifyEmailController.verifyEmailController(
          context, textEditingController.text);
    }
  }
}
