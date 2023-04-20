import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:makanaki/presentation/constants/colors.dart';
import 'package:makanaki/presentation/screens/home/profile/editprofileextra/about_me.dart';
import 'package:makanaki/presentation/screens/home/profile/editprofileextra/edit_gender.dart';
import 'package:makanaki/presentation/screens/home/profile/editprofileextra/edit_studies.dart';
import 'package:makanaki/presentation/screens/home/profile/editprofileextra/my_num.dart';
import 'package:makanaki/presentation/screens/home/profile/editprofileextra/profile_pic.dart';
import 'package:makanaki/presentation/screens/home/profile/editprofileextra/select_profile_settings.dart';
import 'package:makanaki/presentation/widgets/buttons.dart';
import 'package:makanaki/presentation/widgets/loader.dart';
import 'package:makanaki/presentation/widgets/text.dart';
import 'package:makanaki/services/controllers/edit_profile_controller.dart';
import 'package:makanaki/services/middleware/edit_profile_ware.dart';
import 'package:makanaki/services/middleware/user_profile_ware.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final String? aboutMe;
  final String? phone;
  const EditProfile({super.key, required this.aboutMe, required this.phone});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
 late TextEditingController about;

late  TextEditingController phone ;
  @override
  void initState() {
    super.initState();
    about = TextEditingController(text: widget.aboutMe ?? "");
    phone = TextEditingController(text: widget.phone ?? "");
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
                    // SizedBox(
                    //   height: 30,
                    // ),
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

    EditProfileController.editProfileController(
        context, about.text, phone.text);
  }
}
