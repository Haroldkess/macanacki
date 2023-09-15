import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/onboarding/add_password.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:provider/provider.dart';

import '../../../services/middleware/facial_ware.dart';
import '../../../services/temps/temp.dart';
import '../../allNavigation.dart';
import '../../constants/colors.dart';
import '../../constants/params.dart';
import '../../widgets/buttons.dart';
import '../../widgets/text.dart';
import '../home/tab_screen.dart';

class AddPhotoScreen extends StatefulWidget {
  const AddPhotoScreen({super.key});

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    FacialWare stream = context.watch<FacialWare>();
    FacialWare pic = Provider.of<FacialWare>(context, listen: false);
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
                Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: width * 0.9,
                        child: AppText(
                          text: "Add Photos",
                          color: HexColor(darkColor),
                          fontWeight: FontWeight.w700,
                          size: 30,
                          align: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: width * 0.9,
                        child: AppText(
                          text: "Add atleast one photo to continue",
                          color: HexColor(darkColor),
                          fontWeight: FontWeight.w600,
                          size: 17,
                          align: TextAlign.center,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                DottedBorder(
                  dashPattern: [5, 8],
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  padding: EdgeInsets.all(6),
                  color: HexColor("#818181").withOpacity(0.5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    child: InkWell(
                      onTap: pic.addedPhoto == null
                          ? null
                          : () => Operations.addPhotoFromGallery(context),
                      child: Container(
                        height: 256,
                        width: 246,
                        decoration: BoxDecoration(
                          color: HexColor("#C7C7C7").withOpacity(0.3),
                          image: stream.addedPhoto != null
                              ? DecorationImage(
                                  image: FileImage(stream.addedPhoto!))
                              : null,
                        ),
                        child: stream.addedPhoto != null
                            ? const SizedBox.shrink()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        Operations.addPhotoFromGallery(context),
                                    child: Center(
                                      child: CircleAvatar(
                                        radius: 27,
                                        backgroundColor: HexColor(primaryColor),
                                        child: Icon(Icons.add),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  AppText(text: "Add photo")
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                AppButton(
                    width: 0.85,
                    height: 0.06,
                    color: stream.addedPhoto == null ? "#AEAEAE" : primaryColor,
                    text: "Continue",
                    backColor:
                        stream.addedPhoto == null ? "#AEAEAE" : primaryColor,
                    curves: buttonCurves * 5,
                    textColor: backgroundColor,
                    onTap: () {
                      _submit(context);
                    }),
              ],
            )),
            SizedBox(
              height: height * 0.15,
              //  color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  _submit(BuildContext context) async {
    FacialWare facial = Provider.of<FacialWare>(context, listen: false);
    Temp temp = Provider.of<Temp>(context, listen: false);

    try {
      if (facial.addedPhoto == null) {
        showToast(context, "Please add a photo", Colors.red);
      } else {
        await temp
            .addPhotoTemp(facial.addedPhoto!.path.toString())
            .whenComplete(() =>
                PageRouting.pushToPage(context, const AddPasswordScreen()));
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
