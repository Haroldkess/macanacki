import 'package:dotted_border/dotted_border.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:makanaki/presentation/screens/onboarding/business/business_modal.dart';
import 'package:makanaki/presentation/screens/onboarding/business/business_verification.dart';
import 'package:makanaki/presentation/widgets/snack_msg.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../../../../model/gender_model.dart';
import '../../../../services/middleware/create_post_ware.dart';
import '../../../allNavigation.dart';
import '../../../constants/params.dart';
import '../../../operations.dart';
import '../../../widgets/buttons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../widgets/text.dart';

class BusinessInfo extends StatefulWidget {
  final GenderList data;
  const BusinessInfo({super.key, required this.data});

  @override
  State<BusinessInfo> createState() => _BusinessInfoState();
}

class _BusinessInfoState extends State<BusinessInfo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController businessName = TextEditingController();
  TextEditingController businessEmail = TextEditingController();
  TextEditingController businessPhone = TextEditingController();
  TextEditingController businessDecription = TextEditingController();
  TextEditingController businessRegNumber = TextEditingController();
  TextEditingController businessAddress = TextEditingController();
  bool iAgree = true;
  String choosenCountry = "";
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    CreatePostWare picked = context.watch<CreatePostWare>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(children: [
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppText(
            text: "Verify Business",
            size: 30,
            color: HexColor("#222222"),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        BusinessForm(
          title: "Registered Business Name",
          hint: "Enter your Registered Business Name here",
          controller: businessName,
        ),
        const SizedBox(
          height: 20,
        ),
        BusinessForm(
          title: "Business Email",
          hint: "Enter your email here",
          controller: businessEmail,
          formKey: _formKey,
          isEmail: true,
        ),
        const SizedBox(
          height: 20,
        ),
        BusinessForm(
          title: "Phone Number",
          hint: "Enter your  Business phonenumber",
          controller: businessPhone,
          isNumber: true,
        ),
        const SizedBox(
          height: 20,
        ),
        BusinessForm(
          title: "Description",
          hint: "Tell us about your business",
          controller: businessDecription,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Checkbox(
                    fillColor: MaterialStatePropertyAll(HexColor(primaryColor)),
                    value: iAgree,
                    onChanged: ((value) {
                      setState(() {
                        iAgree = value!;
                      });
                    })),
              ),
              SizedBox(
                width: width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Yes, its a registered business ",
                        style: GoogleFonts.spartan(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: HexColor(darkColor),
                                decorationStyle: TextDecorationStyle.solid,
                                fontSize: 12)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: RichText(
                        text: TextSpan(
                          text:
                              "Tick this box if your business is a registered business.",
                          style: GoogleFonts.spartan(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: HexColor("#606060"),
                                  decorationStyle: TextDecorationStyle.solid,
                                  fontSize: 8)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  AppText(
                    text: "Country of Registration",
                    size: 12,
                    color: HexColor("#222222"),
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                    exclude: <String>['KN', 'MF'],
                    favorite: <String>['NG'],
                    //Optional. Shows phone code before the country name.
                    showPhoneCode: false,
                    onSelect: (Country country) {
                      print('Select country: ${country.name}');
                      setState(() {
                        choosenCountry = country.name;
                      });
                    },
                    // Optional. Sets the theme for the country list picker.
                    countryListTheme: CountryListThemeData(
                      // Optional. Sets the border radius for the bottomsheet.
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      // Optional. Styles the search field.
                      inputDecoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Start typing to search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                      // Optional. Styles the text in the search field
                      searchTextStyle: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 51,
                  decoration: BoxDecoration(
                      color: HexColor('#F5F2F9'),
                      shape: BoxShape.rectangle,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: AppText(
                            text: choosenCountry.isEmpty
                                ? "Choose country of registration"
                                : choosenCountry,
                            color: HexColor('#C0C0C0'),
                            size: 12),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.arrow_drop_down_outlined,
                          color: HexColor("#A6ABB7"),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        BusinessForm(
          title: "Business Registration Number",
          hint: "E.g. RC, BN etc",
          controller: businessRegNumber,
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          height: 20,
        ),
        BusinessForm(
          title: "Business Address",
          hint: "Enter Your Business address here",
          controller: businessAddress,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppText(
            text: "Upload Evidence",
            size: 15,
            color: HexColor("#222222"),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: AppText(
            text:
                "Please upload supporting documents to show proof of business registration",
            size: 12,
            color: HexColor("#5F5F5F"),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DottedBorder(
            dashPattern: [5, 8],
            borderType: BorderType.RRect,
            radius: Radius.circular(12),
            padding: EdgeInsets.all(0),
            color: HexColor("#818181").withOpacity(0.5),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: InkWell(
                onTap: () => Operations.pickId(context, false),
                child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: HexColor("#F5F2F9").withOpacity(0.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/icon/upload2.svg"),
                        const SizedBox(width: 15),
                        AppText(
                          text: picked.idBusiness != null
                              ? basename(picked.idBusiness!.path)
                              : "Upload means of Identification",
                          size: 12,
                          color: HexColor("#B3B3B3"),
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        AppButton(
            width: 0.8,
            height: 0.06,
            color: backgroundColor,
            text: "Continue",
            backColor: primaryColor,
            curves: buttonCurves * 5,
            textColor: backgroundColor,
            onTap: () async {
              _submit(context);
              //  PageRouting.pushToPage(context, const BusinessVerification());
            }),
        const SizedBox(
          height: 50,
        ),
      ]),
    );
  }

  _submit(context) async {
    CreatePostWare picked = Provider.of<CreatePostWare>(context, listen: false);
    if (iAgree == false ||
        businessName.text.isEmpty ||
        businessEmail.text.isEmpty ||
        businessPhone.text.isEmpty ||
        businessDecription.text.isEmpty ||
        businessRegNumber.text.isEmpty ||
        businessAddress.text.isEmpty ||
        choosenCountry.isEmpty ||
        picked.idBusiness == null) {
      showToast2(context, "iNCOMPLETE FORM");
      return;
    } else {
      RegisterBusinessModel registerBusinessModel = RegisterBusinessModel(
        busName: businessName.text,
        phone: businessPhone.text,
        email: businessEmail.text,
        description: businessDecription.text,
        regNo: businessRegNumber.text,
        businessAddress: businessAddress.text,
        country: choosenCountry,
        evidence: picked.idBusiness,
        isReg: "is_registered",
      );
      PageRouting.pushToPage(
          context,
          BusinessVerification(
            data: registerBusinessModel,
            gender: widget.data,
          ));
    }
  }
}

class BusinessForm extends StatelessWidget {
  TextEditingController? controller;
  GlobalKey<FormState>? formKey;
  String? title;
  String? hint;
  bool? isEmail;
  bool? isNumber;

  BusinessForm(
      {super.key,
      this.controller,
      this.formKey,
      this.title,
      this.hint,
      this.isNumber,
      this.isEmail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              AppText(
                text: title ?? "",
                size: 12,
                color: HexColor("#222222"),
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
                color: HexColor('#F5F2F9'),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(8.0))),
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                cursorColor: HexColor(primaryColor),
                validator: isEmail != true
                    ? null
                    : (value) {
                        return EmailValidator.validate(value!)
                            ? null
                            : "Enter a valid email";
                      },
                keyboardType: isNumber == true ? TextInputType.number : null,
                style: GoogleFonts.spartan(
                  color: Colors.black,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 20),
                  hintText: "$hint",
                  hintStyle: GoogleFonts.spartan(
                      color: HexColor('#C0C0C0'), fontSize: 12),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
