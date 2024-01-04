import 'dart:developer';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/model/gender_model.dart';
import 'package:macanacki/presentation/allNavigation.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/constants/params.dart';
import 'package:macanacki/presentation/model/ui_model.dart';
import 'package:macanacki/presentation/operations.dart';
import 'package:macanacki/presentation/screens/kyc/kyc_notification.dart';
import 'package:macanacki/presentation/screens/onboarding/add_category.dart';
import 'package:macanacki/presentation/screens/onboarding/user_name.dart';
import 'package:macanacki/presentation/widgets/buttons.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/snack_msg.dart';
import 'package:macanacki/services/controllers/gender_controller.dart';
import 'package:macanacki/services/middleware/gender_ware.dart';
import 'package:macanacki/services/temps/temp.dart';
import 'package:provider/provider.dart';

import '../../uiproviders/screen/gender_provider.dart';
import '../../widgets/text.dart';
import 'business/business_info.dart';
import 'dob_screen.dart';

class SelectLocation extends StatefulWidget {
  final GenderList data;
  const SelectLocation({super.key, required this.data});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  final _cscPickerKey = GlobalKey<CSCPickerState>();
  String selectedCity = "";
  String selectedCountry = "";
  String selectedState = "";
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    genderWare watch = context.watch<genderWare>();
    genderWare genderSelected = Provider.of<genderWare>(context, listen: false);

    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontalPadding - 20),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.35,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: width / 1.2,
                        child: AppText(
                          text: "Select your region",
                          align: TextAlign.center,
                          size: 30,
                          fontWeight: FontWeight.w700,
                          color: textWhite,
                        )),
                  ],
                ),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CSCPicker(
                    key: _cscPickerKey,
                    layout: Layout.vertical,
                    countryDropdownLabel: "Select country",
                    stateDropdownLabel: "Select state",
                    cityDropdownLabel: "Select city",
                    flagState: CountryFlag.DISABLE,
                    onCountryChanged: (country) {
                      setState(() {
                        selectedCountry = country;
                      });
                      // log(country);
                    },
                    onStateChanged: (state) {
                      if (state != null) {
                        setState(() {
                          selectedState = state;
                        });
                      }
                    },
                    onCityChanged: (city) {
                      if (city != null) {
                        setState(() {
                          selectedCity = city;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
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
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submit(BuildContext context) async {
    Temp temp = Provider.of<Temp>(context, listen: false);

    if (selectedCountry.isEmpty ||
        selectedState.isEmpty ||
        selectedCity.isEmpty) {
      showToast2(context, "Select your proper location");
      return;
    } else {
      temp
          .addLocationTemp(selectedCountry, selectedState, selectedCity)
          .whenComplete(() => PageRouting.pushToPage(
              context,
              SelectCategory(
                data: widget.data,
              )));
    }
  }
}
