import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/model/register_model.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/onboarding/business/business_modal.dart';
import 'package:macanacki/presentation/screens/onboarding/business/id_type.dart';
import 'package:macanacki/presentation/screens/onboarding/business/sub_plan.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../../model/gender_model.dart';
import '../../../../services/api_url.dart';
import '../../../../services/controllers/plan_controller.dart';
import '../../../../services/controllers/url_launch_controller.dart';
import '../../../../services/controllers/verify_controller.dart';
import '../../../../services/middleware/create_post_ware.dart';
import '../../../../services/middleware/registeration_ware.dart';
import '../../../allNavigation.dart';
import '../../../constants/colors.dart';
import '../../../constants/params.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/snack_msg.dart';
import '../../../widgets/text.dart';
import '../user_name.dart';
import 'business_info.dart';

class BusinessVerification extends StatefulWidget {
  final RegisterBusinessModel? data;
  final GenderList gender;
  final bool isBusiness;
  final String action;
  const BusinessVerification(
      {super.key,
      this.data,
      required this.gender,
      required this.isBusiness,
      required this.action});

  @override
  State<BusinessVerification> createState() => _BusinessVerificationState();
}

class _BusinessVerificationState extends State<BusinessVerification> {
  TapGestureRecognizer tapGestureRecognizer = TapGestureRecognizer();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController id = TextEditingController();
  bool iAgree = true;
  @override
  Widget build(BuildContext context) {
    CreatePostWare picked = context.watch<CreatePostWare>();
    UserProfileWare user = context.watch<UserProfileWare>();
    RegisterationWare stream = context.watch<RegisterationWare>();
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundSecondary,
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        leading: BackButton(color: textWhite),
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          BusinessForm(
            title: "Your Full Name",
            hint: "Enter Your Real Name here",
            controller: name,
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          BusinessForm(
            title: "Your Address",
            hint: "Enter Your Address here",
            controller: address,
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppText(
              text: "Photo ID",
              size: 18,
              color: textWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppText(
              text:
                  "Take a clear photo of your government ID (Must be one of Int. Pass, Driver Lincense, Etc) Make sure lighting is good and any lettering is clear before uploading. for best results, please use a mobile device.",
              size: 12,
              color: textPrimary,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              onTap: () => idModal(context),
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "Choose ID Type",
                              size: 16,
                              color: textWhite,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            AppText(
                              text: user.id.isEmpty ? "select" : user.id,
                              size: 10,
                              color: HexColor("#818181"),
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                          color: textPrimary,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          BusinessForm(
            title: "ID Number",
            hint: "Enter ID Number here",
            controller: id,
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () => Operations.pickId(context, true),
              child: SizedBox(
                  height: 130,
                  width: 180,
                  child: picked.idUser != null
                      ? picked.idUser!.path.contains(".pdf")
                          ? Center(
                              child: AppText(
                                text: basename(picked.idUser!.path),
                                size: 12,
                                color: textPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Image.file(picked.idUser!)
                      : SvgPicture.asset(
                          "assets/icon/upload.svg",
                          color: textWhite,
                        ))),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: [
                Checkbox(
                    fillColor: MaterialStatePropertyAll(secondaryColor),
                    value: iAgree,
                    onChanged: ((value) {
                      setState(() {
                        iAgree = value!;
                      });
                    })),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: width * 0.7,
                  child: RichText(
                    text: TextSpan(
                        text: "I consent to the use of MacaNacki ",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                                decorationStyle: TextDecorationStyle.solid,
                                fontSize: 10)),
                        children: [
                          TextSpan(
                            text: "Terms of Use",
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: secondaryColor,
                                    decorationStyle: TextDecorationStyle.solid,
                                    fontSize: 10)),
                            recognizer: tapGestureRecognizer
                              ..onTap = () async {
                                await UrlLaunchController.launchInWebViewOrVC(
                                    Uri.parse(terms));
                              },
                          ),
                          TextSpan(
                            text: " and ",
                            style: GoogleFonts.leagueSpartan(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: textPrimary,
                                    decorationStyle: TextDecorationStyle.solid,
                                    fontSize: 10)),
                          ),
                          TextSpan(
                            text: "Privacy Policy",
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: secondaryColor,
                                    decorationStyle: TextDecorationStyle.solid,
                                    fontSize: 10)),
                            recognizer: tapGestureRecognizer
                              ..onTap = () async {
                                await UrlLaunchController.launchInWebViewOrVC(
                                    Uri.parse(terms));
                              },
                          )
                        ]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          stream.loadUser
              ? Loader(color: textWhite)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AppButton(
                      width: 0.8,
                      height: 0.06,
                      color: "#ffffff",
                      text: "Continue",
                      backColor: "#ffffff",
                      curves: buttonCurves * 5,
                      textColor: backgroundColor,
                      onTap: () async {
                        _submit(context);
                      }),
                ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  _submit(context) async {
    CreatePostWare picked = Provider.of<CreatePostWare>(context, listen: false);
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);
    FocusScope.of(context).unfocus();
    Operations.controlSystemColor();
    if (iAgree == false ||
        name.text.isEmpty ||
        address.text.isEmpty ||
        id.text.isEmpty ||
        user.id.isEmpty ||
        picked.idUser == null) {
      showToast2(context, "INCOMPLETE FORM");
      return;
    } else {
      VerifyUserModel verify = VerifyUserModel(
          name: name.text,
          idType: user.id,
          idNumb: id.text,
          photo: picked.idUser,
          address: address.text);
      if (widget.action == "both") {
        user
            .saveInfoIndi(
              verify,
            )
            .whenComplete(() => PageRouting.pushToPage(
                context,
                SubscriptionPlansBusiness(
                  isBusiness: false,
                  isSubmiting: widget.action,
                )));
      } else if (widget.action == "upload") {
        user
            .saveInfoIndi(
              verify,
            )
            .whenComplete(() => VerifyController.userVerify(context, true));
      }

      //   VerifyController.business(context)
    }
  }
}
