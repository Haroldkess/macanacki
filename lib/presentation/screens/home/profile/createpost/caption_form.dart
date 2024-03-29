import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../../constants/colors.dart';

class CaptionForm extends StatefulWidget {
  TextEditingController caption;
  bool? enabled;
  CaptionForm({super.key, required this.caption, this.enabled});

  @override
  State<CaptionForm> createState() => _CaptionFormState();
}

class _CaptionFormState extends State<CaptionForm> {
  bool typing = false;
  bool done = false;
  bool increase = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundSecondary,
      //     elevation: 10,
      //  shadowColor: HexColor("#D8D1F4"),
      child: Container(
        // height: increase ? 80 : 58,
        width: 379,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: backgroundSecondary,
            shape: BoxShape.rectangle,
            border: Border.all(
                //   width: 1.0,
                //   color: HexColor("#E8E6EA"),
                style: BorderStyle.none),
            borderRadius: const BorderRadius.all(Radius.circular(8.0))),
        child: TextFormField(
          controller: widget.caption,
          enabled: widget.enabled ?? true,
          onTap: () {
            setState(() {
              done = false;
            });
          },
          onChanged: (val) {
            if (val.isNotEmpty) {
              setState(() {
                typing = true;
              });

              if (val.length > 50) {
                setState(() {
                  increase = true;
                });
              } else {
                setState(() {
                  increase = false;
                });
              }
            } else {
              setState(() {
                typing = false;
              });
            }
          },
          textInputAction: TextInputAction.go,
          maxLines: null,
          keyboardType: TextInputType.text,
          maxLength: 1500,
          cursorColor: textPrimary,
          style: GoogleFonts.roboto(color: textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: "  Say something about this post...",
            hintStyle: GoogleFonts.roboto(color: textPrimary, fontSize: 14),
            contentPadding: EdgeInsets.only(left: 15),

            // prefixIcon: Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: SvgPicture.asset(
            //     "assets/icon/sticker.svg",
            //     height: 5,
            //     width: 5,
            //     color: const Color.fromRGBO(0, 0, 0, 0.4),
            //   ),
            // ),
            // suffixIcon: Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: InkWell(
            //     onTap: () {
            //       if (typing) {
            //         setState(() {
            //           done = true;
            //         });
            //       }
            //     },
            //     child: done
            //         ? SizedBox()
            //         : SvgPicture.asset(
            //             "assets/icon/Send.svg",
            //             height: 7,
            //             width: 7,
            //             color: typing
            //                 ? HexColor(primaryColor)
            //                 : Color.fromRGBO(0, 0, 0, 0.4),
            //           ),
            //   ),
            // ),
            labelStyle: TextStyle(color: textPrimary),
            counterStyle: TextStyle(color: textPrimary),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: const BorderSide(color: Colors.transparent)),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(2.0),
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ),
      ),
    );
  }
}
