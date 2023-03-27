import 'package:flutter/material.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/constants/params.dart';
import 'package:makanaki/presentation/screens/onboarding/email_screen.dart';
import 'package:makanaki/presentation/screens/onboarding/login_screen.dart';
import 'package:makanaki/presentation/widgets/app_icon.dart';
import 'package:makanaki/presentation/widgets/buttons.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/pic/background.png'))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: height / 2,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Padding(
                              padding: EdgeInsets.only(
                                top: 40.0,
                              ),
                              child: AppIcon())
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          AppButton(
                              onTap: () {
                            
                                PageRouting.pushToPage(
                                    context, const   LoginScreen());
                              },
                              width: 0.4,
                              height: 0.05,
                              color: backgroundColor,
                              backColor: "null",
                              textColor: backgroundColor,
                              curves: buttonCurves,
                              text: "LOGIN"),
                          AppButton(
                            onTap: () {
                              PageRouting.pushToPage(
                                  context,  EmailScreen());
                            },
                            width: 0.4,
                            height: 0.05,
                            color: backgroundColor,
                            text: "SIGNUP",
                            backColor: darkColor,
                            textColor: backgroundColor,
                            curves:  buttonCurves,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
