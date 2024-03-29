import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:macanacki/presentation/constants/colors.dart';
import 'package:macanacki/presentation/screens/home/profile/editprofileextra/about_me.dart';
import 'package:macanacki/presentation/screens/home/profile/editprofileextra/edit_gender.dart';
import 'package:macanacki/presentation/screens/home/profile/editprofileextra/edit_studies.dart';
import 'package:macanacki/presentation/screens/home/profile/editprofileextra/my_num.dart';
import 'package:macanacki/presentation/screens/home/profile/editprofileextra/profile_pic.dart';
import 'package:macanacki/presentation/screens/home/profile/editprofileextra/select_profile_settings.dart';
import 'package:macanacki/presentation/widgets/buttons.dart';
import 'package:macanacki/presentation/widgets/loader.dart';
import 'package:macanacki/presentation/widgets/text.dart';
import 'package:macanacki/services/controllers/edit_profile_controller.dart';
import 'package:macanacki/services/middleware/edit_profile_ware.dart';
import 'package:macanacki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

import '../../../operations.dart';
import 'editprofileextra/website.dart';

class EditProfile extends StatefulWidget {
  final String? aboutMe;
  final String? phone;
  final String? web;
  const EditProfile(
      {super.key,
      required this.aboutMe,
      required this.phone,
      required this.web});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _cscPickerKey = GlobalKey<CSCPickerState>();
  String selectedCity = "";
  String selectedCountry = "";
  String selectedState = "";
  late TextEditingController about;

  late TextEditingController phone;
  late TextEditingController website;
  @override
  void initState() {
    super.initState();
    about = TextEditingController(text: widget.aboutMe ?? "");
    phone = TextEditingController(text: widget.phone ?? "");
    website = TextEditingController(text: widget.web ?? "");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      UserProfileWare user =
          Provider.of<UserProfileWare>(context, listen: false);
      setState(() {
        selectedCountry = user.userProfileModel.country ?? "";
        selectedState = user.userProfileModel.state ?? "";
        selectedCity = user.userProfileModel.city ?? "";
      });
    });

    //  Operations.controlSystemColor();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    UserProfileWare user = context.watch<UserProfileWare>();
    EditProfileWare stream = context.watch<EditProfileWare>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: AppText(
            text: 'Profile',
            fontWeight: FontWeight.w400,
            size: 24,
            color: textWhite,
          ),
          centerTitle: true,
          backgroundColor: HexColor(backgroundColor),
          elevation: 0,
          leading: BackButton(color: textWhite),
        ),
        body: Container(
          height: height,
          width: width,
          color: backgroundSecondary,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // const ProfilePicture(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      EditAboutMe(
                        about: about,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyPhone(
                        phone: phone,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyWebsite(
                        web: website,
                      ),
                      // EditSelectGender(),
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, left: 0),
                            child: Row(
                              children: [
                                AppText(
                                    text: "Your Location",
                                    fontWeight: FontWeight.w600,
                                    size: 17,
                                    color: textWhite)
                              ],
                            ),
                          ),
                          CSCPicker(
                            key: _cscPickerKey,
                            layout: Layout.vertical,
                            countryDropdownLabel: "Select country",
                            stateDropdownLabel: "Select state",
                            cityDropdownLabel: "Select city",
                            currentCity:
                                user.userProfileModel.city ?? "Select city",
                            currentState:
                                user.userProfileModel.state ?? "Select state",
                            currentCountry: user.userProfileModel.country ??
                                "Select country",
                            flagState: CountryFlag.DISABLE,
                            disableCountry: true,
                            onCountryChanged: (country) {
                              if (country != "Select country") {
                                setState(() {
                                  selectedCountry = country;
                                });
                              }

                              // log(country);
                            },
                            onStateChanged: (state) {
                              if (state != null && state != "Select state") {
                                setState(() {
                                  selectedState = state;
                                });
                              }
                            },
                            onCityChanged: (city) {
                              if (city != null && city != "Select city") {
                                setState(() {
                                  selectedCity = city;
                                });
                              }
                            },
                          ),
                        ],
                      ),

                      //  EditStudies(),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      //   EditProfileSetting(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                stream.loadStatus
                    ? Loader(color: textWhite)
                    : AppButton(
                        width: 0.8,
                        height: 0.09,
                        color: backgroundColor,
                        text: "Save",
                        backColor: backgroundColor,
                        onTap: () => submit(context),
                        curves: 40,
                        textColor: "#FFFFFF"),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  submit(context) async {
    UserProfileWare user = Provider.of<UserProfileWare>(context, listen: false);

    // if (about.text.isEmpty) {
    //   about.text = "";
    // } else if (about.text.isEmpty) {
    //   phone.text = "";
    // }

    EditProfileController.editProfileController(context, about.text, phone.text,
        website.text, selectedCountry, selectedState, selectedCity);
  }
}
