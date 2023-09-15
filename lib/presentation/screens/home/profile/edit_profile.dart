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

class EditProfile extends StatefulWidget {
  final String? aboutMe;
  final String? phone;
  const EditProfile({super.key, required this.aboutMe, required this.phone});

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
  @override
  void initState() {
    super.initState();
    about = TextEditingController(text: widget.aboutMe ?? "");
    phone = TextEditingController(text: widget.phone ?? "");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      UserProfileWare user =
          Provider.of<UserProfileWare>(context, listen: false);
      setState(() {
        selectedCountry = user.userProfileModel.country ?? "";
        selectedState = user.userProfileModel.state ?? "";
        selectedCity = user.userProfileModel.city ?? "";
      });
    });

    Operations.controlSystemColor();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    UserProfileWare user = context.watch<UserProfileWare>();
    EditProfileWare stream = context.watch<EditProfileWare>();
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Profile',
          fontWeight: FontWeight.w400,
          size: 24,
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: HexColor(backgroundColor),
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Container(
        height: height,
        width: width,
        color: HexColor("#F5F2F9"),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ProfilePicture(),
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
                      height: 30,
                    ),
                    MyPhone(
                      phone: phone,
                    ),
                    // EditSelectGender(),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16, left: 30),
                          child: Row(
                            children: [
                              AppText(
                                text: "Your Location",
                                fontWeight: FontWeight.w600,
                                size: 17,
                                color: HexColor("#0C0C0C"),
                              )
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
                          currentCountry:
                              user.userProfileModel.country ?? "Select country",
                          flagState: CountryFlag.DISABLE,
                          onCountryChanged: (country) {
                             if(country  != "Select country"){
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
                  ? Loader(color: HexColor(primaryColor))
                  : AppButton(
                      width: 0.8,
                      height: 0.09,
                      color: primaryColor,
                      text: "Save",
                      backColor: primaryColor,
                      onTap: () => submit(context),
                      curves: 40,
                      textColor: backgroundColor)
            ],
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
        selectedCountry, selectedState, selectedCity);
  }
}
