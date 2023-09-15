import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpInputs extends StatefulWidget {
  final TextEditingController textEditingController;
  const OtpInputs({super.key, required this.textEditingController});

  @override
  State<OtpInputs> createState() => _OtpInputsState();
}

class _OtpInputsState extends State<OtpInputs> {
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      //backgroundColor: HexColor("#161A22"),

      appContext: context,

      pastedTextStyle: TextStyle(
        color: HexColor(primaryColor),
        fontWeight: FontWeight.bold,
      ),
      length: 5,
      obscureText: false,
      obscuringCharacter: '*',
      obscuringWidget: CircleAvatar(
        radius: 5,
        backgroundColor: HexColor(primaryColor),
      ),
      blinkWhenObscuring: true,
      animationType: AnimationType.fade,
      validator: (v) {
        if (v!.length < 5) {
          return "Incomplete";
        } else {
          return null;
        }
      },

      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 56,
        activeColor: HexColor(primaryColor),
        selectedFillColor: HexColor(backgroundColor),
        fieldWidth: 56,
        activeFillColor: HexColor(backgroundColor),
        inactiveColor: HexColor(backgroundColor),
        inactiveFillColor: HexColor(backgroundColor),
      ),

      cursorColor: HexColor(primaryColor),
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      errorAnimationController: errorController,
      controller: widget.textEditingController,
      keyboardType: TextInputType.number,
      // boxShadows: [
      //   BoxShadow(
      //     offset: Offset(0, 1),
      //     color: HexColor(backgroundColor),
      //     blurRadius: 10,
      //   )
      // ],
      onCompleted: (v) {
        debugPrint("Completed");
      },
      // onTap: () {
      //   print("Pressed");
      // },
      onChanged: (value) {
        debugPrint(value);
        setState(() {
          currentText = value;
        });
      },
      beforeTextPaste: (text) {
        debugPrint("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
    );
  }
}

class OtpSquares extends StatefulWidget {
  VoidCallback onTap;
  int? id;

  OtpSquares({super.key, required this.onTap, required this.id});

  @override
  State<OtpSquares> createState() => _OtpSquaresState();
}

class _OtpSquaresState extends State<OtpSquares> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 50,
      decoration: BoxDecoration(
        color: widget.id == 1 ? HexColor(backgroundColor) : HexColor("#FC9DBF"),
      ),
      child: widget.id == 1
          ? Center(
              child: CircleAvatar(
                radius: 10,
                backgroundColor: HexColor(primaryColor),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
