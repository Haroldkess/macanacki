import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/onboarding/add_password.dart';
import 'package:macanacki/presentation/screens/onboarding/add_photo_screen.dart';
import 'package:macanacki/presentation/uiproviders/dob/dob_provider.dart';
import 'package:macanacki/presentation/widgets/buttons.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:provider/provider.dart';

import '../../constants/params.dart';
import 'package:intl/intl.dart';

class DobScreen extends StatefulWidget {
  const DobScreen({super.key});

  @override
  State<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends State<DobScreen> {
  TextEditingController dateController = TextEditingController();
  @override
  void initState() {
    dateController.text = ""; //set the initial value of text field
    super.initState();
  }

  String formattedDate = "";

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    DobProvider watch = context.watch<DobProvider>();
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                height: height * 0.15,
                // color: Colors.amber,
                child: BackButton(
                  color: HexColor(darkColor),
                ),
              ),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: width * 0.9,
                    child: AppText(
                      text: "When were you born?",
                      color: HexColor(darkColor),
                      fontWeight: FontWeight.w700,
                      size: 40,
                      align: TextAlign.left,
                      maxLines: 2,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    dayMonthYear(context, width, height, watch.day, watch.month,
                        watch.year),
                    //  dayMonthYear(context, width, height, watch.year),
                  ],
                ),
                AppButton(
                    width: 0.85,
                    height: 0.06,
                    color: primaryColor,
                    text: "Continue",
                    backColor: primaryColor,
                    curves: buttonCurves * 5,
                    textColor: backgroundColor,
                    onTap: () async {
                      _submit(context);
                    }),
              ],
            )),
            SizedBox(
              height: height * 0.2,
              //  color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  InkWell dayMonthYear(BuildContext context, double width, double height,
      String d, String m, String y) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2005), //get today's date
            firstDate: DateTime(
                1970), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime.now());

        if (pickedDate != null) {
          // print(
          //     pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
          // format date in required form here we use yyyy-MM-dd that means time is removed
          print(formattedDate);
          setState(() {
            formattedDate = DateFormat('MM-yyyy').format(pickedDate);
          });
          // print(
          //     formattedDate); //formatted date output using intl package =>  2022-07-04
          //You can format date as per your need

          // print(pickedDate.month.toString());
          // print(pickedDate.year.toString());

          // setState(() {
          //   dateController.text =
          //       formattedDate; //set foratted date to TextField value.
          // });

          await Operations.funcChangeDob(context, pickedDate);
        } else {
          print("Date is not selected");
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.rectangle,
            border: Border.all(color: HexColor("#C0C0C0")),
            borderRadius: const BorderRadius.all(Radius.circular(20.0))),
        child: TextFormField(
          enabled: false,
          cursorColor: HexColor(primaryColor),
          style: GoogleFonts.leagueSpartan(
            color: HexColor(darkColor),
            fontSize: 14,
          ),
          decoration: InputDecoration(
            suffixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SvgPicture.asset("assets/icon/calendar.svg")],
            ),
            contentPadding: const EdgeInsets.only(left: 20, top: 17),
            hintText: d == "DAY" ? "Date of birth" : "$d-$m-$y",
            hintStyle: GoogleFonts.leagueSpartan(
                color: HexColor('#424242'),
                fontSize: 12,
                fontWeight: FontWeight.w600),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  _submit(BuildContext context) async {
    Temp temp = Provider.of<Temp>(context, listen: false);

    try {
      if (formattedDate.isEmpty) {
        showToast(context, "When were you born?", Colors.red);
      } else {
        //AddPhotoScreen()
        temp.addDobTemp(formattedDate).whenComplete(
            () => PageRouting.pushToPage(context, const AddPhotoScreen()));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
