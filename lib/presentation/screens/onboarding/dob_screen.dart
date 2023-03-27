import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/allNavigation.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/operations.dart';
import 'package:makanaki/presentation/screens/onboarding/add_photo_screen.dart';
import 'package:makanaki/presentation/uiproviders/dob/dob_provider.dart';
import 'package:makanaki/presentation/widgets/buttons.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/temps/temp.dart';
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
                    dayMonthYear(context, width, height, watch.month),
                    dayMonthYear(context, width, height, watch.year),
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

  InkWell dayMonthYear(
      BuildContext context, double width, double height, String text) {
    return InkWell(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(), //get today's date
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
        height: 56,
        width: width * 0.4,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
                color: HexColor("#C0C0C0"),
                style: BorderStyle.solid,
                width: 1.0),
            borderRadius:
                const BorderRadius.all(Radius.circular(buttonCurves * 5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [AppText(text: text), Icon(Icons.arrow_drop_down)],
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
        temp.addDobTemp(formattedDate).whenComplete(
            () => PageRouting.pushToPage(context, const AddPhotoScreen()));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
